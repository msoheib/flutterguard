import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_button.dart';

class OTPVerificationPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String userType;

  const OTPVerificationPage({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    required this.userType,
  });

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOTPDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  Future<void> _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _controllers.map((controller) => controller.text).join(),
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      
      // Check if user document exists
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      
      if (!userDoc.exists) {
        // Create new user document with the role from signup
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'phoneNumber': userCredential.user!.phoneNumber,
          'role': widget.userType,
          'createdAt': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
          'isProfileComplete': false,
          'applicationCount': 0,
          'profile': {
            'personalInfo': {
              'fullName': '',
              'email': '',
              'dateOfBirth': null,
              'nationality': '',
              'city': '',
              'profilePicture': '',
              'gender': '',
              'maritalStatus': '',
            },
            'aboutMe': {
              'description': '',
              'title': '',
              'summary': '',
            },
            'workExperience': [],
            'education': [],
            'skills': [],
            'languages': [],
            'certificates': [],
            'preferences': {
              'jobTypes': [],
              'expectedSalary': {
                'min': 0,
                'max': 0,
                'currency': 'SAR'
              },
              'preferredLocations': [],
              'willingToTravel': false,
              'willingToRelocate': false
            }
          }
        });
      }

      final userData = userDoc.data();
      final bool isProfileComplete = userData?['isProfileComplete'] ?? false;
      final String userRole = userData?['role'] ?? widget.userType;

      if (mounted) {
        if (!isProfileComplete) {
          if (userRole == 'company') {
            Navigator.pushReplacementNamed(context, '/company/home');
          } else {
            Navigator.pushReplacementNamed(context, '/');
          }
        } else {
          if (userRole == 'company') {
            Navigator.pushReplacementNamed(context, '/company/home');
          } else {
            Navigator.pushReplacementNamed(context, '/');
          }
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4CA6A8)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'التحقق من رقم الهاتف',
              style: TextStyle(
                color: Color(0xFF1A1D1E),
                fontSize: 30,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'تم إرسال رمز التحقق إلى ${widget.phoneNumber}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF6A6A6A),
                fontSize: 16,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 45,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _onOTPDigitChanged(index, value),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ).reversed.toList(),
            ),
            const SizedBox(height: 32),
            CustomButton(
              onPressed: _isLoading ? null : _verifyOTP,
              isLoading: _isLoading,
              child: const Text(
                'تأكيد',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500,
                  height: 0.12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
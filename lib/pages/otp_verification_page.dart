import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_button.dart';
import '../services/user_service.dart';
import '../screens/company_profile_setup_page.dart';
import '../pages/job_seeker_home_page.dart';

class OTPVerificationPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String? userType;

  const OTPVerificationPage({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    this.userType,
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
    final otp = _controllers.map((controller) => controller.text).join();
    
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all digits')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        if (widget.userType != null) {
          await UserService().createNewUser(userCredential.user!, widget.userType!);
          
          if (widget.userType == 'company') {
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user!.uid)
                .get();
            
            if (!userDoc.exists) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userCredential.user!.uid)
                  .set({
                'phoneNumber': userCredential.user!.phoneNumber,
                'role': 'jobseeker', // Default role for new users
                'createdAt': FieldValue.serverTimestamp(),
                'lastUpdated': FieldValue.serverTimestamp(),
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
            
            if (mounted) {
              if (!isProfileComplete) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompanyProfileSetupPage(),
                  ),
                );
                return;
              }
            }
          }
        }
        
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const JobSeekerHomePage()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP: $e')),
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
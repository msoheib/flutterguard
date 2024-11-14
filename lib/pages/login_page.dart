import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_button.dart';
import 'otp_verification_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    
    // Remove any spaces or dashes
    String cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');
    
    // Check if number starts with 0
    if (cleanNumber.startsWith('0')) {
      cleanNumber = cleanNumber.substring(1); // Remove leading 0
    }
    
    // Check if it's a valid Saudi number
    RegExp saudiRegex = RegExp(r'^(5\d{8})$'); // Saudi mobile numbers start with 5
    if (!saudiRegex.hasMatch(cleanNumber)) {
      return 'Please enter a valid Saudi mobile number';
    }
    
    return null;
  }

  Future<void> _verifyPhone() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String phoneNumber = _phoneController.text;
      phoneNumber = phoneNumber.replaceAll(RegExp(r'[\s-]'), '');
      
      if (phoneNumber.startsWith('0')) {
        phoneNumber = phoneNumber.substring(1);
      }
      
      if (!phoneNumber.startsWith('+966')) {
        phoneNumber = '+966$phoneNumber';
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationPage(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '9:41',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF1A1D1E),
            fontSize: 15,
            fontFamily: 'SF Pro Text',
            fontWeight: FontWeight.w600,
            height: 0.09,
            letterSpacing: -0.24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // For RTL alignment
            children: [
              const Text(
                'مرحبًا بعودتك!',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF1A1D1E),
                  fontSize: 30,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'املأ التفاصيل الخاصة بك أو سجل دخولك بواسطة وسائل التواصل الاجتماعي',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontSize: 16,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'رقم الهاتف',
                style: TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.right,
                autofocus: true,
                enableInteractiveSelection: true,
                decoration: const InputDecoration(
                  hintText: '5XXXXXXXX',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                validator: _validatePhoneNumber,
              ),
              const SizedBox(height: 24),
              const Text(
                'أو الاستمرار مع',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontSize: 16,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                  height: 0.06,
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _verifyPhone();
                        }
                      },
                isLoading: _isLoading,
                child: const Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                    height: 0.12,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'مستخدم جديد؟  ',
                        style: TextStyle(
                          color: Color(0xFF6A6A6A),
                          fontSize: 16,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w500,
                          height: 0.10,
                        ),
                      ),
                      TextSpan(
                        text: 'إنشاء حساب',
                        style: const TextStyle(
                          color: Color(0xFF4CA6A8),
                          fontSize: 16,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                          height: 0.10,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}

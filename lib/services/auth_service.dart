// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../constants/company_status.dart';
import '../models/company.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Generate unique IDs with prefixes
  String generateUserId(String type) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(9999).toString().padLeft(4, '0');
    switch (type) {
      case 'jobseeker':
        return 'JS$timestamp$random';
      case 'company':
        return 'CO$timestamp$random';
      default:
        return 'US$timestamp$random';
    }
  }

  // Create new user with custom ID
  Future<UserCredential> createUser({
    required String email,
    required String password,
    required String type,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final customId = generateUserId(type);
    
    // Create user document with custom ID
    await _firestore.collection('users').doc(customId).set({
      'email': email,
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
      'authUid': userCredential.user!.uid, // Store Firebase Auth UID for reference
    });

    return userCredential;
  }

  // Send OTP
  Future<void> sendOTP(
    String phoneNumber,
    Function(String verificationId, int? resendToken) onCodeSent,
    Function(String errorMessage) onError,
  ) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification if possible
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification Failed');
        },
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verify OTP
  Future<bool> verifyOTP(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> registerCompany(Company company) async {
    try {
      final companyData = {
        ...company.toMap(),
        'status': CompanyStatus.UNDER_REVIEW,
        'createdAt': FieldValue.serverTimestamp(),
        'statusChangedAt': FieldValue.serverTimestamp(),
        'statusHistory': [
          {
            'status': CompanyStatus.UNDER_REVIEW,
            'timestamp': FieldValue.serverTimestamp(),
          }
        ],
      };

      await _firestore.collection('companies').doc().set(companyData);
    } catch (e) {
      throw Exception('Failed to register company: $e');
    }
  }
}
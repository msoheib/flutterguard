import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createNewUser(User user, String role) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'phoneNumber': user.phoneNumber,
        'role': role,
        'applicationCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
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
            'title': '',  // Job title or professional title
            'summary': '',
          },
          'workExperience': [
            // {
            //   'title': '',
            //   'company': '',
            //   'location': '',
            //   'startDate': timestamp,
            //   'endDate': timestamp,
            //   'currentlyWorking': boolean,
            //   'description': ''
            // }
          ],
          'education': [
            // {
            //   'degree': '',
            //   'institution': '',
            //   'field': '',
            //   'startDate': timestamp,
            //   'graduationDate': timestamp,
            //   'grade': '',
            //   'location': ''
            // }
          ],
          'skills': [
            // {
            //   'name': '',
            //   'level': '' // beginner/intermediate/advanced
            // }
          ],
          'languages': [
            // {
            //   'name': '',
            //   'level': '' // basic/intermediate/fluent/native
            // }
          ],
          'certificates': [
            // {
            //   'name': '',
            //   'issuer': '',
            //   'issueDate': timestamp,
            //   'expiryDate': timestamp,
            //   'credentialId': '',
            //   'credentialUrl': ''
            // }
          ],
          'preferences': {
            'jobTypes': [], // full-time/part-time/contract
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
      }, SetOptions(merge: true));
      
      print('User profile created successfully for ${user.uid}');
    } catch (e) {
      print('Error creating user profile: $e');
      throw Exception('Failed to create user profile');
    }
  }

  Future<void> createUserAfterPhoneAuth(User user) async {
    try {
      // Check if user document already exists
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        print('Creating new user profile...');
        await createNewUser(user, 'jobseeker');
      } else {
        print('User profile already exists');
      }
    } catch (e) {
      print('Error in createUserAfterPhoneAuth: $e');
      throw Exception('Failed to create/verify user profile');
    }
  }

  // Helper methods to update specific sections
  Future<void> updateAboutMe(String userId, Map<String, dynamic> aboutMe) async {
    await _firestore.collection('users').doc(userId).update({
      'profile.aboutMe': aboutMe,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateExperience(String userId, Map<String, dynamic> experience) async {
    await _firestore.collection('users').doc(userId).update({
      'profile.workExperience': FieldValue.arrayUnion([experience]),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateEducation(String userId, Map<String, dynamic> education) async {
    await _firestore.collection('users').doc(userId).update({
      'profile.education': FieldValue.arrayUnion([education]),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateSkills(String userId, List<Map<String, dynamic>> skills) async {
    await _firestore.collection('users').doc(userId).update({
      'profile.skills': skills,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateLanguages(String userId, List<Map<String, dynamic>> languages) async {
    await _firestore.collection('users').doc(userId).update({
      'profile.languages': languages,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateCertificates(String userId, Map<String, dynamic> certificate) async {
    await _firestore.collection('users').doc(userId).update({
      'profile.certificates': FieldValue.arrayUnion([certificate]),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Method to get user profile data
  Stream<DocumentSnapshot> getUserProfile(String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }
} 
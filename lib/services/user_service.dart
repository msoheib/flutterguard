import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createNewUser(User user, String role) async {
    try {
      // Check if user already exists
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        print('User profile already exists');
        return;
      }

      // Create base user data
      Map<String, dynamic> userData = {
        'phoneNumber': user.phoneNumber,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // Add role-specific data
      if (role == 'jobseeker') {
        userData['applicationCount'] = 0;
        userData['profile'] = {
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
        };
      } else if (role == 'company') {
        userData['profile'] = {
          'companyInfo': {
            'name': '',
            'email': '',
            'logo': '',
            'website': '',
            'description': '',
            'industry': '',
            'size': '',
            'foundedYear': null,
            'location': '',
            'address': '',
          },
          'contactInfo': {
            'phone': user.phoneNumber,
            'email': '',
            'alternativePhone': '',
          },
          'socialMedia': {
            'linkedin': '',
            'twitter': '',
            'facebook': '',
            'instagram': '',
          },
          'verification': {
            'isVerified': false,
            'documents': [],
            'verificationDate': null,
          },
          'settings': {
            'notificationPreferences': {
              'email': true,
              'sms': true,
              'push': true,
            },
            'privacySettings': {
              'showContactInfo': false,
              'showSocialMedia': false,
            }
          }
        };
        userData['postedJobs'] = [];
        userData['activeJobCount'] = 0;
        userData['totalJobsPosted'] = 0;
        userData['isProfileComplete'] = false;
      }

      // Create the user document
      await _firestore.collection('users').doc(user.uid).set(
        userData,
        SetOptions(merge: true)
      );
      
      print('User profile created successfully for ${user.uid} as $role');
    } catch (e) {
      print('Error creating user profile: $e');
      throw Exception('Failed to create user profile');
    }
  }

  // Get user profile data
  Stream<DocumentSnapshot> getUserProfile(String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }

  // Update profile sections
  Future<void> updateProfile(String userId, String section, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update({
      'profile.$section': data,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Add work experience
  Future<void> addWorkExperience(String userId, Map<String, dynamic> experience) async {
    await _firestore.collection('users').doc(userId).update({
      'profile.workExperience': FieldValue.arrayUnion([experience]),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Add education
  Future<void> addEducation(String userId, Map<String, dynamic> education) async {
    await _firestore.collection('users').doc(userId).update({
      'profile.education': FieldValue.arrayUnion([education]),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Update skills
  Future<void> updateSkills(String userId, List<Map<String, dynamic>> skills) async {
    await _firestore.collection('users').doc(userId).update({
      'profile.skills': skills,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Update languages
  Future<void> updateLanguages(String userId, List<Map<String, dynamic>> languages) async {
    await _firestore.collection('users').doc(userId).update({
      'profile.languages': languages,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Add certificate
  Future<void> addCertificate(String userId, Map<String, dynamic> certificate) async {
    await _firestore.collection('users').doc(userId).update({
      'profile.certificates': FieldValue.arrayUnion([certificate]),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Update company info
  Future<void> updateCompanyInfo(String userId, Map<String, dynamic> companyInfo) async {
    await _firestore.collection('users').doc(userId).update({
      'profile.companyInfo': companyInfo,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  // Update company verification status
  Future<void> updateCompanyVerification(String userId, bool isVerified) async {
    await _firestore.collection('users').doc(userId).update({
      'profile.verification.isVerified': isVerified,
      'profile.verification.verificationDate': FieldValue.serverTimestamp(),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }
} 
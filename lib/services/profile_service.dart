import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/profile.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Profile> getProfile() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final doc = await _firestore.collection('profiles').doc(userId).get();
      
      if (!doc.exists) {
        // Return default profile if none exists
        return Profile(
          name: 'مستخدم جديد',
          title: 'حارس أمن',
          about: '',
          photoUrl: null,
        );
      }

      return Profile.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting profile: $e');
      // Return default profile on error
      return Profile(
        name: 'مستخدم جديد',
        title: 'حارس أمن',
        about: '',
        photoUrl: null,
      );
    }
  }

  Future<void> updateAbout(String about) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _firestore.collection('profiles').doc(userId).set({
        'about': about,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating about: $e');
      rethrow;
    }
  }
} 
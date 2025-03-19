import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// TODO: Add firebase_storage dependency to pubspec.yaml
// import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/profile.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // TODO: Uncomment once firebase_storage dependency is added
  // final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  
  // Get current user profile
  Stream<Profile?> getCurrentProfile() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value(null);
    
    return _usersCollection.doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return Profile.fromFirestore(snapshot);
    });
  }
  
  // Get profile by ID
  Future<Profile?> getProfileById(String userId) async {
    final doc = await _usersCollection.doc(userId).get();
    if (!doc.exists) return null;
    return Profile.fromFirestore(doc);
  }
  
  // Update personal info
  Future<void> updatePersonalInfo(PersonalInfo personalInfo) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    
    await _usersCollection.doc(userId).update({
      'personalInfo': {
        'name': personalInfo.name,
        'profession': personalInfo.profession,
        'about': personalInfo.about,
        'location': personalInfo.location,
        'phone': personalInfo.phone,
      }
    });
  }
  
  // Add or update work experience
  Future<void> saveWorkExperience(WorkExperience experience) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    
    final userRef = _usersCollection.doc(userId);
    final userDoc = await userRef.get();
    
    if (!userDoc.exists) {
      // Create new profile with this work experience
      final newProfile = Profile(
        id: userId,
        personalInfo: PersonalInfo(
          name: _auth.currentUser?.displayName ?? '',
          profession: '',
          about: '',
        ),
        workExperiences: [experience],
      );
      
      await userRef.set(newProfile.toFirestore());
      return;
    }
    
    // Update existing profile
    final profile = Profile.fromFirestore(userDoc);
    final existingExperiences = List<WorkExperience>.from(profile.getWorkExperiences);
    
    // Check if we're updating an existing experience or adding a new one
    final experienceIndex = existingExperiences.indexWhere(
      (e) => e.id == experience.id
    );
    
    if (experienceIndex >= 0) {
      // Update existing
      existingExperiences[experienceIndex] = experience;
    } else {
      // Add new
      existingExperiences.add(experience);
    }
    
    await userRef.update({
      'workExperiences': existingExperiences.map((e) => e.toMap()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Delete work experience
  Future<void> deleteWorkExperience(String experienceId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    
    final userRef = _usersCollection.doc(userId);
    final userDoc = await userRef.get();
    
    if (!userDoc.exists) return;
    
    final profile = Profile.fromFirestore(userDoc);
    final existingExperiences = List<WorkExperience>.from(profile.getWorkExperiences);
    
    // Remove the experience with matching ID
    existingExperiences.removeWhere((e) => e.id == experienceId);
    
    await userRef.update({
      'workExperiences': existingExperiences.map((e) => e.toMap()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Add or update education
  Future<void> saveEducation(Education education) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    
    final userRef = _usersCollection.doc(userId);
    final userDoc = await userRef.get();
    
    if (!userDoc.exists) {
      // Create new profile with this education
      final newProfile = Profile(
        id: userId,
        personalInfo: PersonalInfo(
          name: _auth.currentUser?.displayName ?? '',
          profession: '',
          about: '',
        ),
        education: [education],
      );
      
      await userRef.set(newProfile.toFirestore());
      return;
    }
    
    // Update existing profile
    final profile = Profile.fromFirestore(userDoc);
    final existingEducation = List<Education>.from(profile.getEducation);
    
    // Check if we're updating an existing education or adding a new one
    final educationIndex = existingEducation.indexWhere(
      (e) => e.id == education.id
    );
    
    if (educationIndex >= 0) {
      // Update existing
      existingEducation[educationIndex] = education;
    } else {
      // Add new
      existingEducation.add(education);
    }
    
    await userRef.update({
      'education': existingEducation.map((e) => e.toMap()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Delete education
  Future<void> deleteEducation(String educationId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    
    final userRef = _usersCollection.doc(userId);
    final userDoc = await userRef.get();
    
    if (!userDoc.exists) return;
    
    final profile = Profile.fromFirestore(userDoc);
    final existingEducation = List<Education>.from(profile.getEducation);
    
    // Remove the education with matching ID
    existingEducation.removeWhere((e) => e.id == educationId);
    
    await userRef.update({
      'education': existingEducation.map((e) => e.toMap()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Update skills
  Future<void> updateSkills(List<String> skills) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    
    await _usersCollection.doc(userId).update({
      'skills': skills,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Update languages
  Future<void> updateLanguages(List<Language> languages) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    
    await _usersCollection.doc(userId).update({
      'languages': languages.map((lang) => lang.toMap()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Update certificates
  Future<void> updateCertificates(List<Certificate> certificates) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    
    await _usersCollection.doc(userId).update({
      'certificates': certificates.map((cert) => cert.toMap()).toList(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  // TODO: Uncomment these methods once firebase_storage dependency is added
  /*
  // Upload profile photo
  Future<String> uploadProfilePhoto(File photoFile) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    
    final storageRef = _storage.ref().child('profile_photos/$userId.jpg');
    final uploadTask = storageRef.putFile(photoFile);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    
    // Update user profile with photo URL
    await _usersCollection.doc(userId).update({
      'photoUrl': downloadUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    return downloadUrl;
  }
  
  // Upload resume PDF
  Future<String> uploadResume(File resumeFile) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    
    final storageRef = _storage.ref().child('resumes/$userId.pdf');
    final uploadTask = storageRef.putFile(resumeFile);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    
    // Update user profile with resume URL
    await _usersCollection.doc(userId).update({
      'resumeUrl': downloadUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    return downloadUrl;
  }
  */
  
  // Temporary methods until Firebase Storage is set up
  Future<void> updateProfilePhoto(String photoUrl) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    
    await _usersCollection.doc(userId).update({
      'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  Future<void> updateResumeUrl(String resumeUrl) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');
    
    await _usersCollection.doc(userId).update({
      'resumeUrl': resumeUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
} 
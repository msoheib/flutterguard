import 'package:cloud_firestore/cloud_firestore.dart';

class JobProfile {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String experience;
  final List<String> skills;
  final String education;
  final String certifications;
  final String availability;

  JobProfile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.experience,
    required this.skills,
    required this.education,
    required this.certifications,
    required this.availability,
  });

  factory JobProfile.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return JobProfile(
      id: doc.id,
      userId: data['userId'] ?? '',
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      experience: data['experience'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      education: data['education'] ?? '',
      certifications: data['certifications'] ?? '',
      availability: data['availability'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'experience': experience,
      'skills': skills,
      'education': education,
      'certifications': certifications,
      'availability': availability,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class JobPost {
  final String id;
  final String employerId;
  final String title;
  final String description;
  final String location;
  final String salary;
  final List<String> requiredSkills;
  final String experienceLevel;
  final DateTime postedDate;
  final String status;

  JobPost({
    required this.id,
    required this.employerId,
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
    required this.requiredSkills,
    required this.experienceLevel,
    required this.postedDate,
    required this.status,
  });

  factory JobPost.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return JobPost(
      id: doc.id,
      employerId: data['employerId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      salary: data['salary'] ?? '',
      requiredSkills: List<String>.from(data['requiredSkills'] ?? []),
      experienceLevel: data['experienceLevel'] ?? '',
      postedDate: (data['postedDate'] as Timestamp).toDate(),
      status: data['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employerId': employerId,
      'title': title,
      'description': description,
      'location': location,
      'salary': salary,
      'requiredSkills': requiredSkills,
      'experienceLevel': experienceLevel,
      'postedDate': Timestamp.fromDate(postedDate),
      'status': status,
    };
  }
}

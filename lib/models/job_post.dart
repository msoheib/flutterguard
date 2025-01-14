import 'package:cloud_firestore/cloud_firestore.dart';

class JobPost {
  final String id;
  final String title;
  final String company;
  final String? companyLogo;
  final Map<String, dynamic> salary;
  final String description;
  final Map<String, dynamic> location;
  final DateTime createdAt;
  final String companyId;
  final List<String> requirements;
  final List<String> skills;
  final int applicantsCount;
  final String type;
  final String employmentType;

  JobPost({
    required this.id,
    required this.title,
    required this.company,
    this.companyLogo,
    required this.salary,
    required this.description,
    required this.location,
    required this.createdAt,
    required this.companyId,
    required this.requirements,
    required this.skills,
    this.applicantsCount = 0,
    required this.type,
    this.employmentType = 'دوام كامل',
  });

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'company': company,
      'companyLogo': companyLogo,
      'salary': salary,
      'description': description,
      'location': location,
      'createdAt': createdAt,
      'companyId': companyId,
      'requirements': requirements,
      'skills': skills,
      'applicantsCount': applicantsCount,
      'type': type,
      'employmentType': employmentType,
    };
  }

  Map<String, dynamic> toMap() => toFirestore();

  factory JobPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JobPost(
      id: doc.id,
      title: data['title'] ?? '',
      company: data['company'] ?? '',
      companyLogo: data['companyLogo'],
      salary: Map<String, dynamic>.from(data['salary'] ?? {}),
      description: data['description'] ?? '',
      location: Map<String, dynamic>.from(data['location'] ?? {'city': ''}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      companyId: data['companyId'] ?? '',
      requirements: List<String>.from(data['requirements'] ?? []),
      skills: List<String>.from(data['skills'] ?? []),
      applicantsCount: data['applicantsCount'] ?? 0,
      type: data['type'] ?? 'دوام كامل',
      employmentType: data['employmentType'] ?? 'دوام كامل',
    );
  }

  String get companyName => company;

  String get workType => employmentType;
}

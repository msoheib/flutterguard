import 'package:cloud_firestore/cloud_firestore.dart';

class JobPost {
  final String id;
  final String title;
  final String companyId;
  final String companyName;
  final String location;
  final Map<String, dynamic> salary;
  final String type;
  final String description;
  final List<String> requiredSkills;
  final DateTime createdAt;
  final List<String> skills;

  JobPost({
    required this.id,
    required this.title,
    required this.companyId,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.type,
    required this.description,
    required this.requiredSkills,
    required this.createdAt,
    List<String>? skills,
  }) : skills = skills ?? [];

  String get typeAsString {
    switch (type) {
      case 'full-time':
        return 'دوام كامل';
      case 'part-time':
        return 'دوام جزئي';
      case 'contract':
        return 'عقد';
      default:
        return type;
    }
  }

  factory JobPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JobPost(
      id: doc.id,
      title: data['title'] ?? '',
      companyId: data['companyId'] ?? '',
      companyName: data['companyName'] ?? '',
      location: data['location'] ?? '',
      salary: data['salary'] ?? {'amount': '0', 'currency': 'SAR'},
      type: data['type'] ?? 'full-time',
      description: data['description'] ?? '',
      requiredSkills: List<String>.from(data['requiredSkills'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      skills: List<String>.from(data['skills'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'companyId': companyId,
      'companyName': companyName,
      'location': location,
      'salary': salary,
      'type': type,
      'description': description,
      'requiredSkills': requiredSkills,
      'createdAt': Timestamp.fromDate(createdAt),
      'skills': skills,
    };
  }

  Map<String, dynamic> toFirestore() => toMap();
}

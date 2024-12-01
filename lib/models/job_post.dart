import 'package:cloud_firestore/cloud_firestore.dart';

class JobPost {
  final String id;
  final String title;
  final String company;
  final String companyLogo;
  final String location;
  final Map<String, dynamic> salary;
  final String type;
  final String description;
  final List<String> requirements;
  final List<String> qualifications;
  final List<String> skills;
  final String status;
  final String hirerId;
  final int applicationsCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> filters;

  JobPost({
    required this.id,
    required this.title,
    required this.company,
    this.companyLogo = '',
    required this.location,
    required this.salary,
    required this.type,
    required this.description,
    required this.requirements,
    required this.qualifications,
    required this.skills,
    required this.status,
    required this.hirerId,
    required this.applicationsCount,
    required this.createdAt,
    required this.updatedAt,
    required this.filters,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'companyLogo': companyLogo,
      'location': location,
      'salary': salary,
      'type': type,
      'description': description,
      'requirements': requirements,
      'qualifications': qualifications,
      'skills': skills,
      'status': status,
      'hirerId': hirerId,
      'applicationsCount': applicationsCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'filters': filters,
    };
  }

  static JobPost fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JobPost(
      id: doc.id,
      title: data['title'] ?? '',
      company: data['company'] ?? '',
      companyLogo: data['companyLogo'] ?? '',
      location: data['location'] ?? '',
      salary: data['salary'] ?? {},
      type: data['type'] ?? '',
      description: data['description'] ?? '',
      requirements: List<String>.from(data['requirements'] ?? []),
      qualifications: List<String>.from(data['qualifications'] ?? []),
      skills: List<String>.from(data['skills'] ?? []),
      status: data['status'] ?? 'active',
      hirerId: data['hirerId'] ?? '',
      applicationsCount: data['applicationsCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      filters: data['filters'] ?? {},
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String description;
  final String? logo;
  final String? website;
  final String location;
  final DateTime createdAt;
  final bool isVerified;
  final bool isActive;
  final int totalJobs;
  final String industry;
  final String size;

  Company({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.description,
    this.logo,
    this.website,
    required this.location,
    required this.createdAt,
    required this.isVerified,
    required this.isActive,
    required this.totalJobs,
    required this.industry,
    required this.size,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'description': description,
      'logo': logo,
      'website': website,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
      'isVerified': isVerified,
      'isActive': isActive,
      'totalJobs': totalJobs,
      'industry': industry,
      'size': size,
    };
  }

  static Company fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Company(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      description: data['description'] ?? '',
      logo: data['logo'],
      website: data['website'],
      location: data['location'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isVerified: data['isVerified'] ?? false,
      isActive: data['isActive'] ?? true,
      totalJobs: data['totalJobs'] ?? 0,
      industry: data['industry'] ?? '',
      size: data['size'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => toMap();
} 
import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String logo;
  final String description;
  final String location;
  final String website;
  final String size;
  final String industry;
  final bool isVerified;
  final List<String> postedJobs;
  final DateTime createdAt;
  final DateTime updatedAt;

  Company({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.logo,
    required this.description,
    required this.location,
    required this.website,
    required this.size,
    required this.industry,
    this.isVerified = false,
    required this.postedJobs,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Company.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Company(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      logo: data['logo'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      website: data['website'] ?? '',
      size: data['size'] ?? '',
      industry: data['industry'] ?? '',
      isVerified: data['isVerified'] ?? false,
      postedJobs: List<String>.from(data['postedJobs'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'logo': logo,
      'description': description,
      'location': location,
      'website': website,
      'size': size,
      'industry': industry,
      'isVerified': isVerified,
      'postedJobs': postedJobs,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
} 
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { user, company, admin, super_admin }

class User {
  final String uid;
  final String email;
  final String phoneNumber;
  final UserRole role;
  final DateTime joinDate;
  final String name;
  final String? profileImage;
  final bool isActive;
  final List<String> deviceTokens;
  final DateTime lastLogin;

  User({
    required this.uid,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.joinDate,
    required this.name,
    this.profileImage,
    required this.isActive,
    required this.deviceTokens,
    required this.lastLogin,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role.toString().split('.').last,
      'joinDate': Timestamp.fromDate(joinDate),
      'name': name,
      'profileImage': profileImage,
      'isActive': isActive,
      'deviceTokens': deviceTokens,
      'lastLogin': Timestamp.fromDate(lastLogin),
    };
  }

  static User fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final now = DateTime.now();
    
    return User(
      uid: doc.id,
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == (data['role'] ?? 'user'),
        orElse: () => UserRole.user,
      ),
      joinDate: data['joinDate'] != null 
          ? (data['joinDate'] as Timestamp).toDate()
          : now,
      name: data['name'] ?? '',
      profileImage: data['profileImage'],
      isActive: data['isActive'] ?? false,
      deviceTokens: List<String>.from(data['deviceTokens'] ?? []),
      lastLogin: data['lastLogin'] != null 
          ? (data['lastLogin'] as Timestamp).toDate()
          : now,
    );
  }
} 
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUser {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final bool isSuperAdmin;
  final List<String> permissions;
  final DateTime createdAt;
  final DateTime? lastLogin;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isSuperAdmin = false,
    required this.permissions,
    required this.createdAt,
    this.lastLogin,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isSuperAdmin': isSuperAdmin,
      'permissions': permissions,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
    };
  }

  static AdminUser fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AdminUser(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      isSuperAdmin: data['isSuperAdmin'] ?? false,
      permissions: List<String>.from(data['permissions'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLogin: data['lastLogin'] != null ? (data['lastLogin'] as Timestamp).toDate() : null,
    );
  }

  // Define admin permissions
  static const String PERMISSION_MANAGE_USERS = 'manage_users';
  static const String PERMISSION_MANAGE_COMPANIES = 'manage_companies';
  static const String PERMISSION_MANAGE_JOBS = 'manage_jobs';
  static const String PERMISSION_MANAGE_SUPPORT = 'manage_support';
  static const String PERMISSION_BAN_USERS = 'ban_users';
  static const String PERMISSION_DELETE_ACCOUNTS = 'delete_accounts';
  static const String PERMISSION_EDIT_PROFILES = 'edit_profiles';
  static const String PERMISSION_MANAGE_BLACKLIST = 'manage_blacklist';
  static const String PERMISSION_VIEW_ANALYTICS = 'view_analytics';
  static const String PERMISSION_MANAGE_ADMINS = 'manage_admins';
} 
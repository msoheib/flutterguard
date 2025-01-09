import '../models/user.dart';

class RoleService {
  static bool isCompany(UserRole role) {
    print('Checking role: $role');
    return role == UserRole.company;
  }
  static bool isUser(UserRole role) => role == UserRole.user;
  static bool isAdmin(UserRole role) => role == UserRole.admin;
  static bool isSuperAdmin(UserRole role) => role == UserRole.super_admin;

  static bool canViewApplicants(UserRole role) {
    return role == UserRole.company || role == UserRole.admin || role == UserRole.super_admin;
  }

  static bool canManageJobs(UserRole role) {
    return role == UserRole.company || role == UserRole.admin || role == UserRole.super_admin;
  }

  static bool canApplyToJobs(UserRole role) {
    return role == UserRole.user;
  }

  static bool canManageUsers(UserRole role) {
    return role == UserRole.admin || role == UserRole.super_admin;
  }

  static bool canManageCompanies(UserRole role) {
    return role == UserRole.admin || role == UserRole.super_admin;
  }

  static bool canAccessAdminPanel(UserRole role) {
    return role == UserRole.admin || role == UserRole.super_admin;
  }

  static bool canManageAdmins(UserRole role) {
    return role == UserRole.super_admin;
  }

  // Home page specific permissions
  static bool canViewJobStats(UserRole role) {
    return role == UserRole.company || role == UserRole.admin || role == UserRole.super_admin;
  }

  static bool canViewApplicantStats(UserRole role) {
    return role == UserRole.company || role == UserRole.admin || role == UserRole.super_admin;
  }

  static bool canViewRecentApplicants(UserRole role) {
    return role == UserRole.company || role == UserRole.admin || role == UserRole.super_admin;
  }
} 
import 'package:flutter/material.dart';
import 'pages/admin/admin_dashboard_page.dart';
import 'pages/admin/admin_settings_page.dart';
import 'pages/admin/admin_support_page.dart';
import 'pages/admin/admin_companies_page.dart';
import 'pages/admin/admin_users_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/company/company_home_page.dart';
import 'pages/company/company_settings_page.dart';
import 'pages/company/company_pending_approval_page.dart';
import 'pages/company/company_applications_page.dart';
import 'pages/chat_list_page.dart';
import 'screens/create_job_page.dart';
import 'widgets/company_route_wrapper.dart';
import 'widgets/auth_wrapper.dart';
import 'pages/company/job_applicants_page.dart';
import 'pages/admin/dashboard_page.dart';
import 'pages/admin/profile_page.dart';
import 'pages/admin/chat_page.dart';
import 'pages/admin/applications_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // Auth Routes
    case '/':
      return MaterialPageRoute(builder: (_) => const AuthWrapper());
    case '/login':
      return MaterialPageRoute(builder: (_) => const LoginPage());
    case '/signup':
      return MaterialPageRoute(builder: (_) => const SignupPage());
      
    // Company Routes
    case '/company/home':
      return MaterialPageRoute(
        builder: (_) => CompanyRouteWrapper(
          currentIndex: 0,
          child: const CompanyHomePage(),
        ),
      );
    case '/company/chat':
      return MaterialPageRoute(
        builder: (_) => CompanyRouteWrapper(
          currentIndex: 1,
          child: const ChatListPage(),
        ),
      );
    case '/company/applications':
      return MaterialPageRoute(
        builder: (_) => CompanyRouteWrapper(
          currentIndex: 2,
          child: const CompanyApplicationsPage(),
        ),
      );
    case '/company/settings':
      return MaterialPageRoute(
        builder: (_) => CompanyRouteWrapper(
          currentIndex: 3,
          child: const CompanySettingsPage(),
        ),
      );
    case '/company/create-job':
      return MaterialPageRoute(
        builder: (_) => const CreateJobPage(),
      );
    case '/company/pending':
      return MaterialPageRoute(
        builder: (_) => const CompanyPendingApprovalPage(),
      );
      
    // Admin Routes
    case '/admin/dashboard':
      return MaterialPageRoute(builder: (_) => const AdminDashboardPage());
    case '/admin/profile':
      return MaterialPageRoute(builder: (_) => const AdminProfilePage());
    case '/admin/chat':
      return MaterialPageRoute(builder: (_) => const AdminChatPage());
    case '/admin/applications':
      return MaterialPageRoute(builder: (_) => const AdminApplicationsPage());
    case '/admin/settings':
      return MaterialPageRoute(
        builder: (_) => const AdminSettingsPage(),
      );
    case '/admin/support':
      return MaterialPageRoute(
        builder: (_) => const AdminSupportPage(),
      );
    case '/admin/companies':
      return MaterialPageRoute(
        builder: (_) => const AdminCompaniesPage(),
      );
    case '/admin/users':
      return MaterialPageRoute(
        builder: (_) => const AdminUsersPage(),
      );
      
    // Dynamic company routes
    default:
      if (settings.name?.startsWith('/company/applicants/') ?? false) {
        final jobId = settings.name?.split('/').last;
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => JobApplicantsPage(
            jobId: jobId ?? '',
            jobTitle: args?['jobTitle'] ?? '',
          ),
        );
      }
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        ),
      );
  }
} 
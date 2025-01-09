import 'package:flutter/material.dart';
import '../pages/chat_page.dart';
import '../pages/company/company_applicants_page.dart';
import '../pages/company/company_settings_page.dart';
import '../widgets/company_route_wrapper.dart';
import '../pages/company/company_home_page.dart';
import '../screens/create_job_page.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Company Navigation Routes
  static const String companyHome = '/company/home';
  static const String companyChat = '/company/chat';
  static const String companyApplications = '/company/applications';
  static const String companySettings = '/company/settings';
  static const String createJob = '/company/create-job';

  // Get the route map for MaterialApp
  static final Map<String, Widget Function(BuildContext)> companyRoutes = {
    companyHome: (context) => const CompanyHomePage(),
    companyChat: (context) => CompanyRouteWrapper(
          currentIndex: 2,
          child: const ChatPage(),
        ),
    companyApplications: (context) => CompanyRouteWrapper(
          currentIndex: 1,
          child: const CompanyApplicantsPage(),
        ),
    companySettings: (context) => CompanyRouteWrapper(
          currentIndex: 0,
          child: const CompanySettingsPage(),
        ),
    createJob: (context) => const CreateJobPage(),
  };

  // Initialize deep linking
  static Future<void> initDeepLinks() async {
    // Implementation for deep linking initialization
    // This can be expanded later when deep linking is needed
  }

  static void handleCompanyNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        navigateTo(companyHome);
        break;
      case 1:
        navigateTo(companyChat);
        break;
      case 2:
        navigateTo(companyApplications);
        break;
      case 3:
        navigateTo(companySettings);
        break;
    }
  }

  // Navigate without context
  static void navigateTo(String route, {Object? arguments}) {
    navigatorKey.currentState?.pushReplacementNamed(route, arguments: arguments);
  }

  // Navigate back without context
  static void goBack() {
    navigatorKey.currentState?.pop();
  }
} 
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/profile_cv_screen.dart';
import 'pages/settings_page.dart';
import 'services/service_locator.dart';
import 'services/notification_service.dart';
import 'services/navigation_service.dart';
import 'widgets/auth_wrapper.dart';
import 'pages/job_seeker_home_page.dart';
import 'pages/applications_history_page.dart';
import 'pages/chat_page.dart';
import 'pages/company/company_home_page.dart';
import 'pages/company/company_applications_page.dart';
import 'pages/company/company_chat_page.dart';
import 'pages/company/create_job_page.dart';
import 'pages/company/company_settings_page.dart';
import 'pages/superadmin_page.dart';
import 'theme/app_theme.dart';
import 'screens/application_success_page.dart';
import 'screens/applicant_review_page.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Firebase initialization
    await Firebase.initializeApp();
    
    // Setup service locator
    setupServices();
    
    // Initialize navigation service first
    await NavigationService.initDeepLinks().catchError((e) {
      print('Deep links initialization error (non-fatal): $e');
    });

    // Initialize notifications service
    try {
      await NotificationService().init();
    } catch (e) {
      print('Notification initialization error (non-fatal): $e');
    }
    
    runApp(const MyApp());
  } catch (e) {
    print('Critical initialization error: $e');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'عذراً، حدث خطأ أثناء تشغيل التطبيق',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    main();
                  },
                  child: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'Security Guard App',
      theme: ThemeData(
        // Colors
        primaryColor: AppTheme.primary,
        colorScheme: ColorScheme.light(
          primary: AppTheme.primary,
          secondary: AppTheme.secondary,
          error: AppTheme.error,
          surface: AppTheme.surface,
        ),
        
        // Text Theme
        textTheme: TextTheme(
          displayLarge: AppTheme.headingLarge,
          displayMedium: AppTheme.headingMedium,
          displaySmall: AppTheme.headingSmall,
          bodyLarge: AppTheme.bodyLarge,
          bodyMedium: AppTheme.bodyMedium,
          bodySmall: AppTheme.bodySmall,
          labelLarge: AppTheme.labelLarge,
          labelMedium: AppTheme.labelMedium,
          labelSmall: AppTheme.labelSmall,
        ),
        
        // Font Family
        fontFamily: 'Cairo',
        
        // Input Decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppTheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            borderSide: const BorderSide(color: AppTheme.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            borderSide: const BorderSide(color: AppTheme.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            borderSide: const BorderSide(color: AppTheme.primary),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            borderSide: const BorderSide(color: AppTheme.error),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
        ),
        
        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: AppTheme.primaryButton,
        ),
        
        // Card Theme
        cardTheme: CardTheme(
          color: AppTheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            side: const BorderSide(color: AppTheme.borderColor),
          ),
        ),
        
        // App Bar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: AppTheme.surface,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTheme.headingSmall,
          iconTheme: const IconThemeData(color: AppTheme.textPrimary),
        ),
        
        // Bottom Navigation Bar Theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppTheme.surface,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: AppTheme.labelMedium,
          unselectedLabelStyle: AppTheme.labelMedium,
        ),
        
        // Divider Theme
        dividerTheme: const DividerThemeData(
          color: AppTheme.dividerColor,
          thickness: 1,
          space: AppTheme.spacingMd,
        ),
        
        // Scaffold Background Color
        scaffoldBackgroundColor: AppTheme.background,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/jobseeker/home': (context) => const JobSeekerHomePage(),
        '/jobseeker/applications': (context) => const ApplicationsHistoryPage(),
        '/jobseeker/chat': (context) => const ChatPage(),
        '/jobseeker/profile': (context) => const ProfileCvScreen(),
        '/jobseeker/settings': (context) => const SettingsPage(),
        '/company/home': (context) => const CompanyHomePage(),
        '/company/applications': (context) => const CompanyApplicationsPage(),
        '/company/chat': (context) => const CompanyChatPage(),
        '/company/settings': (context) => const CompanySettingsPage(),
        '/company/create-job': (context) => const CreateJobPage(),
        '/superadmin': (context) => const SuperAdminPage(),
        '/application-success': (context) => const ApplicationSuccessPage(),
        '/applicant-review': (context) => const ApplicantReviewPage(),
      },
    );
  }
}

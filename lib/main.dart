import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'pages/job_seeker_home_page.dart';
import 'pages/applications_history_page.dart';
import 'pages/chat_list_page.dart';
import 'pages/profile/user_profile_page.dart';
import 'pages/cv_profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/company/company_home_page.dart';
import 'pages/company/company_applications_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/company/company_chat_page.dart';
import 'pages/company/create_job_page.dart';
import 'pages/company/company_settings_page.dart';
import 'pages/superadmin_page.dart';
import 'theme/app_theme.dart';
import 'screens/application_success_page.dart';
import 'screens/applicant_review_page.dart';
import 'services/service_locator.dart';
import 'services/notification_service.dart';
import 'services/navigation_service.dart';
import 'services/skills_service.dart';
import 'widgets/auth_wrapper.dart';
import 'pages/admin/admin_dashboard_page.dart';
import 'pages/admin/support_chat_page.dart';
import 'pages/admin/admin_applications_page.dart';
import 'pages/admin/admin_chat_page.dart';
import 'pages/admin/admin_profile_page.dart';
import 'pages/admin/admin_users_page.dart';
import 'pages/admin/admin_settings_page.dart';
import 'pages/example_back_button_page.dart';
import 'pages/notifications_page.dart';
import 'pages/cv/work_experience_edit_page.dart';
import 'pages/cv/skills_edit_page.dart';
import 'pages/cv/languages_edit_page.dart';
import 'pages/cv/personal_info_edit_page.dart';
import 'models/profile.dart';
import 'dart:async';
import 'screens/chat_detail_page.dart';
import 'models/chat.dart';
import 'services/chat_service.dart';
import 'services/support_service.dart';
import 'pages/admin/admin_support_page.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    try {
      // Firebase initialization
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
      // Setup service locator
      setupServices();
      
      // Initialize skills
      final skillsService = SkillsService();
      await skillsService.initializeSkills().catchError((e) {
        debugPrint('Skills initialization error (non-fatal): $e');
      });
      
      // Initialize navigation service first
      await NavigationService.initDeepLinks().catchError((e) {
        debugPrint('Deep links initialization error (non-fatal): $e');
      });

      // Initialize notifications service
      try {
        await NotificationService().init();
      } catch (e) {
        debugPrint('Notification initialization error (non-fatal): $e');
      }
      
      runApp(const MyApp());
    } catch (e, stackTrace) {
      debugPrint('Critical initialization error: $e\n$stackTrace');
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }
  }, (error, stack) {
    debugPrint('Uncaught error: $error\n$stack');
  });
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
        '/jobseeker/chat': (context) => const ChatListPage(),
        '/jobseeker/profile': (context) => const UserProfilePage(),
        '/jobseeker/cv': (context) => const CVProfilePage(),
        '/jobseeker/settings': (context) => const SettingsPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/company/home': (context) => const CompanyHomePage(),
        '/company/applications': (context) => const CompanyApplicationsPage(),
        '/company/chat': (context) => const CompanyChatPage(),
        '/company/settings': (context) => const CompanySettingsPage(),
        '/company/create-job': (context) => const CreateJobPage(),
        '/superadmin': (context) => const SuperAdminPage(),
        '/application-success': (context) => const ApplicationSuccessPage(),
        '/applicant-review': (context) => const ApplicantReviewPage(),
        '/admin/dashboard': (context) => const AdminDashboardPage(),
        '/admin/applications': (context) => const AdminApplicationsPage(),
        '/admin/chat': (context) => const AdminChatPage(),
        '/admin/profile': (context) => const AdminProfilePage(),
        '/admin/support-chat': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return SupportChatPage(
            chatId: args['chatId'] as String,
            userId: args['userId'] as String,
          );
        },
        '/admin/users': (context) => const AdminUsersPage(),
        '/admin/settings': (context) => const AdminSettingsPage(),
        '/admin/support': (context) => const AdminSupportPage(),
        '/example-back-button': (context) => const ExampleBackButtonPage(),
        '/jobseeker/cv/work-experience': (context) => const WorkExperienceEditPage(),
        '/jobseeker/cv/skills': (context) => const SkillsEditPage(initialSkills: []),
        '/jobseeker/cv/languages': (context) => const LanguagesEditPage(initialLanguages: []),
        '/jobseeker/cv/personal-info': (context) {
          // This route is meant to be used with arguments from Navigator.push
          // Default values shown here are just placeholders
          return PersonalInfoEditPage(
            initialInfo: PersonalInfo(
              name: '',
              profession: '',
              about: '',
              location: '',
              phone: '',
            ),
          );
        },
        
        // Support chat route for both users and admins
        '/support-chat': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is Map<String, String> && args.containsKey('chatId')) {
            return SupportChatPage(
              chatId: args['chatId']!,
              userId: args['userId'] ?? FirebaseAuth.instance.currentUser?.uid ?? '',
            );
          }
          return const Scaffold(
            body: Center(child: Text('Chat not found')),
          );
        },
        
        // Support route that starts a live chat directly 
        '/support': (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final supportService = SupportService();
            supportService.startLiveChat().catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error starting chat: $error'),
                  backgroundColor: Colors.red,
                ),
              );
              Navigator.pop(context);
            });
          });
          
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        
        '/chat_detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final chatId = args['chatId'] as String;
          final otherUserId = args['otherUserId'] as String;
          final otherUserName = args['otherUserName'] as String? ?? 'مستخدم';
          
          // Fetch the chat from Firestore or create a new chat object
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('chats').doc(chatId).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text('Error loading chat: ${snapshot.error}'),
                  ),
                );
              }
              
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Scaffold(
                  body: Center(
                    child: Text('Chat not found'),
                  ),
                );
              }
              
              final chatData = snapshot.data!;
              final chat = Chat.fromFirestore(chatData);
              
              // Determine if user is company based on current user ID
              final currentUserId = FirebaseAuth.instance.currentUser?.uid;
              final isCompany = chat.companyId == currentUserId;
              
              return ChatDetailPage(
                chat: chat,
                isCompany: isCompany,
              );
            },
          );
        },
      },
    );
  }
}

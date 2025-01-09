import 'package:get_it/get_it.dart';
import 'job_service.dart';
import 'company_service.dart';
import 'chat_service.dart';
import 'notification_service.dart';
import 'support_service.dart';
import 'admin_service.dart';
import 'auth_service.dart';

final getIt = GetIt.instance;

void setupServices() {
  // Core services
  getIt.registerLazySingleton(() => JobService());
  getIt.registerLazySingleton(() => CompanyService());
  getIt.registerLazySingleton(() => ChatService());
  
  // Support and notifications
  getIt.registerLazySingleton(() => NotificationService());
  getIt.registerLazySingleton(() => SupportService());
  getIt.registerLazySingleton(() => AdminService());
  
  // Add AuthService if not already present
  getIt.registerLazySingleton<AuthService>(() => AuthService());
} 
import 'package:flutter/material.dart';
import 'pages/jobseeker_profile.dart';
import 'pages/job_posting_list.dart';
import 'pages/hiring_company_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'widgets/recyclers/navbar.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Initialize Firebase with timeout
    await initializeFirebase().timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw 'Firebase initialization timeout',
    );
    
    runApp(const SecurityGuardJobApp());
  } catch (e) {
    print('Initialization error: $e');
    // Show an error screen
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error initializing app: $e'),
        ),
      ),
    ));
  }
}

class SecurityGuardJobApp extends StatelessWidget {
  const SecurityGuardJobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Security Guard Job Platform',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          secondary: Colors.amber,
          surface: Colors.grey[50],
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
              color: Colors.grey[800], 
              fontSize: 24, 
              fontWeight: FontWeight.bold),
          titleMedium: TextStyle(
              color: Colors.grey[700], 
              fontSize: 20, 
              fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(
              color: Colors.grey[600], 
              fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: TextTheme(
          titleLarge: const TextStyle(
              color: Colors.white, 
              fontSize: 24, 
              fontWeight: FontWeight.bold),
          titleMedium: TextStyle(
              color: Colors.grey[200], 
              fontSize: 20, 
              fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(
              color: Colors.grey[300], 
              fontSize: 16),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late List<Widget> _pages;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  Future<void> _initializePages() async {
    try {
      setState(() {
        _isLoading = true;
      });

      _pages = [
        JobPostingList(),
        JobseekerProfile(),
        HiringCompanyProfile(),
        Placeholder(), // Add a placeholder for the fourth page
      ];

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing pages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Security Guard Jobs"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

Future<void> initializeFirebase() async {
  try {
    // Check if Firebase is already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        name: 'SecurityGuardApp', // Give a unique name
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app('SecurityGuardApp'); // Use existing instance
    }
  } catch (e) {
    print('Firebase initialization error: $e');
    rethrow;
  }
}

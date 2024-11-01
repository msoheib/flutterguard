import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'widgets/recyclers/navbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/home': (context) => BottomNavigationBarExample(),
      },
      initialRoute: '/home',
    );
  }
}

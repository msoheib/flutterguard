import 'package:flutter/material.dart';
import 'recyclers/navbar.dart';

class AuthenticatedLayout extends StatelessWidget {
  final Widget child;

  const AuthenticatedLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const Navbar(),
    );
  }
} 
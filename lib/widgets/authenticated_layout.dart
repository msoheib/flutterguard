import 'package:flutter/material.dart';
import 'recyclers/navbar.dart';

class AuthenticatedLayout extends StatelessWidget {
  final Widget child;
  final bool showFloatingButton;

  const AuthenticatedLayout({
    super.key,
    required this.child,
    this.showFloatingButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      floatingActionButton: showFloatingButton ? Container(
        height: 65,
        width: 65,
        margin: const EdgeInsets.only(bottom: 0),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF4CA6A8),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const Navbar(),
    );
  }
} 
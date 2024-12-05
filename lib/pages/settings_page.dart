import 'package:flutter/material.dart';
import '../widgets/authenticated_layout.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthenticatedLayout(
      currentIndex: 0,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'الإعدادات',
                    style: TextStyle(
                      color: Color(0xFF1A1D1E),
                      fontSize: 24,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                // Add settings options here
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
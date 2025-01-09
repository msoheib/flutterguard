import 'package:flutter/material.dart';
import '../widgets/common/app_header.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'المتقدمين',
              showBackButton: true,
              onActionTap: () => Navigator.pop(context),
            ),
            // Add your applications list here
          ],
        ),
      ),
    );
  }
} 
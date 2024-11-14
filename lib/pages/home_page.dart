import 'package:flutter/material.dart';
import '../widgets/status_bar.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/application_counter_banner.dart';
import '../pages/profile_cv_screen.dart';
import '../widgets/authenticated_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthenticatedLayout(
      child: Scaffold(
        appBar: StatusBar(
          title: 'أسم التطبيق',
          onNotificationTap: () {
            // Handle notification tap
          },
          onProfileTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileCvScreen(),
              ),
            );
          },
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            SearchBarWidget(
              onFilterTap: () {
                // Handle filter tap
              },
              onSearch: (value) {
                // Handle search
              },
            ),
            const SizedBox(height: 20),
            const ApplicationCounterBanner(),
            // Rest of your content
          ],
        ),
      ),
    );
  }
}

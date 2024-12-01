import 'package:flutter/material.dart';
import '../widgets/status_bar.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/application_counter_banner.dart';
import '../pages/job_listing.dart';
import '../pages/profile_cv_screen.dart';
import '../widgets/authenticated_layout.dart';
import '../screens/filter_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.85,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const FilterBottomSheet(),
        ),
      ),
    );
  }

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              SearchBarWidget(
                onFilterTap: () {
                  print("Filter button tapped"); // Debug print
                  _showFilterBottomSheet(context);
                },
                onSearch: (value) {
                  print('Search query: $value'); // Debug print
                },
              ),
              const SizedBox(height: 20),
              const ApplicationCounterBanner(),
              const SizedBox(height: 20),
              JobListings(),
            ],
          ),
        ),
      ),
    );
  }
}

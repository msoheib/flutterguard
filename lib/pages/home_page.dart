import 'package:flutter/material.dart';
import '../widgets/status_bar.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/application_counter_banner.dart';
import '../pages/job_listing.dart';
import '../pages/profile_cv_screen.dart';
import '../widgets/authenticated_layout.dart';
import '../screens/filter_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<JobListingsState> _jobListingsKey = GlobalKey<JobListingsState>();

  void _showFilterBottomSheet(BuildContext context) async {
    print("Showing filter bottom sheet");
    final result = await showModalBottomSheet<Map<String, dynamic>>(
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

    if (result != null) {
      print("Applying filters: $result");
      // Update filters in JobListings
      _jobListingsKey.currentState?.updateFilters(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticatedLayout(
      currentIndex: 4, // Home page index
      onNavItemTap: (index) {
        // Navigation will be handled by the navbar itself
      },
      child: Column(
        children: [
          StatusBar(
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  SearchBarWidget(
                    onFilterTap: () {
                      print("Filter button tapped in home page");
                      _showFilterBottomSheet(context);
                    },
                    onSearch: (value) {
                      print('Search query: $value');
                    },
                  ),
                  const SizedBox(height: 20),
                  const ApplicationCounterBanner(),
                  const SizedBox(height: 20),
                  JobListings(key: _jobListingsKey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

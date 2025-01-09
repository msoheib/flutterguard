import 'package:flutter/material.dart';
import '../widgets/search_bar_widget.dart';
import '../pages/job_listing.dart';
import 'filter_page.dart';

class JobListingPage extends StatelessWidget {
  const JobListingPage({super.key});

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
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SearchBarWidget(
              onFilterTap: () {
                print("Filter button tapped"); // Debug print
                _showFilterBottomSheet(context);
              },
              onSearch: (query) {
                print('Search query: $query');
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: JobListings(),
            ),
          ],
        ),
      ),
    );
  }
} 
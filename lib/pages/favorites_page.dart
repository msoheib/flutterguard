import 'package:flutter/material.dart';
import '../widgets/authenticated_layout.dart';
import '../widgets/job_listing_card.dart';
import '../models/job_post.dart';
import '../services/job_service.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final JobService jobService = JobService();

    return AuthenticatedLayout(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'الوظائف المفضلة',
                  style: TextStyle(
                    color: Color(0xFF1A1D1E),
                    fontSize: 24,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<JobPost>>(
                  stream: jobService.getFavoriteJobs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final jobs = snapshot.data ?? [];

                    if (jobs.isEmpty) {
                      return const Center(
                        child: Text(
                          'لا توجد وظائف مفضلة',
                          style: TextStyle(
                            color: Color(0xFF6A6A6A),
                            fontSize: 16,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: JobListingCard(job: jobs[index]),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
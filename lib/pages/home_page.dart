import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/job_listing_card.dart';
import '../models/job_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/user_route_wrapper.dart';
import '../services/application_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return UserRouteWrapper(
      currentIndex: 0,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: SafeArea(
          child: _buildJobsPage(),
        ),
      ),
    );
  }

  Widget _buildJobsPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الوظائف المتاحة'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4CA6A8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: StreamBuilder<List<Application>>(
              stream: ApplicationService().getUserApplications(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('حدث خطأ');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final applications = snapshot.data?.length ?? 0;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.work,
                      color: Colors.white,
                    ),
                    Text(
                      'التقديمات: $applications',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('حدث خطأ'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final jobs = snapshot.data!.docs;

                if (jobs.isEmpty) {
                  return const Center(child: Text('لا توجد وظائف متاحة'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: JobListingCard(
                        job: JobPost.fromFirestore(jobs[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

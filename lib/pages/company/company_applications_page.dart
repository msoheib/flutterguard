import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/company_route_wrapper.dart';
import '../../components/navigation/app_bars/custom_app_bar.dart';
import './company_applicants_page.dart';

class CompanyApplicationsPage extends StatelessWidget {
  const CompanyApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return CompanyRouteWrapper(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: Column(
          children: [
            CustomAppBar(
              title: 'المتقدمين',
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('jobs')
                    .where('companyId', isEqualTo: userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final jobs = snapshot.data?.docs ?? [];

                  if (jobs.isEmpty) {
                    return const Center(
                      child: Text('لم تقم بنشر أي وظائف بعد'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return JobApplicantsCard(
                        jobId: job.id,
                        jobTitle: job['title'],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
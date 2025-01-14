import 'package:flutter/material.dart';
import '../services/job_application_service.dart';
import '../models/application.dart';
import '../widgets/user_route_wrapper.dart';
import '../widgets/job_listing_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplicationsHistoryPage extends StatelessWidget {
  static final JobApplicationService _applicationService = JobApplicationService();

  const ApplicationsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return UserRouteWrapper(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: Column(
          children: [
            Container(
              height: 125,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: const SafeArea(
                child: Center(
                  child: Text(
                    'تقديماتي',
                    style: TextStyle(
                      color: Color(0xFF6A6A6A),
                      fontSize: 20,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('applications')
                    .where('userId', isEqualTo: user?.uid)
                    .orderBy('appliedAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final applications = snapshot.data?.docs ?? [];

                  if (applications.isEmpty) {
                    return const Center(
                      child: Text(
                        'لم تقم بالتقديم على أي وظيفة بعد',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          color: Color(0xFF6A6A6A),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: applications.length,
                    itemBuilder: (context, index) {
                      final application = applications[index].data() as Map<String, dynamic>;
                      return JobListingCard(
                        title: application['jobTitle'] ?? '',
                        company: application['company'] ?? '',
                        location: application['location'] ?? {},
                        salary: application['salary'] ?? {},
                        jobType: application['jobType'] ?? '',
                        workType: application['workType'] ?? '',
                        status: application['status'] ?? 'pending',
                        onTap: () {
                          Navigator.pushNamed(
                            context, 
                            '/applications/details',
                            arguments: applications[index].id,
                          );
                        },
                        buttonText: _getStatusText(application['status'] ?? 'pending'),
                        buttonColor: _getStatusColor(application['status'] ?? 'pending'),
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

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'قيد المراجعة';
      case 'reviewed':
        return 'تمت المراجعة';
      case 'accepted':
        return 'مقبول';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'غير معروف';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'reviewed':
        return Colors.blue;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
} 
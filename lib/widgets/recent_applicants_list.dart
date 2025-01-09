import 'package:flutter/material.dart';
import '../models/job_application.dart';
import '../services/job_application_service.dart';
import 'recent_applicant_card.dart';

class RecentApplicantsList extends StatelessWidget {
  const RecentApplicantsList({super.key});

  @override
  Widget build(BuildContext context) {
    final jobApplicationService = JobApplicationService();

    return SizedBox(
      width: 319,
      height: 650,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            width: double.infinity,
            child: Text(
              'آخر المتقدمين ',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF1A1D1E),
                fontSize: 14,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<List<JobApplication>>(
              stream: jobApplicationService.getCompanyApplications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final applications = snapshot.data ?? [];

                if (applications.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا يوجد متقدمين حالياً',
                      style: TextStyle(
                        color: Color(0xFF6A6A6A),
                        fontSize: 14,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: applications.length,
                  itemBuilder: (context, index) {
                    final application = applications[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: RecentApplicantCard(
                        applicantName: application.jobSeekerName,
                        jobTitle: application.jobTitle,
                        timeAgo: _getTimeAgo(application.appliedAt),
                        onMessageTap: () {
                          // TODO: Navigate to chat with applicant
                        },
                        onCVTap: () {
                          // TODO: View applicant's CV
                        },
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

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    
    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
} 
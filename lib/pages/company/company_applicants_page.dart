import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/company_route_wrapper.dart';
import '../../models/job_application.dart';
import 'job_applicants_page.dart';

class CompanyApplicantsPage extends StatelessWidget {
  const CompanyApplicantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return CompanyRouteWrapper(
      currentIndex: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 125,
              decoration: const ShapeDecoration(
                color: Color(0xFFF5F5F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
              ),
              child: const Center(
                child: Text(
                  'المتقدمين',
                  style: TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize: 20,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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

                  final jobs = snapshot.data!.docs;

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

class JobApplicantsCard extends StatelessWidget {
  final String jobId;
  final String jobTitle;

  const JobApplicantsCard({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  Future<void> _updateApplicationStatus(String applicationId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('applications')
        .doc(applicationId)
        .update({
      'status': newStatus,
      'reviewedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('applications')
          .where('jobId', isEqualTo: jobId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        
        final applications = snapshot.data!.docs
            .map((doc) => JobApplication.fromFirestore(doc))
            .toList();

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text(
              jobTitle,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'عدد المتقدمين: ${applications.length}',
              style: const TextStyle(
                fontFamily: 'Cairo',
              ),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (String status) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobApplicantsPage(
                      jobId: jobId,
                      jobTitle: jobTitle,
                    ),
                  ),
                );
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: JobApplication.STATUS_PENDING,
                  child: Text('قيد المراجعة (${_getStatusCount(applications, JobApplication.STATUS_PENDING)})'),
                ),
                PopupMenuItem<String>(
                  value: JobApplication.STATUS_REVIEWED,
                  child: Text('تمت المراجعة (${_getStatusCount(applications, JobApplication.STATUS_REVIEWED)})'),
                ),
                PopupMenuItem<String>(
                  value: JobApplication.STATUS_ACCEPTED,
                  child: Text('مقبول (${_getStatusCount(applications, JobApplication.STATUS_ACCEPTED)})'),
                ),
                PopupMenuItem<String>(
                  value: JobApplication.STATUS_REJECTED,
                  child: Text('مرفوض (${_getStatusCount(applications, JobApplication.STATUS_REJECTED)})'),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JobApplicantsPage(
                    jobId: jobId,
                    jobTitle: jobTitle,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  int _getStatusCount(List<JobApplication> applications, String status) {
    return applications.where((app) => app.status == status).length;
  }
} 
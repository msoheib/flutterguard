import 'package:flutter/material.dart';
import '../models/job_post.dart';
import '../services/job_application_service.dart';
import '../widgets/job_detail_header.dart';
import '../widgets/job_detail_content.dart';
import '../widgets/recyclers/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/application_success_page.dart';

class JobDetailPage extends StatefulWidget {
  final JobPost job;
  
  const JobDetailPage({super.key, required this.job});
  
  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  final JobApplicationService _applicationService = JobApplicationService();
  bool _hasApplied = false;

  @override
  void initState() {
    super.initState();
    _checkApplicationStatus();
  }

  Future<void> _checkApplicationStatus() async {
    final hasApplied = await _applicationService.hasApplied(widget.job.id);
    setState(() {
      _hasApplied = hasApplied;
    });
  }

  Future<void> _handleApply() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Get user data for the application
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      final userData = userDoc.data() ?? {};

      await FirebaseFirestore.instance.collection('applications').add({
        'jobId': widget.job.id,
        'userId': user.uid,
        'status': 'pending',
        'appliedAt': FieldValue.serverTimestamp(),
        'company': widget.job.company,
        'jobTitle': widget.job.title,
        'companyId': widget.job.companyId,
        'location': widget.job.location,
        'salary': widget.job.salary,
        'jobType': widget.job.type,
        'workType': widget.job.workType,
        'jobSeekerName': userData['name'] ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
        'reviewedAt': null,
      });

      // Update job application count
      await FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.job.id)
          .update({
        'totalApplications': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update user's application count
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'applicationCount': FieldValue.increment(1),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      setState(() {
        _hasApplied = true;
      });

      if (!mounted) return;
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ApplicationSuccessPage(),
        ),
      );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء تقديم الطلب')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'تفاصيل الوظيفة',
              onBackPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      JobDetailHeader(
                        job: widget.job,
                        hasApplied: _hasApplied,
                        onApply: _handleApply,
                      ),
                      const SizedBox(height: 16),
                      JobDetailContent(job: widget.job),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
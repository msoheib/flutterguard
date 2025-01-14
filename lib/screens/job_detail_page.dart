import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/job_post.dart';
import '../services/job_application_service.dart';
import '../screens/application_success_page.dart';
import '../widgets/recyclers/appbar.dart';
import '../services/job_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JobDetailPage extends StatefulWidget {
  final String jobId;
  
  const JobDetailPage({super.key, required this.jobId});
  
  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  final JobApplicationService _applicationService = JobApplicationService();
  final JobService _jobService = JobService();
  bool _hasApplied = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkApplicationStatus();
  }

  Future<void> _checkApplicationStatus() async {
    final hasApplied = await _applicationService.hasApplied(widget.jobId);
    setState(() {
      _hasApplied = hasApplied;
    });
  }

  Future<void> _applyForJob(JobPost job) async {
    setState(() => _isLoading = true);
    try {
      await _applicationService.applyForJob(
        job,
        FirebaseAuth.instance.currentUser?.displayName ?? '',
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ApplicationSuccessPage(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: CustomAppBar(title: 'تفاصيل الوظيفة'),
      body: StreamBuilder<JobPost?>(
        stream: _jobService.getJobStream(widget.jobId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final job = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildJobHeader(job),
                const SizedBox(height: 16),
                _buildJobDetailsSection(job),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatChip(String text, String iconPath) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: ShapeDecoration(
        color: const Color(0xFFF6F7F8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF6A6A6A),
              fontSize: 10,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 6),
          SvgPicture.asset(
            iconPath,
            width: 10,
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: ShapeDecoration(
        color: const Color(0xFFF6F7F8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF6A6A6A),
          fontSize: 10,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    Color backgroundColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else {
      return '${difference.inMinutes} دقيقة';
    }
  }

  Widget _buildJobHeader(JobPost job) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Company Logo and Name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                job.company,
                style: const TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontSize: 12,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 33,
                height: 33,
                decoration: const ShapeDecoration(
                  color: Color(0xFFF3F3F3),
                  shape: OvalBorder(),
                ),
                child: job.companyLogo != null 
                  ? ClipOval(child: Image.network(job.companyLogo!))
                  : null,
              ),
            ],
          ),
          // ... rest of the header
        ],
      ),
    );
  }

  Widget _buildJobDetailsSection(JobPost job) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: ShapeDecoration(
            color: const Color(0xFFF8F8F9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text(
            'تفاصيل الوظيفة',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color(0xFF1A1D1E),
              fontSize: 14,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                job.description,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontSize: 12,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 
import 'package:flutter/material.dart';
import '../models/job_post.dart';
import '../services/job_application_service.dart';
import '../services/job_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/application_success_page.dart';

class JobDetailsPage extends StatefulWidget {
  final String jobId;
  
  const JobDetailsPage({super.key, required this.jobId});
  
  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: StreamBuilder<JobPost?>(
        stream: _jobService.getJobStream(widget.jobId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final job = snapshot.data!;
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildJobHeader(job),
                  const SizedBox(height: 16),
                  _buildJobDetailsSection(job),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildJobHeader(JobPost job) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Company info row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Job stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${job.salary['amount']} ر.س / شهريا',
                style: const TextStyle(
                  color: Color(0xFF1A1D1E),
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Text(
                    job.title,
                    style: const TextStyle(
                      color: Color(0xFF1A1D1E),
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
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
                  ),
                ],
              ),
            ],
          ),
          
          // Action buttons
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => _applyForJob(job),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CA6A8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'قدم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                job.location['city'] ?? job.location['address'] ?? '',
                style: const TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontSize: 12,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 1.90,
                height: 2,
                decoration: const ShapeDecoration(
                  color: Color(0xFF6A6A6A),
                  shape: OvalBorder(),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                job.company,
                style: const TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontSize: 12,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetailsSection(JobPost job) {
    return Column(
      children: [
        // Section Title
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
        
        // Details Container
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
              // Job Description
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
              const SizedBox(height: 16),
              
              // Qualifications Section
              const Text(
                'المؤهلات المطلوبة',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF1A1D1E),
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
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
              
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFEEEEEE)),
              const SizedBox(height: 16),
              
              // Required Skills Section
              const Text(
                'المهارات المطلوبة',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF1A1D1E),
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              _buildSkillsGrid(job.requiredSkills),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsGrid(List<String> skills) {
    return Wrap(
      spacing: 13,
      runSpacing: 8,
      alignment: WrapAlignment.end,
      children: skills.map((skill) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: ShapeDecoration(
          color: const Color(0xFFF6F7F8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          skill,
          style: const TextStyle(
            color: Color(0xFF6A6A6A),
            fontSize: 10,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w600,
          ),
        ),
      )).toList(),
    );
  }

  Future<void> _applyForJob(JobPost job) async {
    setState(() => _isLoading = true);
    try {
      await _applicationService.applyForJob(
        job,
        FirebaseAuth.instance.currentUser?.displayName ?? ''
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
} 
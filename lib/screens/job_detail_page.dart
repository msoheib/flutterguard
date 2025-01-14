import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/job_post.dart';
import '../services/job_application_service.dart';
import '../screens/application_success_page.dart';

class JobDetailPage extends StatefulWidget {
  final String jobId;
  
  const JobDetailPage({super.key, required this.jobId});
  
  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  final JobApplicationService _applicationService = JobApplicationService();
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
        jobId: job.id,
        companyId: job.companyId,
        coverLetter: null, // You might want to add a form for this
        attachments: null, // And this
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
      backgroundColor: const Color(0xFFFBFBFB),
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

          return Stack(
            children: [
              // ... rest of your existing UI code, but use job from snapshot
              // For example:
              Text(job.title),
              Text(job.company),
              // etc...

              // Bottom Apply Button
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: ElevatedButton(
                  onPressed: _hasApplied || _isLoading
                      ? null 
                      : () => _applyForJob(job),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CA6A8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _hasApplied ? 'تم التقديم' : 'تقديم طلب',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
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
} 
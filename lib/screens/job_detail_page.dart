import 'package:flutter/material.dart';
import 'package:security_guard/models/job_post.dart';
import 'package:intl/intl.dart';
import '../widgets/authenticated_layout.dart';

class JobDetailPage extends StatelessWidget {
  final JobPost job;

  const JobDetailPage({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthenticatedLayout(
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F8),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF4CA6A8)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 16),
                _buildJobDetailsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Company Logo and Name
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                child: job.companyLogo.isNotEmpty
                    ? Image.network(job.companyLogo)
                    : const Icon(Icons.business, color: Color(0xFF6A6A6A)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Job Stats (Applications and Time Posted)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildStatChip(
                '${job.applicationsCount} متقدم للوظيفة',
                Icons.person_outline,
              ),
              const SizedBox(width: 8),
              _buildStatChip(
                _getTimeAgo(job.createdAt),
                Icons.access_time,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Salary and Job Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'شهريا',
                    style: TextStyle(
                      color: Color(0xFF6A6A6A),
                      fontSize: 10,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '${job.salary['amount']} ${job.salary['currency']} /',
                    style: const TextStyle(
                      color: Color(0xFF1A1D1E),
                      fontSize: 14,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
                    child: const Icon(Icons.work_outline, color: Color(0xFF6A6A6A)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Location and Company
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                job.location,
                style: const TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontSize: 12,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 2,
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
          const SizedBox(height: 16),

          // Job Type Tags
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildTag(job.title),
              const SizedBox(width: 8),
              _buildTag(job.type),
            ],
          ),

          const SizedBox(height: 16),
          // Skills Match
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                '9 من 10 مهارات تتطابق مع ملفك الشخصي',
                style: TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontSize: 12,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 20,
                height: 20,
                child: const Icon(Icons.check_circle_outline, color: Color(0xFF4CA6A8), size: 20),
              ),
            ],
          ),

          const SizedBox(height: 16),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton('حفظ', false),
              const SizedBox(width: 8),
              _buildActionButton('قدم', true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetailsSection() {
    return Column(
      children: [
        _buildSectionHeader('تفاصيل الوظيفة'),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Job Description
              ...job.requirements.map((req) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  req,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize: 12,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )).toList(),

              const Divider(color: Color(0xFFEEEEEE)),
              const SizedBox(height: 16),

              // Qualifications
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
              ...job.qualifications.map((qual) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  qual,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize: 12,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )).toList(),

              const Divider(color: Color(0xFFEEEEEE)),
              const SizedBox(height: 16),

              // Required Skills
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
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: job.skills.map((skill) => _buildTag(skill)).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: ShapeDecoration(
        color: const Color(0xFFF8F8F9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: Color(0xFF1A1D1E),
          fontSize: 14,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildStatChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: ShapeDecoration(
        color: const Color(0xFFF6F7F8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          Icon(icon, size: 10, color: const Color(0xFF6A6A6A)),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: ShapeDecoration(
        color: const Color(0xFFF6F7F8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _buildActionButton(String text, bool isPrimary) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        color: isPrimary ? const Color(0xFF4CA6A8) : const Color(0xFFF8F8F9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isPrimary ? Colors.white : const Color(0xFF4CA6A8),
          fontSize: 14,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inMinutes} دقيقة';
    }
  }
} 
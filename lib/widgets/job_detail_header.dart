import 'package:flutter/material.dart';
import '../models/job_post.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JobDetailHeader extends StatelessWidget {
  final JobPost job;
  final bool hasApplied;
  final VoidCallback onApply;
  final VoidCallback? onCancelApplication;

  const JobDetailHeader({
    super.key,
    required this.job,
    required this.hasApplied,
    required this.onApply,
    this.onCancelApplication,
  });

  @override
  Widget build(BuildContext context) {
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
                    ? ClipOval(
                        child: Image.network(
                          job.companyLogo!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Job Stats (applicants count, posted time)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildStatChip(
                '${job.applicantsCount} متقدم للوظيفة',
                'assets/media/icons/users.svg',
              ),
              const SizedBox(width: 8),
              _buildStatChip(
                'منذ 20 ساعة',
                'assets/media/icons/clock.svg',
              ),
            ],
          ),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: hasApplied && onCancelApplication != null
                ? _buildActionButtonsWithCancel(context)
                : _buildActionButtons(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {/* Handle save */},
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFF8F8F9),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: const Text(
              'حفظ',
              style: TextStyle(
                color: Color(0xFF4CA6A8),
                fontSize: 14,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextButton(
            onPressed: hasApplied ? null : onApply,
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF4CA6A8),
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: Text(
              hasApplied ? 'تم التقديم' : 'قدم',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButtonsWithCancel(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {/* Handle save */},
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF8F8F9),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: const Text(
                  'حفظ',
                  style: TextStyle(
                    color: Color(0xFF4CA6A8),
                    fontSize: 14,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextButton(
                onPressed: null,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF4CA6A8),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: const Text(
                  'تم التقديم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onCancelApplication,
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFFFF0F0),
            padding: const EdgeInsets.symmetric(vertical: 8),
            minimumSize: const Size(double.infinity, 36),
          ),
          child: const Text(
            'إلغاء التقديم',
            style: TextStyle(
              color: Color(0xFFE53935),
              fontSize: 14,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
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
          SizedBox(
            width: 10,
            height: 10,
            child: SvgPicture.asset(
              iconPath,
              width: 10,
              height: 10,
              colorFilter: const ColorFilter.mode(
                Color(0xFF6A6A6A),
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
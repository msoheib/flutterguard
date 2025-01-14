import 'package:flutter/material.dart';
import '../models/job_post.dart';

class JobDetailContent extends StatelessWidget {
  final JobPost job;

  const JobDetailContent({
    super.key,
    required this.job,
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Job Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              job.description,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF6A6A6A),
                fontSize: 12,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Requirements Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'المؤهلات المطلوبة',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF1A1D1E),
                fontSize: 14,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Requirements List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: job.requirements.map((requirement) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    requirement,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFF6A6A6A),
                      fontSize: 12,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ).toList(),
            ),
          ),
          
          const Divider(color: Color(0xFFEEEEEE)),
          
          // Skills Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'المهارات المطلوبة',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF1A1D1E),
                fontSize: 14,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Skills Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: job.skills.map((skill) => 
                Container(
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
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
} 
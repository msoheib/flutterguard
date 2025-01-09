import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobDetailsPage extends StatelessWidget {
  final String jobId;

  const JobDetailsPage({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    print('Loading job details for ID: $jobId'); // Debug print

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الوظيفة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Job ID: $jobId')),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .doc(jobId)
            .snapshots(),
        builder: (context, snapshot) {
          // Debug prints
          print('Connection state: ${snapshot.connectionState}');
          if (snapshot.hasError) print('Error: ${snapshot.error}');
          if (snapshot.hasData) print('Data received: ${snapshot.data?.data()}');

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'حدث خطأ\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                'لم يتم العثور على الوظيفة',
                textAlign: TextAlign.center,
              ),
            );
          }

          final jobData = snapshot.data!.data() as Map<String, dynamic>;
          
          return Container(
            color: const Color(0xFFF6F7F8), // Background color
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildJobHeader(jobData),
                  const SizedBox(height: 16),
                  _buildJobDetails(jobData),
                  const SizedBox(height: 16),
                  _buildRequiredSkills(jobData),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildJobHeader(Map<String, dynamic> jobData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Company Logo and Name
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                jobData['companyName'] ?? 'أسم الشركة',
                style: const TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontSize: 12,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 33,
                height: 33,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  shape: BoxShape.circle,
                ),
                child: jobData['companyLogo'] != null
                    ? Image.network(jobData['companyLogo'])
                    : const Icon(Icons.business),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Job Title and Salary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${jobData['salary']} ر.س / شهريا',
                style: const TextStyle(
                  color: Color(0xFF1A1D1E),
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                jobData['title'] ?? 'عنوان الوظيفة',
                style: const TextStyle(
                  color: Color(0xFF1A1D1E),
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          // Action Buttons
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8F8F9),
                  foregroundColor: const Color(0xFF4CA6A8),
                ),
                child: const Text('حفظ'),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CA6A8),
                  foregroundColor: Colors.white,
                ),
                child: const Text('قدم'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetails(Map<String, dynamic> jobData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'تفاصيل الوظيفة',
            style: TextStyle(
              color: Color(0xFF1A1D1E),
              fontSize: 14,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            jobData['description'] ?? '',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF6A6A6A),
              fontSize: 12,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequiredSkills(Map<String, dynamic> jobData) {
    final skills = (jobData['requiredSkills'] as List?)?.cast<String>() ?? [];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'المهارات المطلوبة',
            style: TextStyle(
              color: Color(0xFF1A1D1E),
              fontSize: 14,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.end,
            children: skills.map((skill) => _buildSkillChip(skill)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
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
    );
  }
} 
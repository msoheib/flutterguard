import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/job_application.dart';
import '../../widgets/company_route_wrapper.dart';
import '../../screens/applicant_profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

class JobApplicantsPage extends StatelessWidget {
  final String jobId;
  final String jobTitle;

  const JobApplicantsPage({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: Column(
        children: [
          // Header
          Container(
            height: 125,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Center(
                    child: Text(
                      'المتقدمين ل$jobTitle',
                      style: const TextStyle(
                        color: Color(0xFF6A6A6A),
                        fontSize: 20,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Applicants List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('applications')
                  .where('jobId', isEqualTo: jobId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final applications = snapshot.data!.docs;

                if (applications.isEmpty) {
                  return const Center(
                    child: Text('لا يوجد متقدمين لهذه الوظيفة'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: applications.length,
                  itemBuilder: (context, index) {
                    final application = applications[index].data() as Map<String, dynamic>;
                    return ApplicantCard(
                      application: application,
                      applicationId: applications[index].id,
                      onStatusUpdate: (String newStatus) => _updateApplicationStatus(
                        applications[index].id,
                        newStatus,
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

  Future<void> _updateApplicationStatus(String applicationId, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('applications')
        .doc(applicationId)
        .update({
      'status': newStatus,
      'reviewedAt': FieldValue.serverTimestamp(),
    });
  }
}

class ApplicantCard extends StatelessWidget {
  final Map<String, dynamic> application;
  final String applicationId;
  final Function(String) onStatusUpdate;

  const ApplicantCard({
    super.key,
    required this.application,
    required this.applicationId,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    application['jobSeekerName'] ?? 'مجهول',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusChip(application['status'] ?? 'pending'),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: [
                _buildActionButton(
                  context,
                  'السيرة الذاتية',
                  Icons.description,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ApplicantProfilePage(
                        applicantId: application['userId'],
                      ),
                    ),
                  ),
                ),
                _buildActionButton(
                  context,
                  'اتصال',
                  Icons.phone,
                  () => _makePhoneCall(application['phone']),
                ),
                PopupMenuButton<String>(
                  onSelected: onStatusUpdate,
                  child: _buildActionButton(
                    context,
                    'تحديث الحالة',
                    Icons.more_vert,
                    null,
                  ),
                  itemBuilder: (BuildContext context) => [
                    _buildPopupMenuItem('pending', 'قيد المراجعة'),
                    _buildPopupMenuItem('reviewed', 'تمت المراجعة'),
                    _buildPopupMenuItem('accepted', 'مقبول للمقابلة'),
                    _buildPopupMenuItem('rejected', 'مرفوض'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback? onPressed,
  ) {
    return SizedBox(
      height: 36,
      child: TextButton.icon(
        onPressed: onPressed ?? () {},
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value, String text) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(
        text,
        style: const TextStyle(fontFamily: 'Cairo'),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String statusText;

    switch (status) {
      case 'pending':
        chipColor = Colors.orange;
        statusText = 'قيد المراجعة';
        break;
      case 'reviewed':
        chipColor = Colors.blue;
        statusText = 'تمت المراجعة';
        break;
      case 'accepted':
        chipColor = Colors.green;
        statusText = 'مقبول للمقابلة';
        break;
      case 'rejected':
        chipColor = Colors.red;
        statusText = 'مرفوض';
        break;
      default:
        chipColor = Colors.grey;
        statusText = 'غير معروف';
    }

    return Chip(
      label: Text(
        statusText,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
    );
  }

  Future<void> _makePhoneCall(String? phone) async {
    if (phone == null) return;
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }
} 
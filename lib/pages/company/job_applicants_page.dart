import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/applicant_profile_page.dart';
import '../../widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/chat_service.dart';
import '../../models/chat.dart';
import '../../screens/chat_detail_page.dart';

class JobApplicantsPage extends StatelessWidget {
  final String jobId;
  final String jobTitle;

  const JobApplicantsPage({
    super.key,
    required this.jobId,
    required this.jobTitle,
  });

  Future<void> _createOrNavigateToChat(BuildContext context, String applicantId, String applicantName) async {
    final companyId = FirebaseAuth.instance.currentUser?.uid;
    if (companyId == null) return;

    try {
      // Create a valid document ID by combining IDs
      final chatId = '${companyId}_${applicantId}';
      
      // Reference to chats collection with valid document ID
      final chatRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId);

      // Check if chat exists
      final chatDoc = await chatRef.get();
      if (!chatDoc.exists) {
        // Get company info first
        final companyDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(companyId)
            .get();
        
        final companyData = companyDoc.data();
        final companyInfo = companyData?['companyInfo'] as Map<String, dynamic>?;
        final companyName = companyInfo?['name'] ?? 'مجهول';

        // Get job seeker info
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(applicantId)
            .get();
        
        final userData = userDoc.data();
        final profile = userData?['profile'] as Map<String, dynamic>?;
        final personalInfo = profile?['personalInfo'] as Map<String, dynamic>?;
        final jobSeekerName = personalInfo?['fullName'] ?? 'مجهول';
        final jobSeekerPhone = userData?['phoneNumber'] ?? '';

        // Create new chat document with all user info
        await chatRef.set({
          'participants': [companyId, applicantId],
          'lastMessage': '',
          'lastMessageTime': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'companyId': companyId,
          'jobSeekerId': applicantId,
          'jobSeekerName': jobSeekerName,
          'jobSeekerPhone': jobSeekerPhone,
          'companyName': companyName,
        });
      }

      // Navigate to chat detail
      if (!context.mounted) return;
      Navigator.pushNamed(
        context,
        '/chat_detail',
        arguments: {
          'chatId': chatId,
          'otherUserId': applicantId,
          'otherUserName': applicantName,
        },
      );
    } catch (e) {
      print('Error creating chat: $e');
    }
  }

  Future<void> _updateApplicationStatus(String applicationId, String newStatus) async {
    try {
      // Get the application data first to access user ID and job details
      final applicationDoc = await FirebaseFirestore.instance
          .collection('applications')
          .doc(applicationId)
          .get();
      
      final applicationData = applicationDoc.data();
      if (applicationData == null) return;

      final userId = applicationData['userId'];
      
      // Update application status
      await FirebaseFirestore.instance
          .collection('applications')
          .doc(applicationId)
          .update({
        'status': newStatus,
        'reviewedAt': FieldValue.serverTimestamp(),
      });

      // Create notification for the user
      String notificationMessage;
      switch (newStatus) {
        case 'accepted':
          notificationMessage = 'تم قبول طلبك للوظيفة: $jobTitle';
          break;
        case 'rejected':
          notificationMessage = 'تم رفض طلبك للوظيفة: $jobTitle';
          break;
        case 'need_details':
          notificationMessage = 'يحتاج طلبك لمزيد من التفاصيل للوظيفة: $jobTitle';
          break;
        default:
          notificationMessage = 'تم تحديث حالة طلبك للوظيفة: $jobTitle';
      }

      // Add notification to Firestore
      await FirebaseFirestore.instance
          .collection('notifications')
          .add({
        'userId': userId,
        'message': notificationMessage,
        'jobId': jobId,
        'applicationId': applicationId,
        'type': 'application_status',
        'status': newStatus,
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });

    } catch (e) {
      print('Error updating application status: $e');
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'need_details':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: Column(
        children: [
          CustomAppBar(
            title: 'المتقدمين',
            onBackPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      jobTitle,
                      style: const TextStyle(
                        color: Color(0xFF1A1D1E),
                        fontSize: 16,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('applications')
                          .where('jobId', isEqualTo: jobId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('حدث خطأ');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final applications = snapshot.data?.docs ?? [];

                        if (applications.isEmpty) {
                          return const Center(
                            child: Text('لا يوجد متقدمين حالياً'),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: applications.length,
                          itemBuilder: (context, index) {
                            final application = applications[index].data() as Map<String, dynamic>;
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x2D99AAC5),
                                    blurRadius: 62,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        application['jobSeekerName'] ?? 'مجهول',
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
                                  const SizedBox(height: 16),
                                  Text(
                                    jobTitle,
                                    style: const TextStyle(
                                      color: Color(0xFF6A6A6A),
                                      fontSize: 12,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () => _createOrNavigateToChat(
                                              context,
                                              application['userId'],
                                              application['jobSeekerName'] ?? 'مجهول',
                                            ),
                                            style: TextButton.styleFrom(
                                              backgroundColor: const Color(0xFFF3F3F3),
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                            ),
                                            child: const Text(
                                              'مراسلة',
                                              style: TextStyle(
                                                color: Color(0xFF4CA6A8),
                                                fontSize: 14,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ApplicantProfilePage(
                                                    applicantId: application['userId'],
                                                  ),
                                                ),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: const Color(0xFF4CA6A8),
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                            ),
                                            child: const Text(
                                              'السيرة الذاتية',
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
                                      DropdownButton<String>(
                                        value: application['status'] ?? 'pending',
                                        items: [
                                          DropdownMenuItem(
                                            value: 'pending',
                                            child: Text(
                                              'قيد المراجعة',
                                              style: TextStyle(
                                                color: _getStatusColor('pending'),
                                                fontFamily: 'Cairo',
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'accepted',
                                            child: Text(
                                              'مقبول',
                                              style: TextStyle(
                                                color: _getStatusColor('accepted'),
                                                fontFamily: 'Cairo',
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'rejected',
                                            child: Text(
                                              'مرفوض',
                                              style: TextStyle(
                                                color: _getStatusColor('rejected'),
                                                fontFamily: 'Cairo',
                                              ),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'need_details',
                                            child: Text(
                                              'يحتاج تفاصيل',
                                              style: TextStyle(
                                                color: _getStatusColor('need_details'),
                                                fontFamily: 'Cairo',
                                              ),
                                            ),
                                          ),
                                        ],
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            _updateApplicationStatus(applications[index].id, newValue);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/applicant_profile_page.dart';
import '../../widgets/custom_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  Future<void> _createOrNavigateToChat(BuildContext context, String applicantId, String applicantName, String jobId) async {
    final companyId = FirebaseAuth.instance.currentUser?.uid;
    if (companyId == null) return;

    final chatService = ChatService();
    // Create or get existing chat
    final chatId = await chatService.createChat(applicantId, companyId, jobId);
    
    if (!context.mounted) return;
    
    // Get chat data
    final chatDoc = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .get();
        
    final chat = Chat.fromFirestore(chatDoc);

    // Navigate to chat detail page
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(
          chat: chat,
          isCompany: true,
        ),
      ),
    );
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
          Padding(
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
                      return const CircularProgressIndicator();
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
                          height: 192,
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
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
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
                                          'منذ 20 ساعة',
                                          style: const TextStyle(
                                            color: Color(0xFF6A6A6A),
                                            fontSize: 10,
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        SvgPicture.asset(
                                          'assets/media/icons/clock.svg',
                                          width: 10,
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
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
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () => _createOrNavigateToChat(
                                            context,
                                            application['userId'],
                                            application['jobSeekerName'] ?? 'مجهول',
                                            jobId,
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
                                  ],
                                ),
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
        ],
      ),
    );
  }
} 
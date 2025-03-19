import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/company_route_wrapper.dart';
import '../../components/navigation/app_bars/notification_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/applicant_profile_page.dart';
import 'package:intl/intl.dart';

class CompanyHomePage extends StatelessWidget {
  const CompanyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CompanyRouteWrapper(
      currentIndex: 0,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            // Header using NotificationAppBar
                            NotificationAppBar(
                              title: 'أسم التطبيق',
                              useFilterIcon: true, // Use filter icon instead of bell
                              onNotificationPressed: () {
                                // Add filter functionality here
                              },
                              avatarUrl: 'assets/media/icons/avatar.png', // Use local asset
                              isAvatarAsset: true, // Specify that we're using an asset image
                              onAvatarPressed: () => Navigator.pushNamed(context, '/profile'),
                            ),

                            // Main Content
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const SizedBox(height: 20),
                                      
                                      // Search Bar
                                      Container(
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 44,
                                              height: 44,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF4CA6A8),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: SvgPicture.asset(
                                                  'assets/media/icons/filter.svg',
                                                  width: 24,
                                                  height: 24,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: TextField(
                                                textAlign: TextAlign.right,
                                                decoration: InputDecoration(
                                                  hintText: 'ابحث هنا...',
                                                  border: InputBorder.none,
                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      const SizedBox(height: 20),
                                      
                                      // Stats Panels
                                      Column(
                                        children: [
                                          // Posted Jobs Panel
                                          Container(
                                            width: double.infinity,
                                            constraints: const BoxConstraints(
                                              minHeight: 85,
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF4CA6A8),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width: 44,
                                                  height: 44,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.10),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Center(
                                                    child: SvgPicture.asset(
                                                      'assets/media/icons/work_experience.svg',
                                                      width: 24,
                                                      height: 24,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: const [
                                                    Text(
                                                      '0',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontFamily: 'Cairo',
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    Text(
                                                      'الوظائف المنشورة',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontFamily: 'Cairo',
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          const SizedBox(height: 16),
                                          
                                          // Total Applicants Panel
                                          Container(
                                            width: double.infinity,
                                            constraints: const BoxConstraints(
                                              minHeight: 85,
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF4CA6A8),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width: 44,
                                                  height: 44,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.10),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Center(
                                                    child: SvgPicture.asset(
                                                      'assets/media/icons/users.svg',
                                                      width: 24,
                                                      height: 24,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: const [
                                                    Text(
                                                      '0',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontFamily: 'Cairo',
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    Text(
                                                      'إجمالي المتقدمين',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontFamily: 'Cairo',
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          const SizedBox(height: 24),
                                          
                                          // Recent Applicants Widget
                                          const RecentApplicantsWidget(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class RecentApplicantsWidget extends StatelessWidget {
  const RecentApplicantsWidget({super.key});

  Future<void> _createOrNavigateToChat(BuildContext context, String applicantId, String applicantName) async {
    final companyId = FirebaseAuth.instance.currentUser?.uid;
    if (companyId == null) return;

    try {
      // Create a valid document ID by combining IDs
      final chatId = '${companyId}_$applicantId';
      
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

        // Create new chat document with all user info
        await chatRef.set({
          'participants': [companyId, applicantId],
          'lastMessage': '',
          'lastMessageTime': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'companyId': companyId,
          'jobSeekerId': applicantId,
          'jobSeekerName': applicantName,
          'companyName': companyName,
          'unreadCompany': false,
          'unreadJobSeeker': false,
          'jobId': '', // Empty since this is initiated from applicant card
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

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'منذ وقت ما';
    
    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);
    
    if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }

  @override
  Widget build(BuildContext context) {
    final companyId = FirebaseAuth.instance.currentUser?.uid;

    return Container(
      width: 319,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 319,
            child: const Text(
              'آخر المتقدمين ',
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
          
          // Recent Applicants List
          StreamBuilder<QuerySnapshot>(
            // Modified query to catch more applications
            stream: FirebaseFirestore.instance
              .collection('applications')
              .limit(3)
              .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final applications = snapshot.data?.docs ?? [];

              if (applications.isEmpty) {
                return Container(
                  width: double.infinity,
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
                  child: const Center(
                    child: Text(
                      'لم يتقدم أحد للوظائف حتى الآن',
                      style: TextStyle(
                        color: Color(0xFF6A6A6A),
                        fontSize: 14,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                );
              }

              // Success - we have applications to display
              print("Found ${applications.length} applications");
              
              return Column(
                children: applications.map((doc) {
                  // Debug application data
                  print("Application data: ${doc.data()}");
                  
                  final application = doc.data() as Map<String, dynamic>;
                  final timestamp = application['createdAt'] as Timestamp?;
                  final applicantId = application['userId'] as String? ?? '';
                  final jobTitle = application['jobTitle'] as String? ?? 'عنوان الوظيفة المنشورة';
                  final applicantName = application['jobSeekerName'] as String? ?? 'أسم المتقدم';

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
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Time row
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                ' ',
                                style: TextStyle(
                                  color: Color(0xFF6A6A6A),
                                  fontSize: 12,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: ShapeDecoration(
                                  color: Color(0xFFF6F7F8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      _formatTimestamp(timestamp),
                                      style: TextStyle(
                                        color: Color(0xFF6A6A6A),
                                        fontSize: 10,
                                        fontFamily: 'Cairo',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        
                        // Applicant info
                        Container(
                          width: 287,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Applicant name and avatar
                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  applicantName,
                                                  style: TextStyle(
                                                    color: Color(0xFF1A1D1E),
                                                    fontSize: 14,
                                                    fontFamily: 'Cairo',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Container(
                                                  width: 33,
                                                  height: 33,
                                                  decoration: ShapeDecoration(
                                                    color: Color(0xFFF3F3F3),
                                                    shape: OvalBorder(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  jobTitle,
                                                  style: TextStyle(
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
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              
                              // Action buttons
                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Message button
                                    GestureDetector(
                                      onTap: () => _createOrNavigateToChat(
                                        context,
                                        applicantId,
                                        applicantName,
                                      ),
                                      child: Container(
                                        width: 134,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: ShapeDecoration(
                                          color: Color(0xFFF3F3F3),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'مراسلة',
                                              style: TextStyle(
                                                color: Color(0xFF4CA6A8),
                                                fontSize: 14,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w500,
                                                height: 1.71,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                                    // CV Button
                                    GestureDetector(
                                      onTap: () {
                                        if (applicantId.isNotEmpty) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ApplicantProfilePage(
                                                applicantId: applicantId,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: 134,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: ShapeDecoration(
                                          color: Color(0xFF4CA6A8),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'السيرة الذاتية',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w500,
                                                height: 1.71,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
} 
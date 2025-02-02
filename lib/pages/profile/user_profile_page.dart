import 'package:flutter/material.dart';
import '../../widgets/user_route_wrapper.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return UserRouteWrapper(
      currentIndex: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: Column(
          children: [
            // Header Section
            SizedBox(
              width: 375,
              height: 125,
              child: Stack(
                children: [
                  // Background Shape
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 375,
                      height: 125,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFF5F5F5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Title and Icon
                  Positioned(
                    left: 347,
                    top: 60,
                    child: Transform(
                      transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(3.14),
                      child: SizedBox(
                        width: 319,
                        height: 44,
                        child: Stack(
                          children: [
                            // Icon Button
                            Positioned(
                              left: 44,
                              top: 0,
                              child: Transform(
                                transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(3.14),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  padding: const EdgeInsets.all(10),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF4CA6A8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            // Title
                            Positioned(
                              left: 226,
                              top: 10,
                              child: Transform(
                                transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(3.14),
                                child: const Text(
                                  'الملف الشخصي',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Color(0xFF6A6A6A),
                                    fontSize: 20,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w600,
                                    height: 1.40,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Status Bar
                  Positioned(
                    left: 0,
                    top: 0,
                    child: SizedBox(
                      width: 375,
                      height: 44,
                      child: Stack(
                        children: [
                          // Battery Icon
                          Positioned(
                            left: 336.33,
                            top: 17.33,
                            child: SizedBox(
                              width: 24.33,
                              height: 11.33,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Opacity(
                                      opacity: 0.35,
                                      child: Container(
                                        width: 22,
                                        height: 11.33,
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(width: 1, color: Color(0xFF1A1D1E)),
                                            borderRadius: BorderRadius.circular(2.67),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 2,
                                    top: 2,
                                    child: Container(
                                      width: 18,
                                      height: 7.33,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFF1A1D1E),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(1.33),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Time
                          Positioned(
                            left: 21,
                            top: 13,
                            child: SizedBox(
                              width: 54,
                              child: const Text(
                                '9:41',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF1A1D1E),
                                  fontSize: 15,
                                  fontFamily: 'SF Pro Text',
                                  fontWeight: FontWeight.w600,
                                  height: 1.33,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Profile Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Profile Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CA6A8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: Color(0xFF4CA6A8),
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'عبدالله فؤاد سعيد سالم',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'حارس امن',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Menu Items
                    _buildMenuItem(Icons.person_outline, 'معلومات عنك'),
                    _buildMenuItem(Icons.work_outline, 'خبراتك في العمل'),
                    _buildMenuItem(Icons.school_outlined, 'التعليم'),
                    _buildMenuItem(Icons.star_outline, 'المهارات'),
                    _buildMenuItem(Icons.language, 'اللغات'),
                    _buildMenuItem(Icons.badge_outlined, 'الشهادات'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8ECF4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF4CA6A8),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1A1D1E),
            fontSize: 16,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.add,
          color: Color(0xFF4CA6A8),
        ),
      ),
    );
  }
} 
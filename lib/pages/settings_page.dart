import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/auth_service.dart';
import '../widgets/recyclers/user_navbar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SizedBox(
        height: screenHeight,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section
                  Container(
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: ShapeDecoration(
                              image: const DecorationImage(
                                image: AssetImage('assets/media/icons/avatar.png'),
                                fit: BoxFit.cover,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                            ),
                          ),
                          const Text(
                            'أسم التطبيق',
                            style: TextStyle(
                              color: Color(0xFF6A6A6A),
                              fontSize: 20,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Settings Options
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 16, 28, 100),
                    child: Column(
                      children: [
                        _buildSettingItem(
                          icon: 'assets/media/icons/profile.svg',
                          title: 'الملف الشخصي',
                          onTap: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                        ),
                        const SizedBox(height: 11),
                        _buildSettingItem(
                          icon: 'assets/media/icons/customer_service.svg',
                          title: 'خدمة العملاء',
                          onTap: () {
                            Navigator.pushNamed(context, '/support');
                          },
                        ),
                        const SizedBox(height: 11),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                await AuthService().signOut();
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/login',
                                    (route) => false,
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('حدث خطأ أثناء تسجيل الخروج'),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'تسجيل الخروج',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: UserNavBar(
                currentIndex: 3,
                onTap: (index) {
                  final routes = [
                    '/jobseeker/home',
                    '/jobseeker/applications',
                    '/jobseeker/chat',
                    '/jobseeker/settings',
                  ];
                  Navigator.pushReplacementNamed(context, routes[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF6A6A6A),
                fontSize: 14,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
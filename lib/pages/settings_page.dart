import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../components/navigation/app_bars/notification_app_bar.dart';
import '../services/auth_service.dart';
import '../widgets/user_route_wrapper.dart';
import '../services/support_service.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final supportService = SupportService();
    
    return UserRouteWrapper(
      currentIndex: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        appBar: const NotificationAppBar(
          title: 'أسم التطبيق', // App name
          avatarUrl: 'assets/media/icons/avatar.png',
          isAvatarAsset: true,
          notificationCount: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Main settings menu
              Column(
                children: [
                  // Profile
                  _buildSettingItem(
                    title: 'الملف الشخصي',
                    iconPath: 'assets/media/icons/users.svg',
                    onTap: () {
                      Navigator.pushNamed(context, '/jobseeker/cv');
                    },
                  ),
                  
                  const SizedBox(height: 11),
                  
                  // Share app
                  _buildSettingItem(
                    title: 'مشاركة التطبيق',
                    iconPath: 'assets/media/icons/share.svg',
                    onTap: () {
                      Share.share('تطبيق حارس الأمن - حمل التطبيق الآن من متجر التطبيقات');
                    },
                  ),
                  
                  const SizedBox(height: 11),
                  
                  // Customer support
                  _buildSettingItem(
                    title: 'خدمة العملاء',
                    iconPath: 'assets/media/icons/support.svg',
                    onTap: () {
                      Navigator.pushNamed(context, '/support');
                    },
                  ),
                  
                  const SizedBox(height: 11),
                  
                  // Logout button
                  _buildSettingItem(
                    title: 'تسجيل الخروج',
                    iconPath: 'assets/media/icons/logout.svg',
                    onTap: () async {
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF4CA6A8),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                'assets/media/icons/arrow_back.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF6A6A6A),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
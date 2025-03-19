import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../services/auth_service.dart';
import '../../widgets/company_route_wrapper.dart';
import '../../components/navigation/app_bars/notification_app_bar.dart';
import 'company_profile_page.dart';

class CompanySettingsPage extends StatelessWidget {
  const CompanySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CompanyRouteWrapper(
      currentIndex: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: SafeArea(
          child: Column(
            children: [
              // Header using NotificationAppBar
              NotificationAppBar(
                title: 'أسم التطبيق',
                useFilterIcon: false,
                notificationIconPath: 'assets/media/icons/bell.svg',
                onNotificationPressed: () {
                  // Notification functionality here
                },
                avatarUrl: 'assets/media/icons/avatar.png',
                isAvatarAsset: true,
                onAvatarPressed: () => Navigator.pushNamed(context, '/profile'),
              ),
              
              // Main content
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Personal Profile button
                            _buildSettingItemFigma(
                              title: 'الملف الشخصي للشركة',
                              iconPath: 'assets/media/icons/about_me.svg',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CompanyProfilePage(),
                                  ),
                                );
                              },
                            ),
                            
                            const SizedBox(height: 11),
                            
                            // Customer Service button
                            _buildSettingItemFigma(
                              title: 'خدمة العملاء',
                              iconPath: 'assets/media/icons/support.svg',
                              onTap: () {
                                Navigator.pushNamed(context, '/company/support');
                              },
                            ),
                            
                            const SizedBox(height: 11),
                            
                            // Logout button
                            _buildSettingItemFigma(
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
                                      SnackBar(
                                        content: Text('حدث خطأ أثناء تسجيل الخروج: ${e.toString()}'),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItemFigma({
    required String title,
    required VoidCallback onTap,
    required String iconPath,
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
              color: Color(0x0D000000),
              blurRadius: 4,
              offset: Offset(0, 2),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              color: const Color(0xFF6A6A6A),
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
          ],
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/[dep]custom_bottom_navigation_bar.dart';
import '../../services/auth_service.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: Stack(
        children: [
          // Header Background
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
          ),
          
          // Main Content
          Column(
            children: [
              // Status Bar
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '9:41',
                      style: TextStyle(
                        color: Color(0xFF1A1D1E),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        _buildBatteryIcon(),
                        const SizedBox(width: 5),
                        _buildWifiIcon(),
                        const SizedBox(width: 5),
                        _buildCellularIcon(),
                      ],
                    ),
                  ],
                ),
              ),

              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CA6A8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.menu, color: Colors.white),
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
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        image: const DecorationImage(
                          image: AssetImage('assets/media/icons/avatar.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Settings Options
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
                child: Column(
                  children: [
                    _buildSettingItem(
                      icon: 'assets/media/icons/profile.svg',
                      title: 'الملف الشخصي',
                      onTap: () {
                        Navigator.pushNamed(context, '/admin/profile');
                      },
                    ),
                    const SizedBox(height: 11),
                    _buildSettingItem(
                      icon: 'assets/media/icons/logout.svg',
                      title: 'تسجيل الخروج',
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0, // Settings is index 0
        onTap: (index) {
          switch (index) {
            case 0: // Already on settings
              break;
            case 1: // Support
              Navigator.pushNamed(context, '/admin/support');
              break;
            case 2: // Companies
              Navigator.pushNamed(context, '/admin/companies');
              break;
            case 3: // Users
              Navigator.pushNamed(context, '/admin/users');
              break;
            case 4: // Home
              Navigator.pushNamed(context, '/admin/dashboard');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 20),
            label: 'الأعدادت',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent, size: 20),
            label: 'الدعم الفني',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business, size: 20),
            label: 'الشركات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people, size: 20),
            label: 'المستخدمين',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 20),
            label: 'الرئيسة',
          ),
        ],
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
        width: double.infinity,
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

  Widget _buildBatteryIcon() {
    return Container(
      width: 24.33,
      height: 11.33,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1A1D1E), width: 1),
        borderRadius: BorderRadius.circular(2.67),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D1E),
            borderRadius: BorderRadius.circular(1.33),
          ),
        ),
      ),
    );
  }

  Widget _buildWifiIcon() {
    return const Icon(
      Icons.wifi,
      size: 15.33,
      color: Color(0xFF1A1D1E),
    );
  }

  Widget _buildCellularIcon() {
    return const Icon(
      Icons.signal_cellular_4_bar,
      size: 17,
      color: Color(0xFF1A1D1E),
    );
  }
} 
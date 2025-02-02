import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserNavbar extends StatefulWidget {
  const UserNavbar({super.key});

  @override
  _UserNavbarState createState() => _UserNavbarState();
}

class _UserNavbarState extends State<UserNavbar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/jobseeker/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/jobseeker/profile');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/applicant-review');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/jobseeker/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/media/icons/home.svg',
            colorFilter: ColorFilter.mode(
              _selectedIndex == 0 ? const Color(0xFF4CA6A8) : const Color(0xFF6A6A6A),
              BlendMode.srcIn,
            ),
          ),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/media/icons/profile.svg',
            colorFilter: ColorFilter.mode(
              _selectedIndex == 1 ? const Color(0xFF4CA6A8) : const Color(0xFF6A6A6A),
              BlendMode.srcIn,
            ),
          ),
          label: 'الملف الشخصي',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/media/icons/applications.svg',
            colorFilter: ColorFilter.mode(
              _selectedIndex == 2 ? const Color(0xFF4CA6A8) : const Color(0xFF6A6A6A),
              BlendMode.srcIn,
            ),
          ),
          label: 'التقديمات',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/media/icons/settings.svg',
            colorFilter: ColorFilter.mode(
              _selectedIndex == 3 ? const Color(0xFF4CA6A8) : const Color(0xFF6A6A6A),
              BlendMode.srcIn,
            ),
          ),
          label: 'الإعدادات',
        ),
      ],
    );
  }
} 
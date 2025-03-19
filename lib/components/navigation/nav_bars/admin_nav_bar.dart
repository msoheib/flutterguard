import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const AdminNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    onTap?.call(index);

    // Default routing - now with reversed indices
    switch (index) {
      case 3:
        Navigator.pushReplacementNamed(context, '/admin/applications');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/admin/chat');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/admin/users');
        break;
      case 0:
        Navigator.pushReplacementNamed(context, '/admin/settings');
        break;
      default:
        Navigator.pushReplacementNamed(context, '/admin/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Reversed order of navigation items
          _buildNavItem(context, 0, 'assets/media/icons/settings.svg', 'الإعدادات'),
          _buildNavItem(context, 1, 'assets/media/icons/users.svg', 'المستخدمين'),
          _buildNavItem(context, 2, 'assets/media/icons/Chat.svg', 'المحادثات'),
          _buildNavItem(context, 3, 'assets/media/icons/applicants.svg', 'التقديمات'),
          _buildNavItem(context, 4, 'assets/media/icons/Home.svg', 'الرئيسية'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, String iconPath, String label) {
    final isSelected = index == currentIndex;
    return InkWell(
      onTap: () => _onItemTapped(context, index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 30,
              height: 30,
              colorFilter: ColorFilter.mode(
                isSelected ? const Color(0xFF4CA6A8) : const Color(0xFFA8A8AA),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? const Color(0xFF4CA6A8) : const Color(0xFFA8A8AA),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
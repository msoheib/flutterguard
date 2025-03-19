import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const UserNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

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
          _buildNavItem(context, 3, 'assets/media/icons/settings.svg', 'الإعدادات'),
          _buildNavItem(context, 2, 'assets/media/icons/Chat.svg', 'المحادثات'),
          _buildNavItem(context, 1, 'assets/media/icons/applicants.svg', 'التقديمات'),
          _buildNavItem(context, 0, 'assets/media/icons/Home.svg', 'الرئيسية'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, String iconPath, String label) {
    final isSelected = index == currentIndex;
    return InkWell(
      onTap: () {
        print('UserNavBar: Item $index tapped');
        onTap(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
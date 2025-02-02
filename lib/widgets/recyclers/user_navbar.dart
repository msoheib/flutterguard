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

  Widget _buildNavItem(int index, String label, String iconPath) {
    final bool isSelected = currentIndex == index;
    final color = isSelected ? const Color(0xFF4CA6A8) : const Color(0xFFA8A8AA);
    
    try {
      return GestureDetector(
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 30,
              height: 30,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              placeholderBuilder: (context) => Icon(Icons.error),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w400,
                height: 1,
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error loading icon: $e');
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.50),
                  topRight: Radius.circular(30.50),
                ),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x3FCCCCCC),
                  blurRadius: 16,
                  offset: Offset(0, -2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavItem(3, 'الإعدادات', 'assets/media/icons/settings.svg'),
                _buildNavItem(2, 'المحادثات', 'assets/media/icons/Chat.svg'),
                _buildNavItem(1, 'التقديمات', 'assets/media/icons/applicants.svg'),
                _buildNavItem(0, 'الرئيسية', 'assets/media/icons/Home.svg'),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 34,
            padding: const EdgeInsets.only(
              top: 21,
              left: 121,
              right: 120,
              bottom: 8,
            ),
            decoration: const BoxDecoration(color: Colors.white),
            child: Center(
              child: Container(
                width: 134,
                height: 5,
                decoration: ShapeDecoration(
                  color: Color(0xFF1E293B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
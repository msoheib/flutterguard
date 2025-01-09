import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;

  const Navbar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return SizedBox(
      height: 104,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: screenWidth,
            height: 70,
            decoration: ShapeDecoration(
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
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNavItem(context, 3, 'الأعدادت', 'assets/media/icons/settings.svg'),
                  _buildNavItem(context, 2, 'المفصلة', 'assets/media/icons/bookmark.svg'),
                  _buildNavItem(context, 1, 'الرسائل', 'assets/media/icons/Chat.svg'),
                  _buildNavItem(context, 0, 'الرئيسة', 'assets/media/icons/Home.svg'),
                ],
              ),
            ),
          ),
          Container(
            width: screenWidth,
            height: 34,
            padding: const EdgeInsets.only(
              top: 21,
              bottom: 8,
            ),
            decoration: BoxDecoration(color: Colors.white),
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

  Widget _buildNavItem(BuildContext context, int index, String label, String iconPath) {
    final isSelected = currentIndex == index;
    final routes = [
      '/jobseeker/home',
      '/jobseeker/chat',
      '/jobseeker/filter',
      '/jobseeker/settings',
    ];

    final Color color = isSelected ? const Color(0xFF4CA6A8) : const Color(0xFFA8A8AA);

    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, routes[index]),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 8),
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
      ),
    );
  }
}

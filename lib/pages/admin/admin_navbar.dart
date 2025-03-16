import 'package:flutter/material.dart';

class AdminNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.home, 'الرئيسة'),
          _buildNavItem(1, Icons.people, 'المستخدمين'),
          _buildNavItem(2, Icons.business, 'الشركات'),
          _buildNavItem(3, Icons.support_agent, 'الدعم الفني'),
          _buildNavItem(4, Icons.settings, 'الأعدادت'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    
    return InkWell(
      onTap: () => onTap(index),
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected 
                ? const Color(0xFF4CA6A8)
                : const Color(0xFFA8A8AA),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected 
                  ? const Color(0xFF4CA6A8)
                  : const Color(0xFFA8A8AA),
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
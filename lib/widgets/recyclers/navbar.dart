import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 415,
      height: 75, // Increased height to accommodate the indicator
      child: Column(
        children: [
          Container(
            width: 375,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, "الأعدادت", Icons.settings),
                _buildNavItem(1, "المفصلة", Icons.list),
                _buildNavItem(2, "الرسائل", Icons.message),
                _buildNavItem(3, "الرئيسة", Icons.home),
              ],
            ),
          ),
          Container(
            width: 134,
            height: 5,
            margin: EdgeInsets.only(left: 60.0 + (currentIndex * 75.0)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color(0xff1e293b),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Color(0xff1e293b) : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: isSelected ? Color(0xff1e293b) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
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
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = currentIndex == index;
          
          return InkWell(
            onTap: () => onTap(index),
            child: SizedBox(
              width: 70,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: IconTheme(
                      data: IconThemeData(
                        size: 20,
                        color: isSelected 
                          ? const Color(0xFF1A1D1E)
                          : const Color(0xFFA8A8AA),
                      ),
                      child: item.icon,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.label ?? '',
                    style: TextStyle(
                      color: isSelected 
                        ? const Color(0xFF1A1D1E)
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
        }),
      ),
    );
  }
} 
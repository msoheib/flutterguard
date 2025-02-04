import 'package:flutter/material.dart';

class AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static void handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0: // Home
        Navigator.pushReplacementNamed(context, '/admin/dashboard');
        break;
      case 1: // Users
        Navigator.pushReplacementNamed(context, '/admin/users');
        break;
      case 2: // Companies
        Navigator.pushReplacementNamed(context, '/admin/companies');
        break;
      case 3: // Support
        Navigator.pushReplacementNamed(context, '/admin/support');
        break;
      case 4: // Settings
        Navigator.pushReplacementNamed(context, '/admin/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = const [
      ('الرئيسة', Icons.home),
      ('المستخدمين', Icons.people),
      ('الشركات', Icons.business),
      ('الدعم الفني', Icons.support_agent),
      ('الأعدادت', Icons.settings),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
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
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(items.length, (index) {
                final (label, icon) = items[index];
                final isSelected = currentIndex == index;
                
                return InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: 20,
                        color: isSelected 
                          ? const Color(0xFF1A1D1E)
                          : const Color(0xFFA8A8AA),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        label,
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
                );
              }),
            ),
          ),
        ),
        Container(
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
                color: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 
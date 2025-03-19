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

    print('AdminNavBar: Item $index tapped. Current index: $currentIndex');
    
    // Call the onTap callback first to update parent state
    if (onTap != null) {
      print('AdminNavBar: Using custom onTap for index $index');
      onTap!(index);
    }

    // Then handle navigation directly for consistent behavior
    print('AdminNavBar: Navigating to route for index $index');
    
    // Navigate directly based on the button that was tapped
    switch (index) {
      case 0: // Home button
        print('AdminNavBar: Home button tapped, navigating to /admin/dashboard');
        Navigator.of(context).pushReplacementNamed('/admin/dashboard');
        break;
      case 1: // Users button
        print('AdminNavBar: Users button tapped, navigating to /admin/users');
        Navigator.of(context).pushReplacementNamed('/admin/users');
        break;
      case 2: // Companies button
        print('AdminNavBar: Companies button tapped, navigating to /admin/applications');
        Navigator.of(context).pushReplacementNamed('/admin/applications');
        break;
      case 3: // Support button
        print('AdminNavBar: Support button tapped, navigating to /admin/chat');
        Navigator.of(context).pushReplacementNamed('/admin/chat');
        break;
      case 4: // Settings button
        print('AdminNavBar: Settings button tapped, navigating to /admin/settings');
        Navigator.of(context).pushReplacementNamed('/admin/settings');
        break;
      default:
        Navigator.of(context).pushReplacementNamed('/admin/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x3FCCCCCC),
            blurRadius: 16,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // In RTL mode: first child (index 0) appears on the right
              _buildNavButton(
                index: 0,
                iconPath: 'assets/media/icons/Home.svg',
                label: 'الرئيسية',
                context: context,
              ),
              
              _buildNavButton(
                index: 1,
                iconPath: 'assets/media/icons/users.svg',
                label: 'المستخدمين',
                context: context,
              ),
              
              _buildNavButton(
                index: 2,
                iconPath: 'assets/media/icons/applicants.svg',
                label: 'الشركات',
                context: context,
              ),
              
              _buildNavButton(
                index: 3,
                iconPath: 'assets/media/icons/Chat.svg',
                label: 'الدعم الفني',
                context: context,
              ),
              
              _buildNavButton(
                index: 4,
                iconPath: 'assets/media/icons/settings.svg',
                label: 'الإعدادات',
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to build each navigation button
  Widget _buildNavButton({
    required int index,
    required String iconPath,
    required String label,
    required BuildContext context,
  }) {
    final bool isActive = currentIndex == index;
    
    return InkWell(
      onTap: () {
        print('AdminNavBar: Button $index tapped');
        _onItemTapped(context, index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 30,
            height: 30,
            colorFilter: ColorFilter.mode(
              isActive ? const Color(0xFF4CA6A8) : const Color(0xFFA8A8AA),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF4CA6A8) : const Color(0xFFA8A8AA),
              fontSize: 12,
              fontFamily: 'Cairo',
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
} 
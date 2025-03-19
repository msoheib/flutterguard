import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompanyNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const CompanyNavBar({
    required this.currentIndex,
    this.onTap,
    super.key,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;
    
    print('CompanyNavBar: Item $index tapped');

    // Use custom route handler if provided
    if (onTap != null) {
      onTap!(index);
      return;
    }

    // Default routing
    switch (index) {
      case 0:
        print('CompanyNavBar: Navigating to /company/home');
        Navigator.pushReplacementNamed(context, '/company/home');
        break;
      case 1:
        print('CompanyNavBar: Navigating to /company/applications');
        Navigator.pushReplacementNamed(context, '/company/applications');
        break;
      case 2:
        print('CompanyNavBar: Navigating to /company/chat');
        Navigator.pushReplacementNamed(context, '/company/chat');
        break;
      case 3:
        print('CompanyNavBar: Navigating to /company/settings');
        Navigator.pushReplacementNamed(context, '/company/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Background container with rounded corners and shadow
          Container(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Settings (الإعدادات)
                  _buildNavItem(context, 3, 'assets/media/icons/settings.svg', 'الإعدادات'),
                  
                  // Applicants (المتقدمين)
                  _buildNavItem(context, 1, 'assets/media/icons/applicants.svg', 'المتقدمين'),
                  
                  // Empty space for FAB
                  const SizedBox(width: 50),
                  
                  // Messages (الرسائل)
                  _buildNavItem(context, 2, 'assets/media/icons/Chat.svg', 'الرسائل'),
                  
                  // Home (الرئيسية)
                  _buildNavItem(context, 0, 'assets/media/icons/Home.svg', 'الرئيسية'),
                ],
              ),
            ),
          ),
          
          // Floating Action Button
          Positioned(
            top: -20,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFF4CA6A8),
                shape: BoxShape.circle,
              ),
              child: InkWell(
                onTap: () {
                  print('CompanyNavBar: FAB tapped, navigating to create job');
                  Navigator.pushNamed(context, '/company/create-job');
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, String iconPath, String label) {
    final isSelected = index == currentIndex;
    return InkWell(
      onTap: () {
        print('CompanyNavBar: _buildNavItem onTap for index $index');
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
              isSelected ? const Color(0xFF4CA6A8) : const Color(0xFFA8A8AA),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF4CA6A8) : const Color(0xFFA8A8AA),
              fontSize: 12,
              fontFamily: 'Cairo',
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
} 
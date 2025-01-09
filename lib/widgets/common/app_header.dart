import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onProfileTap;
  final VoidCallback? onActionTap;
  final String actionIcon;
  final Color actionButtonColor;
  final bool showBackButton;

  const AppHeader({
    super.key,
    required this.title,
    this.onProfileTap,
    this.onActionTap,
    this.actionIcon = 'assets/media/icons/filter.svg',
    this.actionButtonColor = const Color(0xFF4CA6A8),
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Button (Profile or Back)
              if (showBackButton)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: actionButtonColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Transform.rotate(
                      angle: 3.14159, // 180 degrees for RTL
                      child: SvgPicture.asset(
                        'assets/media/icons/back.svg',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: onProfileTap,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      image: const DecorationImage(
                        image: AssetImage('assets/media/icons/avatar.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              // Title
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontSize: 20,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                ),
              ),
              // Action Button (Filter/Search)
              GestureDetector(
                onTap: onActionTap,
                child: Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: actionButtonColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset(
                    actionIcon,
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackButtonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final Color backgroundColor;
  final Color titleColor;
  final Color buttonColor;

  const BackButtonAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.backgroundColor = Colors.white,
    this.titleColor = const Color(0xFF6A6A6A),
    this.buttonColor = const Color(0xFF4CA6A8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight + 20, // Add some extra space
      color: backgroundColor,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Title in center
            Positioned(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 20,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
            
            // Back button on right
            Positioned(
              right: 16,
              child: GestureDetector(
                onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                child: Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/media/icons/arrow_back.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 20);
} 
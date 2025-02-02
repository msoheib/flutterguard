import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  
  const CustomAppBar({
    super.key, 
    required this.title,
    this.onBackPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375,
      height: 125,
      child: Stack(
        children: [
          // Background container
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 375,
              height: 125,
              decoration: const ShapeDecoration(
                color: Color(0xFFF5F5F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
              ),
            ),
          ),
          // Content container
          Positioned(
            left: 24,
            top: 60,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 44), // Left spacer
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize: 20,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                    height: 1.40,
                  ),
                ),
                if (onBackPressed != null)
                  GestureDetector(
                    onTap: onBackPressed,
                    child: Container(
                      width: 44,
                      height: 44,
                      padding: const EdgeInsets.all(10),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF4CA6A8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
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
                  const SizedBox(width: 44), // Right spacer when no back button
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(125);
} 
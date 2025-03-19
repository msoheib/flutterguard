import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? titleColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      color: backgroundColor ?? Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Stack(
            children: [
              // Center title
              if (centerTitle)
                Positioned.fill(
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: titleColor ?? const Color(0xFF6A6A6A),
                        fontSize: 20,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
              // Title aligned to right if not centered
              if (!centerTitle)
                Positioned(
                  right: showBackButton ? 70 : 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: titleColor ?? const Color(0xFF6A6A6A),
                        fontSize: 20,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              
              // Back button on right corner
              if (showBackButton)
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: onBackPressed ?? () => Navigator.of(context).pop(),
                      child: Container(
                        width: 44,
                        height: 44,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CA6A8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Transform.scale(
                          scaleX: -1,
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
                  ),
                ),
              
              // Actions at left
              if (actions != null && actions!.isNotEmpty)
                Positioned(
                  left: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Row(
                      children: actions!,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
} 
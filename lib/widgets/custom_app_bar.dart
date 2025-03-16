import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showLogo;
  final bool showNotification;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.showLogo = false,
    this.showNotification = false,
    this.onNotificationTap,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showBackButton)
                IconButton(
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios),
                )
              else if (showNotification)
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CA6A8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: onNotificationTap,
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                const SizedBox(width: 44),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontSize: 20,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (showLogo)
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    image: const DecorationImage(
                      image: AssetImage('assets/media/icons/avatar.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                const SizedBox(width: 44),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(125);
} 
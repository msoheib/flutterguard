import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? profileImageUrl;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const StatusBar({
    super.key,
    required this.title,
    this.profileImageUrl,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
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
        padding: const EdgeInsets.only(
          top: 20,
          left: 28,
          right: 28,
          bottom: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onProfileTap,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  profileImageUrl ?? "https://via.placeholder.com/44x44",
                ),
                radius: 22,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF6A6A6A),
                fontSize: 20,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF4CA6A8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                onPressed: onNotificationTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(125);
} 
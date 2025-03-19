import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationPressed;
  final int notificationCount;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? titleColor;
  final Widget? leadingWidget;
  final String? avatarUrl;
  final VoidCallback? onAvatarPressed;
  final String? notificationIconPath;
  final bool useFilterIcon;
  final bool isAvatarAsset;

  const NotificationAppBar({
    super.key,
    required this.title,
    this.onNotificationPressed,
    this.notificationCount = 0,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.titleColor,
    this.leadingWidget,
    this.avatarUrl,
    this.onAvatarPressed,
    this.notificationIconPath = 'assets/media/icons/bell.svg',
    this.useFilterIcon = false,
    this.isAvatarAsset = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF5F5F5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User avatar on left
              GestureDetector(
                onTap: onAvatarPressed,
                child: leadingWidget ?? Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.grey[300],
                    image: avatarUrl != null 
                      ? DecorationImage(
                          image: isAvatarAsset 
                            ? AssetImage(avatarUrl!) as ImageProvider
                            : NetworkImage(avatarUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  ),
                  child: avatarUrl == null ? Icon(
                    Icons.person,
                    color: Colors.grey[600],
                    size: 24,
                  ) : null,
                ),
              ),

              // App title in center
              Text(
                title,
                style: TextStyle(
                  color: titleColor ?? const Color(0xFF6A6A6A),
                  fontSize: 20,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                ),
              ),

              // Notification button on right
              GestureDetector(
                onTap: onNotificationPressed,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CA6A8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Notification icon
                      Center(
                        child: SvgPicture.asset(
                          useFilterIcon 
                              ? 'assets/media/icons/filter.svg'
                              : notificationIconPath!,
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      
                      // Notification badge
                      if (notificationCount > 0)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Center(
                              child: Text(
                                notificationCount > 9 ? '9+' : notificationCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
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
  Size get preferredSize => const Size.fromHeight(125);
} 
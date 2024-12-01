import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../pages/home_page.dart';
import '../../pages/chat_page.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  int? _pressedIndex;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Set initial index based on current route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context)?.settings.name;
      if (route == '/chat') {
        setState(() => _selectedIndex = 2);
      } else if (route == '/home') {
        setState(() => _selectedIndex = 3);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) async {
    if (_selectedIndex == index) return;

    setState(() => _pressedIndex = index);
    
    // Play tap animation and haptic feedback
    _controller.forward().then((_) {
      _controller.reverse().then((_) {
        setState(() => _pressedIndex = null);
      });
    });
    HapticFeedback.lightImpact();

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 2: // الرسائل
        if (ModalRoute.of(context)?.settings.name != '/chat') {
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => const ChatPage(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              settings: const RouteSettings(name: '/chat'),
            ),
            (route) => false,
          );
        }
        break;
      case 3: // الرئيسية
        if (ModalRoute.of(context)?.settings.name != '/home') {
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => const HomePage(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
              settings: const RouteSettings(name: '/home'),
            ),
            (route) => false,
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildNavItem(0, 'الأعدادت', 'assets/media/icons/Setting.svg', 'assets/media/icons/Setting_selected.svg'),
          _buildNavItem(1, 'المفصلة', 'assets/media/icons/Ahead.svg', 'assets/media/icons/Ahead_selected.svg'),
          _buildNavItem(2, 'الرسائل', 'assets/media/icons/Chat.svg', 'assets/media/icons/Chat_selected.svg'),
          _buildNavItem(3, 'الرئيسة', 'assets/media/icons/Home.svg', 'assets/media/icons/Home_selected.svg'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String icon, String selectedIcon) {
    final bool isSelected = _selectedIndex == index;
    final bool isPressed = _pressedIndex == index;

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          isSelected ? selectedIcon : icon,
          width: 20,
          height: 20,
          color: isSelected ? const Color(0xFF4CA6A8) : const Color(0xFFA8A8AA),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4CA6A8) : const Color(0xFFA8A8AA),
            fontSize: 12,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w400,
            height: 0.08,
          ),
        ),
      ],
    );

    if (isPressed) {
      content = ScaleTransition(
        scale: _animation,
        child: content,
      );
    }

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: content,
    );
  }
}

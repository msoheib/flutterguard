import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../pages/home_page.dart';
import '../../pages/chat_page.dart';
import '../../screens/create_job_page.dart';

class CompanyNavbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback? onProfileTap;

  const CompanyNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onProfileTap,
  });

  @override
  State<CompanyNavbar> createState() => _CompanyNavbarState();
}

class _CompanyNavbarState extends State<CompanyNavbar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _pressedIndex;
  bool _isAddButtonPressed = false;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) async {
    if (widget.currentIndex == index) return;

    setState(() => _pressedIndex = index);
    
    // Play tap animation and haptic feedback
    await _controller.forward();
    await _controller.reverse();
    setState(() => _pressedIndex = null);
    HapticFeedback.lightImpact();

    // Call onTap after animation
    widget.onTap(index);

    // Handle navigation after animation completes
    if (mounted) {
      switch (index) {
        case 0: // Settings/Profile
          if (widget.onProfileTap != null) {
            widget.onProfileTap!();
          }
          break;
        case 2: // Create Job
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateJobPage(),
            ),
          );
          break;
        case 3: // الرسائل
          if (ModalRoute.of(context)?.settings.name != '/chat') {
            Navigator.pushAndRemoveUntil(
              context,
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
        case 4: // الرئيسة
          if (ModalRoute.of(context)?.settings.name != '/home') {
            Navigator.pushAndRemoveUntil(
              context,
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
  }

  // Add Job Post Button positioned on top
  Widget _buildAddButton() {
    return Positioned(
      top: -12.5,
      left: MediaQuery.of(context).size.width / 2 - 25,
      child: GestureDetector(
        onTap: () {
          setState(() => _isAddButtonPressed = true);
          _controller.forward().then((_) {
            _controller.reverse().then((_) {
              setState(() => _isAddButtonPressed = false);
            });
          });
          HapticFeedback.lightImpact();
          _onItemTapped(2);
        },
        child: ScaleTransition(
          scale: _animation,
          child: Container(
            width: 50,
            height: 50,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: _isAddButtonPressed 
                ? const Color(0xFF3A8587)
                : const Color(0xFF4CA6A8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(555),
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/media/icons/add.svg',
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.50),
              topRight: Radius.circular(30.50),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x3FCCCCCC),
                blurRadius: 16,
                offset: Offset(0, -2),
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavItem(0, 'الأعدادت', 'assets/media/icons/Setting.svg', 'assets/media/icons/Setting_selected.svg'),
              _buildNavItem(1, 'المتقدمين', 'assets/media/icons/applicants.svg', 'assets/media/icons/applicants_selected.svg'),
              // Placeholder for center button
              const SizedBox(width: 50),
              _buildNavItem(3, 'الرسائل', 'assets/media/icons/Chat.svg', 'assets/media/icons/Chat_selected.svg'),
              _buildNavItem(4, 'الرئيسة', 'assets/media/icons/Home.svg', 'assets/media/icons/Home_selected.svg'),
            ],
          ),
        ),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildNavItem(int index, String label, String icon, String selectedIcon) {
    final bool isSelected = widget.currentIndex == index;
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
          colorFilter: ColorFilter.mode(
            isSelected ? const Color(0xFF4CA6A8) : const Color(0xFFA8A8AA),
            BlendMode.srcIn,
          ),
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
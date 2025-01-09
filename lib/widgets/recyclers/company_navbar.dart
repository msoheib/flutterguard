import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_theme.dart';
import '../../services/navigation_service.dart';

class CompanyNavbar extends StatelessWidget {
  final int currentIndex;

  const CompanyNavbar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return SizedBox(
      height: 104,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: screenWidth,
            height: 70,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusXxl),
                topRight: Radius.circular(AppTheme.radiusXxl),
              ),
              boxShadow: AppTheme.shadowMd,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNavItem(context, 3, 'الأعدادت', 'assets/media/icons/settings.svg'),
                  _buildNavItem(context, 2, 'المتقدمين', 'assets/media/icons/applicants.svg'),
                  _buildAddJobButton(context),
                  _buildNavItem(context, 1, 'الرسائل', 'assets/media/icons/Chat.svg'),
                  _buildNavItem(context, 0, 'الرئيسة', 'assets/media/icons/Home.svg'),
                ],
              ),
            ),
          ),
          Container(
            width: screenWidth,
            height: 34,
            padding: const EdgeInsets.only(
              top: 21,
              bottom: 8,
            ),
            decoration: BoxDecoration(color: AppTheme.surface),
            child: Center(
              child: Container(
                width: 134,
                height: 5,
                decoration: ShapeDecoration(
                  color: AppTheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, String label, String iconPath) {
    final isSelected = currentIndex == index;
    final Color color = isSelected ? const Color(0xFF4CA6A8) : AppTheme.textSecondary;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          NavigationService.handleCompanyNavigation(context, index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 30,
            height: 30,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            label,
            style: AppTheme.labelMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildAddJobButton(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/company/create-job');
        },
        child: Container(
          width: 75,
          height: 75,
          padding: const EdgeInsets.all(AppTheme.spacingSm),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFF4CA6A8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
            ),
          ),
          child: SvgPicture.asset(
            'assets/media/icons/add.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(AppTheme.textOnPrimary, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
} 
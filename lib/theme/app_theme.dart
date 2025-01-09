import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primary = Color(0xFF4CA6A8);
  static const Color secondary = Color(0xFF1A1D1E);
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1D1E);
  static const Color textSecondary = Color(0xFFA8A8AA);
  static const Color textDisabled = Color(0xFF6A6A6A);
  static const Color textOnPrimary = Colors.white;

  // Border Colors
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color dividerColor = Color(0xFFE5E7EB);

  // Shadow Colors
  static const Color shadowColor = Color(0x3FCCCCCC);

  // Spacing
  static const double spacingXxs = 4;
  static const double spacingXs = 8;
  static const double spacingSm = 12;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  // Border Radius
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusXxl = 30.5;
  static const double radiusCircular = 555;

  // Font Sizes
  static const double fontSizeXs = 10;
  static const double fontSizeSm = 12;
  static const double fontSizeMd = 14;
  static const double fontSizeLg = 16;
  static const double fontSizeXl = 18;
  static const double fontSizeXxl = 24;

  // Font Weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Shadows
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: shadowColor,
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: shadowColor,
      blurRadius: 16,
      offset: Offset(0, -2),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: shadowColor,
      blurRadius: 24,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: fontSizeXxl,
    fontWeight: fontWeightBold,
    fontFamily: 'Cairo',
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: fontSizeXl,
    fontWeight: fontWeightBold,
    fontFamily: 'Cairo',
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: fontSizeLg,
    fontWeight: fontWeightSemiBold,
    fontFamily: 'Cairo',
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSizeLg,
    fontWeight: fontWeightRegular,
    fontFamily: 'Cairo',
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSizeMd,
    fontWeight: fontWeightRegular,
    fontFamily: 'Cairo',
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSizeSm,
    fontWeight: fontWeightRegular,
    fontFamily: 'Cairo',
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: fontSizeMd,
    fontWeight: fontWeightMedium,
    fontFamily: 'Cairo',
    color: textPrimary,
    height: 1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: fontSizeSm,
    fontWeight: fontWeightMedium,
    fontFamily: 'Cairo',
    color: textPrimary,
    height: 1,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: fontSizeXs,
    fontWeight: fontWeightMedium,
    fontFamily: 'Cairo',
    color: textPrimary,
    height: 1,
  );

  // Button Styles
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: textOnPrimary,
    padding: const EdgeInsets.symmetric(horizontal: spacingLg, vertical: spacingMd),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMd),
    ),
    textStyle: labelLarge.copyWith(color: textOnPrimary),
  );

  static ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: primary,
    padding: const EdgeInsets.symmetric(horizontal: spacingLg, vertical: spacingMd),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      side: const BorderSide(color: primary),
    ),
    textStyle: labelLarge.copyWith(color: primary),
  );

  // Input Decoration
  static InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: const BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: const BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: const BorderSide(color: primary),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: const BorderSide(color: error),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: spacingMd,
      vertical: spacingSm,
    ),
  );

  // Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(radiusMd),
    border: Border.all(color: borderColor),
    boxShadow: shadowSm,
  );

  // Bottom Sheet Decoration
  static BoxDecoration bottomSheetDecoration = BoxDecoration(
    color: surface,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(radiusXxl),
      topRight: Radius.circular(radiusXxl),
    ),
    boxShadow: shadowMd,
  );

  // Navigation Bar Decoration
  static BoxDecoration navigationBarDecoration = BoxDecoration(
    color: surface,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(radiusXxl),
      topRight: Radius.circular(radiusXxl),
    ),
    boxShadow: shadowMd,
  );
} 
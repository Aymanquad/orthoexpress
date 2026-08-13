import 'package:flutter/material.dart';

/// Layout breakpoints aligned with Material adaptive guidelines.
class Breakpoints {
  static const double phone = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double maxContentWidth = 1180;
  static const double compactPhone = 360;
  /// Side rail from this width up (tablets); phones use bottom navigation.
  static const double navigationRail = 768;
}

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  bool get isCompactPhone => screenWidth < Breakpoints.compactPhone;

  bool get isPhone => screenWidth < Breakpoints.phone;

  bool get isTablet =>
      screenWidth >= Breakpoints.phone && screenWidth < Breakpoints.desktop;

  bool get isLargeTablet => screenWidth >= Breakpoints.tablet;

  bool get useNavigationRail => screenWidth >= Breakpoints.navigationRail;

  bool get useExtendedRail => screenWidth >= Breakpoints.tablet;

  EdgeInsets get pagePadding {
    final horizontal = isPhone ? (isCompactPhone ? 14.0 : 16.0) : 24.0;
    final vertical = isPhone ? 16.0 : 24.0;
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  double get heroHeight {
    if (isLargeTablet) return 380;
    if (isTablet) return 320;
    if (screenHeight < 640) return 220;
    return 280;
  }

  int get shopGridColumns {
    if (screenWidth < Breakpoints.compactPhone) return 2;
    if (screenWidth < Breakpoints.phone) return 2;
    if (screenWidth < Breakpoints.tablet) return 3;
    if (screenWidth < Breakpoints.desktop) return 4;
    return 4;
  }

  double get shopGridAspectRatio {
    switch (shopGridColumns) {
      case 2:
        return isCompactPhone ? 0.68 : 0.72;
      case 3:
        return 0.76;
      default:
        return 0.8;
    }
  }

  int get listGridColumns {
    if (isPhone) return 1;
    if (screenWidth < Breakpoints.tablet) return 2;
    return 2;
  }
}

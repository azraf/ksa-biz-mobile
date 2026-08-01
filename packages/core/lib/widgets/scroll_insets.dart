import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Bottom inset for a single standard FAB (56px) plus margin.
const double kFabHeight = 56;

/// Bottom inset for an extended FAB (taller label row).
const double kExtendedFabHeight = 48;

/// Extra margin below FAB / above bottom nav.
const double kFabMargin = 16;

/// Default width reserved for a fixed right-side action column (e.g. van stock rail).
const double kVanActionRailWidth = 132;

/// Scroll padding to keep list content clear of FABs and/or shell bottom navigation.
EdgeInsets fabScrollPadding(
  BuildContext context, {
  double right = 0,
  bool extendedFab = false,
  int fabCount = 1,
  bool includeBottomNav = false,
}) {
  if (fabCount < 1) {
    fabCount = 0;
  }

  final fabUnit = extendedFab ? kExtendedFabHeight : kFabHeight;
  var bottom = fabCount > 0 ? (fabCount * (fabUnit + AppSpacing.sm)) + kFabMargin : 0.0;

  if (includeBottomNav) {
    bottom += kBottomNavigationBarHeight;
  }

  return EdgeInsets.only(
    right: right,
    bottom: bottom,
  );
}

/// Bottom padding when only the shell [NavigationBar] overlaps the list (no FAB).
EdgeInsets shellBottomPadding(BuildContext context) {
  return fabScrollPadding(context, fabCount: 0, includeBottomNav: true);
}

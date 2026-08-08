import 'package:flutter/material.dart';

/// Per-app brand accent. Every app shares the same v3 design language but
/// gets its own seed so the four roles are instantly distinguishable.
enum AppBrand {
  admin(Color(0xFF4053B4)), // indigo — authority / back office
  sales(Color(0xFF0E7490)), // petrol — field sales
  order(Color(0xFFC2410C)), // burnt orange — customer facing
  monitor(Color(0xFF6D28D9)); // violet — analytics / read-only

  const AppBrand(this.seed);
  final Color seed;
}

/// Fonts live in this package, so families are namespaced with `packages/core/`.
const kFontFamily = 'packages/core/Manrope';
const kFontFallback = <String>[
  'packages/core/NotoSansBengali',
  'packages/core/NotoSansArabic',
];

class AppTheme {
  static ThemeData light([AppBrand brand = AppBrand.admin]) =>
      _build(brand, Brightness.light);

  static ThemeData dark([AppBrand brand = AppBrand.admin]) =>
      _build(brand, Brightness.dark);

  static ThemeData _build(AppBrand brand, Brightness brightness) {
    final cs = ColorScheme.fromSeed(seedColor: brand.seed, brightness: brightness);
    final isDark = brightness == Brightness.dark;

    // Depth without shadows: tinted scaffold, white/elevated cards, hairline borders.
    final scaffold = isDark ? cs.surface : cs.surfaceContainerLow;
    final card = isDark ? cs.surfaceContainerLow : cs.surfaceContainerLowest;
    final hairline = cs.outlineVariant.withValues(alpha: isDark ? 0.45 : 0.7);

    final baseText = ThemeData(brightness: brightness, useMaterial3: true)
        .textTheme
        .apply(
          fontFamily: kFontFamily,
          fontFamilyFallback: kFontFallback,
          bodyColor: cs.onSurface,
          displayColor: cs.onSurface,
        );
    final textTheme = baseText.copyWith(
      displaySmall: baseText.displaySmall!.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
      headlineMedium: baseText.headlineMedium!.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
      headlineSmall: baseText.headlineSmall!.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.25),
      titleLarge: baseText.titleLarge!.copyWith(fontWeight: FontWeight.w700),
      titleMedium: baseText.titleMedium!.copyWith(fontWeight: FontWeight.w600),
      titleSmall: baseText.titleSmall!.copyWith(fontWeight: FontWeight.w600),
      labelLarge: baseText.labelLarge!.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.2),
      bodySmall: baseText.bodySmall!.copyWith(color: cs.onSurfaceVariant),
    );

    const radiusSm = 10.0, radiusMd = 12.0, radiusLg = 16.0, radiusXl = 24.0;
    final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd));
    const buttonSize = Size(64, 48);

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffold,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scaffold,
        foregroundColor: cs.onSurface,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(color: hairline),
        ),
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        elevation: 0,
        backgroundColor: isDark ? cs.surfaceContainer : cs.surfaceContainerLowest,
        indicatorColor: cs.secondaryContainer,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: buttonSize,
          shape: buttonShape,
          elevation: 0,
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          shape: buttonShape,
          side: BorderSide(color: cs.outline),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
        side: BorderSide(color: hairline),
        labelStyle: textTheme.labelMedium,
        backgroundColor: card,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusXl)),
        backgroundColor: isDark ? cs.surfaceContainerHigh : cs.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusXl)),
        ),
        backgroundColor: isDark ? cs.surfaceContainerHigh : cs.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
        insetPadding: const EdgeInsets.all(16),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLg)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: cs.onSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      dividerTheme: DividerThemeData(color: hairline, thickness: 1, space: 1),
      tabBarTheme: TabBarThemeData(
        labelStyle: textTheme.titleSmall,
        unselectedLabelStyle: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: isDark ? cs.surfaceContainer : cs.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMd)),
        surfaceTintColor: Colors.transparent,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSm)),
        ),
      ),
    );
  }
}

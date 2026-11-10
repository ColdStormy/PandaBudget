import 'package:flutter/material.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/theme/spacing.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(_lightScheme, FinanceColors.light);

  static ThemeData get dark => _build(_darkScheme, FinanceColors.dark);

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: PandaColors.bamboo,
    onPrimary: PandaColors.white,
    primaryContainer: PandaColors.bambooPale,
    onPrimaryContainer: PandaColors.bambooDeep,
    secondary: PandaColors.graphite,
    onSecondary: PandaColors.white,
    secondaryContainer: Color(0xFFE9ECE5),
    onSecondaryContainer: PandaColors.ink,
    tertiary: PandaColors.amber,
    onTertiary: PandaColors.white,
    error: PandaColors.clay,
    onError: PandaColors.white,
    errorContainer: Color(0xFFF9DEDA),
    onErrorContainer: Color(0xFF5A1A13),
    surface: PandaColors.rice,
    onSurface: PandaColors.ink,
    onSurfaceVariant: PandaColors.slate,
    surfaceContainerLowest: PandaColors.white,
    surfaceContainerLow: PandaColors.white,
    surfaceContainer: Color(0xFFEFF1EB),
    surfaceContainerHigh: Color(0xFFE9ECE5),
    surfaceContainerHighest: Color(0xFFE2E5DD),
    outline: Color(0xFF8A8F86),
    outlineVariant: PandaColors.mist,
    inverseSurface: PandaColors.ink,
    onInverseSurface: PandaColors.rice,
    inversePrimary: PandaColors.bambooShoot,
    surfaceTint: Colors.transparent,
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: PandaColors.bambooShoot,
    onPrimary: PandaColors.bambooDeep,
    primaryContainer: Color(0xFF2F4A17),
    onPrimaryContainer: PandaColors.bambooPale,
    secondary: Color(0xFFC9CEC6),
    onSecondary: PandaColors.ink,
    secondaryContainer: PandaColors.graphite,
    onSecondaryContainer: Color(0xFFE2E5DD),
    tertiary: PandaColors.amberLight,
    onTertiary: Color(0xFF3A2700),
    error: PandaColors.clayLight,
    onError: Color(0xFF5A1A13),
    errorContainer: Color(0xFF6E2A21),
    onErrorContainer: Color(0xFFF9DEDA),
    surface: PandaColors.ink,
    onSurface: Color(0xFFE8EAE4),
    onSurfaceVariant: Color(0xFFA9AFA6),
    surfaceContainerLowest: Color(0xFF0E100F),
    surfaceContainerLow: PandaColors.charcoal,
    surfaceContainer: Color(0xFF212523),
    surfaceContainerHigh: PandaColors.graphite,
    surfaceContainerHighest: Color(0xFF343836),
    outline: Color(0xFF7D837B),
    outlineVariant: Color(0xFF353A36),
    inverseSurface: Color(0xFFE8EAE4),
    onInverseSurface: PandaColors.ink,
    inversePrimary: PandaColors.bamboo,
    surfaceTint: Colors.transparent,
  );

  static ThemeData _build(ColorScheme scheme, FinanceColors finance) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: VisualDensity.standard,
      extensions: [finance],
    );
    final text = base.textTheme;
    // `textTheme` carries colours and the font family but no sizes; those
    // are merged in per locale when a widget reads the theme. Component
    // themes skip that step, so they get fully specified styles from here.
    final sized = base.typography.englishLike.merge(text);
    const radius = BorderRadius.all(Radius.circular(16));
    final border = BorderSide(color: scheme.outlineVariant);

    return base.copyWith(
      textTheme: text.copyWith(
        headlineMedium: text.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        headlineSmall: text.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        labelLarge: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: sized.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: radius, side: border),
        clipBehavior: Clip.antiAlias,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: Insets.md),
        iconColor: scheme.onSurfaceVariant,
        subtitleTextStyle: sized.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        indicatorColor: scheme.primaryContainer,
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => sized.labelMedium?.copyWith(
            letterSpacing: 0,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? scheme.onSurface
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        indicatorColor: scheme.primaryContainer,
        selectedIconTheme: IconThemeData(color: scheme.onPrimaryContainer),
        unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        selectedLabelTextStyle: sized.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
        unselectedLabelTextStyle: sized.labelMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Insets.md,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: border,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: border,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
          shape: const StadiumBorder(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
          side: border,
          shape: const StadiumBorder(),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 1,
        highlightElevation: 2,
      ),
      chipTheme: ChipThemeData(
        side: border,
        backgroundColor: scheme.surfaceContainerLow,
        selectedColor: scheme.primaryContainer,
        shape: const StadiumBorder(),
        labelStyle: sized.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: scheme.onSurface,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          side: border,
          foregroundColor: scheme.onSurfaceVariant,
          selectedBackgroundColor: scheme.primaryContainer,
          selectedForegroundColor: scheme.onPrimaryContainer,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.onSurface,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: scheme.outlineVariant,
        labelStyle: sized.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: sized.titleSmall,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        linearMinHeight: 8,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        showDragHandle: true,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pandabudget/core/theme/app_text.dart';
import 'package:pandabudget/core/theme/panda_colors.dart';
import 'package:pandabudget/core/theme/spacing.dart';

/// The Bamboo design system as Material themes: flat surfaces without
/// borders, underline fields, text toggles instead of outlined chips, and
/// bamboo green for everything interactive.
abstract final class AppTheme {
  static ThemeData get light => _build(_lightScheme, FinanceColors.light);

  static ThemeData get dark => _build(_darkScheme, FinanceColors.dark);

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: PandaColors.bamboo,
    onPrimary: PandaColors.white,
    primaryContainer: PandaColors.bambooPale,
    onPrimaryContainer: PandaColors.bamboo,
    secondary: PandaColors.slate,
    onSecondary: PandaColors.white,
    secondaryContainer: PandaColors.sunk,
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
    surfaceContainer: PandaColors.sunk,
    surfaceContainerHigh: PandaColors.sunk,
    surfaceContainerHighest: PandaColors.mist,
    outline: PandaColors.stone,
    outlineVariant: PandaColors.mist,
    inverseSurface: PandaColors.ink,
    onInverseSurface: PandaColors.rice,
    inversePrimary: PandaColors.bambooShoot,
    surfaceTint: Colors.transparent,
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: PandaColors.bambooShoot,
    onPrimary: PandaColors.night,
    primaryContainer: PandaColors.bambooNight,
    onPrimaryContainer: PandaColors.bambooShoot,
    secondary: PandaColors.nightSlate,
    onSecondary: PandaColors.night,
    secondaryContainer: PandaColors.nightSunk,
    onSecondaryContainer: PandaColors.nightInk,
    tertiary: PandaColors.amberLight,
    onTertiary: Color(0xFF3A2700),
    error: PandaColors.clayLight,
    onError: Color(0xFF5A1A13),
    errorContainer: Color(0xFF6E2A21),
    onErrorContainer: Color(0xFFF9DEDA),
    surface: PandaColors.night,
    onSurface: PandaColors.nightInk,
    onSurfaceVariant: PandaColors.nightSlate,
    surfaceContainerLowest: PandaColors.night,
    surfaceContainerLow: PandaColors.nightCard,
    surfaceContainer: PandaColors.nightSunk,
    surfaceContainerHigh: PandaColors.nightSunk,
    surfaceContainerHighest: PandaColors.nightLine,
    outline: PandaColors.nightStone,
    outlineVariant: PandaColors.nightLine,
    inverseSurface: PandaColors.nightInk,
    onInverseSurface: PandaColors.night,
    inversePrimary: PandaColors.bamboo,
    surfaceTint: Colors.transparent,
  );

  static ThemeData _build(ColorScheme scheme, FinanceColors finance) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      visualDensity: VisualDensity.standard,
      extensions: [finance],
    );

    // Merging into the base styles keeps the platform's font family.
    TextStyle? style(TextStyle? from, TextStyle scale, Color color) =>
        from?.merge(scale).copyWith(color: color, letterSpacing: 0);
    final t = base.textTheme;
    final ink = scheme.onSurface;
    final muted = scheme.onSurfaceVariant;
    final text = t.copyWith(
      displayLarge: style(t.displayLarge, AppText.display, ink),
      headlineMedium: style(t.headlineMedium, AppText.headline, ink),
      headlineSmall: style(t.headlineSmall, AppText.headline, ink),
      titleLarge: style(t.titleLarge, AppText.title, ink),
      titleMedium: style(t.titleMedium, AppText.section, ink),
      titleSmall: style(t.titleSmall, AppText.control, ink),
      bodyLarge: style(t.bodyLarge, AppText.body, ink),
      bodyMedium: style(t.bodyMedium, AppText.body, ink),
      bodySmall: style(t.bodySmall, AppText.caption, muted),
      labelLarge: style(t.labelLarge, AppText.control, ink),
      labelMedium: style(t.labelMedium, AppText.label, muted),
      labelSmall: style(t.labelSmall, AppText.navLabel, muted),
    );

    // Component styles start from the themed label style so they keep the
    // font family; the raw type scale has none.
    final control = text.labelLarge!;
    final line = BorderSide(color: scheme.outlineVariant);
    const radius = BorderRadius.all(Radius.circular(Radii.lg));
    const smallRadius = BorderRadius.all(Radius.circular(Radii.sm));
    const buttonShape = RoundedRectangleBorder(borderRadius: smallRadius);
    const transparent = Colors.transparent;

    Color navColor(Set<WidgetState> states, Color selected, Color other) =>
        states.contains(WidgetState.selected) ? selected : other;
    UnderlineInputBorder underline(Color color, [double width = 1]) =>
        UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: ink,
        surfaceTintColor: transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLow,
        surfaceTintColor: transparent,
        shape: const RoundedRectangleBorder(borderRadius: radius),
        clipBehavior: Clip.antiAlias,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: Insets.md),
        minVerticalPadding: Insets.sm,
        iconColor: muted,
        subtitleTextStyle: text.bodySmall,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: transparent,
        indicatorColor: transparent,
        elevation: 0,
        height: 64,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) =>
              IconThemeData(color: navColor(states, scheme.primary, muted)),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) =>
              text.labelSmall?.copyWith(color: navColor(states, ink, muted)),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: transparent,
        selectedIconTheme: IconThemeData(color: scheme.primary),
        unselectedIconTheme: IconThemeData(color: muted),
        selectedLabelTextStyle: text.labelSmall?.copyWith(color: ink),
        unselectedLabelTextStyle: text.labelSmall,
      ),
      inputDecorationTheme: InputDecorationThemeData(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: underline(scheme.outline),
        enabledBorder: underline(scheme.outline),
        focusedBorder: underline(scheme.primary, 2),
        errorBorder: underline(scheme.error),
        focusedErrorBorder: underline(scheme.error, 2),
        hintStyle: text.bodyLarge?.copyWith(color: muted),
        labelStyle: text.bodyLarge?.copyWith(color: muted),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(horizontal: Insets.md),
          textStyle: control,
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(horizontal: Insets.md),
          foregroundColor: ink,
          side: BorderSide(color: scheme.outline),
          textStyle: control,
          shape: buttonShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: muted,
          textStyle: control,
          shape: buttonShape,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 1,
        highlightElevation: 2,
      ),
      // Filters are plain text toggles: accent when selected, muted otherwise.
      chipTheme: ChipThemeData(
        side: BorderSide.none,
        backgroundColor: transparent,
        selectedColor: transparent,
        surfaceTintColor: transparent,
        showCheckmark: false,
        elevation: 0,
        pressElevation: 0,
        shape: buttonShape,
        labelStyle: control.copyWith(
          color: WidgetStateColor.resolveWith(
            (states) => navColor(states, scheme.primary, muted),
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          side: line,
          shape: buttonShape,
          textStyle: control,
          foregroundColor: muted,
          selectedBackgroundColor: scheme.primaryContainer,
          selectedForegroundColor: scheme.primary,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => navColor(states, scheme.onPrimary, scheme.outline),
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => navColor(states, scheme.primary, scheme.surfaceContainer),
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => navColor(states, transparent, scheme.outline),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: muted,
        indicatorColor: scheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: scheme.outlineVariant,
        labelStyle: control.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: control,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.outlineVariant,
        linearMinHeight: 4,
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: transparent,
        shape: const RoundedRectangleBorder(borderRadius: radius),
        titleTextStyle: text.titleMedium,
        contentTextStyle: text.bodyLarge,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.lg)),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// The PandaBudget palette (New Bamboo, warm): cream and charcoal as the
/// ground, forest green as the leading colour, lime for growth, gold for
/// goals and gentle attention, and a rare red for real problems.
///
/// Names follow the tokens of the design system. A token that differs
/// between themes has a `dark` counterpart; the others are the same in both.
abstract final class PandaColors {
  // Surfaces.
  static const Color page = Color(0xFFF3F0E7);
  static const Color card = Color(0xFFFCFAF4);
  static const Color sunk = Color(0xFFE8E4D6);
  static const Color pageDark = Color(0xFF181C1A);
  static const Color cardDark = Color(0xFF222823);
  static const Color sunkDark = Color(0xFF2B322D);

  // Text and lines. `ink` is also the panda black of the logo.
  static const Color ink = Color(0xFF292E2B);
  static const Color inkMuted = Color(0xFF5C635E);
  static const Color line = Color(0xFFDDD8C9);
  static const Color controlBorder = Color(0xFF7F857C);
  static const Color inkDark = Color(0xFFF3F0E7);
  static const Color inkMutedDark = Color(0xFFAAB0A7);
  static const Color lineDark = Color(0xFF333A35);
  static const Color controlBorderDark = Color(0xFF6D766F);

  // Accent: forest green in light, lime in dark.
  static const Color accent = Color(0xFF26734D);
  static const Color accentInk = Color(0xFFFFFFFF);
  static const Color accentSoft = Color(0xFFDFEAD5);
  static const Color accentDark = Color(0xFF70B83D);
  static const Color accentInkDark = Color(0xFF17210F);
  static const Color accentSoftDark = Color(0xFF2A3A22);

  // A large coloured area that carries the main message of a screen. The
  // same in both themes.
  static const Color accentDeep = Color(0xFF26734D);
  static const Color accentDeepInk = Color(0xFFF3F0E7);

  // Lime: growth and healthy progress. A fill, never text on light surfaces.
  static const Color lime = Color(0xFF70B83D);
  static const Color limeSoft = Color(0xFFE2F0D2);
  static const Color limeSoftDark = Color(0xFF2A3A22);

  // Gold: goals and gentle attention. A fill, or [goldText] as text.
  static const Color gold = Color(0xFFE9B84E);
  static const Color goldSoft = Color(0xFFF8ECCA);
  static const Color goldSoftDark = Color(0xFF3B3320);
  static const Color goldText = Color(0xFF8A6400);
  static const Color goldTextDark = Color(0xFFE9B84E);

  /// Text and icons on a lime or gold fill, in both themes.
  static const Color inkOnBright = Color(0xFF1F261F);

  // Real problems only: overspent budgets, errors, negative balances.
  static const Color negative = Color(0xFFB8432F);
  static const Color negativeSoft = Color(0xFFF6DCD5);
  static const Color negativeDark = Color(0xFFFF8F7A);
  static const Color negativeSoftDark = Color(0xFF4A2822);

  /// Colours offered for accounts, categories, budgets and goals. Muted so
  /// that charts stay calm next to the accent.
  static const List<int> swatches = [
    0xFF26734D,
    0xFF3F7D3A,
    0xFF89A85A,
    0xFF4F8F8B,
    0xFF5B7C99,
    0xFF7A6FA8,
    0xFFB9739E,
    0xFFC0605A,
    0xFFD08A3C,
    0xFFD9A441,
    0xFF8A8F86,
    0xFF3A3F3B,
  ];
}

/// Colours with a meaning in a finance app, available through
/// `Theme.of(context).extension<FinanceColors>()`.
@immutable
class FinanceColors extends ThemeExtension<FinanceColors> {
  const FinanceColors({
    required this.income,
    required this.expense,
    required this.warning,
  });

  static const light = FinanceColors(
    income: PandaColors.accent,
    expense: PandaColors.negative,
    warning: PandaColors.goldText,
  );

  static const dark = FinanceColors(
    income: PandaColors.accentDark,
    expense: PandaColors.negativeDark,
    warning: PandaColors.goldTextDark,
  );

  final Color income;
  final Color expense;
  final Color warning;

  @override
  FinanceColors copyWith({Color? income, Color? expense, Color? warning}) =>
      FinanceColors(
        income: income ?? this.income,
        expense: expense ?? this.expense,
        warning: warning ?? this.warning,
      );

  @override
  FinanceColors lerp(FinanceColors? other, double t) => other == null
      ? this
      : FinanceColors(
          income: Color.lerp(income, other.income, t)!,
          expense: Color.lerp(expense, other.expense, t)!,
          warning: Color.lerp(warning, other.warning, t)!,
        );
}

extension FinanceColorsContext on BuildContext {
  FinanceColors get financeColors =>
      Theme.of(this).extension<FinanceColors>() ?? FinanceColors.light;
}

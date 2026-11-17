import 'package:flutter/material.dart';

/// The PandaBudget palette (Bamboo design system): panda black and white
/// with bamboo green as the only accent.
abstract final class PandaColors {
  // Light surfaces and text. `ink` is also the panda black of the logo.
  static const Color ink = Color(0xFF111412);
  static const Color slate = Color(0xFF5B645D);
  static const Color mist = Color(0xFFDDE3DC);
  static const Color stone = Color(0xFF8A948C);
  static const Color sunk = Color(0xFFEEF1EC);
  static const Color rice = Color(0xFFF7F8F5);
  static const Color white = Color(0xFFFFFFFF);

  // Dark surfaces and text.
  static const Color night = Color(0xFF0F1210);
  static const Color nightCard = Color(0xFF171B19);
  static const Color nightSunk = Color(0xFF1F2420);
  static const Color nightLine = Color(0xFF2A312C);
  static const Color nightStone = Color(0xFF5E6962);
  static const Color nightInk = Color(0xFFEEF2EE);
  static const Color nightSlate = Color(0xFFA3ADA5);

  // Bamboo.
  static const Color bamboo = Color(0xFF2E7D4F);
  static const Color bambooShoot = Color(0xFF7CC79A);
  static const Color bambooPale = Color(0xFFDCEFE3);
  static const Color bambooNight = Color(0xFF1E3327);

  // Used sparingly for money going out and for warnings.
  static const Color clay = Color(0xFFB42318);
  static const Color clayLight = Color(0xFFFF8A80);
  static const Color amber = Color(0xFFB57A14);
  static const Color amberLight = Color(0xFFE6BE6A);

  /// Colours offered for accounts, categories, budgets and goals. Muted so
  /// that charts stay calm next to the bamboo accent.
  static const List<int> swatches = [
    0xFF2E7D4F,
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
    income: PandaColors.bamboo,
    expense: PandaColors.clay,
    warning: PandaColors.amber,
  );

  static const dark = FinanceColors(
    income: PandaColors.bambooShoot,
    expense: PandaColors.clayLight,
    warning: PandaColors.amberLight,
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

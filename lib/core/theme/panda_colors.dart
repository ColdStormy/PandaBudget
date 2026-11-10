import 'package:flutter/material.dart';

/// The PandaBudget palette: panda black and white with bamboo green as the
/// only accent.
abstract final class PandaColors {
  // Panda black and the greys between it and white.
  static const Color ink = Color(0xFF151716);
  static const Color charcoal = Color(0xFF1C1F1D);
  static const Color graphite = Color(0xFF2A2E2B);
  static const Color slate = Color(0xFF5E645F);
  static const Color mist = Color(0xFFDADDD5);
  static const Color rice = Color(0xFFF5F6F2);
  static const Color white = Color(0xFFFFFFFF);

  // Bamboo.
  static const Color bamboo = Color(0xFF5A8A2B);
  static const Color bambooDeep = Color(0xFF1D3309);
  static const Color bambooShoot = Color(0xFFA8D08C);
  static const Color bambooPale = Color(0xFFE4F0D8);

  // Used sparingly for money going out and for warnings.
  static const Color clay = Color(0xFFB4483C);
  static const Color clayLight = Color(0xFFF0A69C);
  static const Color amber = Color(0xFFB57A14);
  static const Color amberLight = Color(0xFFE6BE6A);

  /// Colours offered for accounts, categories, budgets and goals. Muted so
  /// that charts stay calm next to the bamboo accent.
  static const List<int> swatches = [
    0xFF5A8A2B,
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

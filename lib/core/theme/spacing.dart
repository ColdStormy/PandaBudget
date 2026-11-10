import 'package:flutter/widgets.dart';

/// The spacing scale. Sticking to these steps is what keeps screens airy
/// and aligned.
abstract final class Insets {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Layout breakpoints.
abstract final class Breakpoints {
  /// From this width on the app uses a navigation rail and multi-column
  /// layouts (tablets, desktop windows).
  static const double wide = 840;

  /// Maximum width of page content on very wide windows.
  static const double content = 1120;

  /// Maximum width of forms.
  static const double form = 640;
}

const SizedBox gapXs = SizedBox.square(dimension: Insets.xs);
const SizedBox gapSm = SizedBox.square(dimension: Insets.sm);
const SizedBox gapMd = SizedBox.square(dimension: Insets.md);
const SizedBox gapLg = SizedBox.square(dimension: Insets.lg);
const SizedBox gapXl = SizedBox.square(dimension: Insets.xl);

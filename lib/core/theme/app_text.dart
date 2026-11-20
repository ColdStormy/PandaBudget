import 'package:flutter/painting.dart';

/// The type scale of the Bamboo design system. Colour is not included; the
/// theme applies it.
///
/// Two voices share the work. PT Serif, always bold, gives structure: where
/// am I and what is this about. Figtree carries everything you read, count
/// or tap. Serif is never used for running text, labels or buttons.
abstract final class AppText {
  /// Family names as declared in `pubspec.yaml` (`assets/fonts`).
  static const serifFamily = 'PT Serif';
  static const sansFamily = 'Figtree';

  static const _serifFallback = ['Georgia', 'serif'];
  static const _sansFallback = ['Roboto', 'sans-serif'];

  // Figures line up: lining and tabular wherever the font offers them.
  static const _figures = [
    FontFeature.liningFigures(),
    FontFeature.tabularFigures(),
  ];

  // Structure (PT Serif, bold).

  /// Total balance, the largest number of a screen. 36 / 44, bold.
  static const display = TextStyle(
    fontFamily: serifFamily,
    fontFamilyFallback: _serifFallback,
    fontSize: 36,
    height: 44 / 36,
    fontWeight: FontWeight.w700,
    fontFeatures: _figures,
  );

  /// Key figure of a nested view. 28 / 36, bold.
  static const headline = TextStyle(
    fontFamily: serifFamily,
    fontFamilyFallback: _serifFallback,
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w700,
    fontFeatures: _figures,
  );

  /// Page titles. 24 / 30, bold.
  static const title = TextStyle(
    fontFamily: serifFamily,
    fontFamilyFallback: _serifFallback,
    fontSize: 24,
    height: 30 / 24,
    fontWeight: FontWeight.w700,
  );

  /// Section headings, always under a [rubric]. 20 / 26, bold.
  static const section = TextStyle(
    fontFamily: serifFamily,
    fontFamilyFallback: _serifFallback,
    fontSize: 20,
    height: 26 / 20,
    fontWeight: FontWeight.w700,
  );

  // Text and labels (Figtree).

  /// Small capitals in the accent colour that open a section, above its
  /// heading. 11 / 16, semibold, 0.07 em spacing. Set the text in upper case.
  static const rubric = TextStyle(
    fontFamily: sansFamily,
    fontFamilyFallback: _sansFallback,
    fontSize: 11,
    height: 16 / 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 11 * 0.07,
  );

  /// Balance inside an account card. 18 / 24, semibold.
  static const value = TextStyle(
    fontFamily: sansFamily,
    fontFamilyFallback: _sansFallback,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    fontFeatures: _figures,
  );

  /// Amounts in list rows, right-aligned. 16 / 24, medium.
  static const amount = TextStyle(
    fontFamily: sansFamily,
    fontFamilyFallback: _sansFallback,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w500,
    fontFeatures: _figures,
  );

  /// Row titles and input text. 15 / 22, regular.
  static const body = TextStyle(
    fontFamily: sansFamily,
    fontFamilyFallback: _sansFallback,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w400,
  );

  /// Buttons, chips, checkbox labels. 14 / 20, medium.
  static const control = TextStyle(
    fontFamily: sansFamily,
    fontFamilyFallback: _sansFallback,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
  );

  /// Muted secondary labels. 13 / 18, regular.
  static const label = TextStyle(
    fontFamily: sansFamily,
    fontFamilyFallback: _sansFallback,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
  );

  /// Navigation labels. 12 / 16, medium.
  static const navLabel = TextStyle(
    fontFamily: sansFamily,
    fontFamilyFallback: _sansFallback,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
  );

  /// Subtitles, small captions, timestamps. 12 / 16, regular.
  static const caption = TextStyle(
    fontFamily: sansFamily,
    fontFamilyFallback: _sansFallback,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );
}

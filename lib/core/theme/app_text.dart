import 'package:flutter/material.dart';

/// The type scale of the Bamboo design system. Colour is not included; the
/// theme applies it.
abstract final class AppText {
  static const _tabular = [FontFeature.tabularFigures()];

  /// Total balance. 32 / 40, medium.
  static const display = TextStyle(
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w500,
    fontFeatures: _tabular,
  );

  /// Key figure of a view. 24 / 32, medium.
  static const headline = TextStyle(
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w500,
    fontFeatures: _tabular,
  );

  /// Page titles. 22 / 28, medium.
  static const title = TextStyle(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w500,
  );

  /// Section headings. 16 / 24, semibold.
  static const section = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
  );

  /// Row titles and input text. 15 / 22, regular.
  static const body = TextStyle(
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w400,
  );

  /// Buttons, chips, checkbox labels. 14 / 20, medium.
  static const control = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
  );

  /// Muted secondary labels. 13 / 18, regular.
  static const label = TextStyle(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w400,
  );

  /// Navigation labels. 12 / 16, medium.
  static const navLabel = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
  );

  /// Subtitles, small captions, timestamps. 12 / 16, regular.
  static const caption = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );
}

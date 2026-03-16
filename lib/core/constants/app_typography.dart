import 'package:flutter/material.dart';

abstract final class AppTypography {
  // Font families
  static const String serif = 'NotoSerif';
  static const String sinhala = 'NotoSerifSinhala';

  // Reader font sizes
  static const double fontSizeSmall = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXL = 22.0;

  static const List<double> readerFontSizes = [
    fontSizeSmall,
    fontSizeMedium,
    fontSizeLarge,
    fontSizeXL,
  ];

  static const List<String> readerFontSizeLabels = ['S', 'M', 'L', 'XL'];

  // Line heights
  static const double readerLineHeight = 1.7;
  static const double uiLineHeight = 1.4;

  // Text styles
  static TextStyle readerBody({
    required double fontSize,
    required Color color,
    String fontFamily = serif,
  }) =>
      TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        height: readerLineHeight,
        color: color,
        letterSpacing: 0.1,
      );

  static const TextStyle nikayadisplayTitle = TextStyle(
    fontFamily: serif,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle sectionHeader = TextStyle(
    fontFamily: serif,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );
}

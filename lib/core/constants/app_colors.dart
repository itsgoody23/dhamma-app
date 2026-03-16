import 'package:flutter/material.dart';

/// Dhamma App colour palette — warm neutrals with calm green accent.
abstract final class AppColors {
  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color green = Color(0xFF4A7C59);
  static const Color greenLight = Color(0xFF6A9E79);
  static const Color greenDark = Color(0xFF2F5C3C);

  // ── Neutrals (light mode) ────────────────────────────────────────────────
  static const Color background = Color(0xFFFBF8F3);
  static const Color surface = Color(0xFFF5F0E8);
  static const Color surfaceVariant = Color(0xFFEDE6D6);
  static const Color outline = Color(0xFFCFC8B8);

  // ── Text (light mode) ────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1C1A17);
  static const Color textSecondary = Color(0xFF5C5649);
  static const Color textTertiary = Color(0xFF8C8479);

  // ── Neutrals (dark mode) ────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF1A1814);
  static const Color surfaceDark = Color(0xFF252219);
  static const Color surfaceVariantDark = Color(0xFF302C22);
  static const Color outlineDark = Color(0xFF4A453A);

  // ── Text (dark mode) ────────────────────────────────────────────────────
  static const Color textPrimaryDark = Color(0xFFEDE6D6);
  static const Color textSecondaryDark = Color(0xFFB0A898);
  static const Color textTertiaryDark = Color(0xFF7A7268);

  // ── Highlight colours ───────────────────────────────────────────────────
  static const Color highlightYellow = Color(0xFFFFF176);
  static const Color highlightGreen = Color(0xFFA5D6A7);
  static const Color highlightBlue = Color(0xFF90CAF9);
  static const Color highlightPink = Color(0xFFF48FB1);

  static const List<Color> highlightColors = [
    highlightYellow,
    highlightGreen,
    highlightBlue,
    highlightPink,
  ];

  static const List<String> highlightColorHex = [
    '#FFF176',
    '#A5D6A7',
    '#90CAF9',
    '#F48FB1',
  ];

  // ── Nikaya badge colours ─────────────────────────────────────────────────
  static const Color nikayadn = Color(0xFF8D6E63);
  static const Color nikayamn = Color(0xFF4A7C59);
  static const Color nikayasn = Color(0xFF5C7A9B);
  static const Color nikayaan = Color(0xFF7B6B9B);
  static const Color nikayakn = Color(0xFF9B7B3A);

  static Color nikayaColor(String nikaya) {
    return switch (nikaya.toLowerCase()) {
      'dn' => nikayadn,
      'mn' => nikayamn,
      'sn' => nikayasn,
      'an' => nikayaan,
      'kn' => nikayakn,
      _ => green,
    };
  }
}

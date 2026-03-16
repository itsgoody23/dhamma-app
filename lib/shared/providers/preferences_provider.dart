import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_typography.dart';

part 'preferences_provider.g.dart';

// ── Keys ─────────────────────────────────────────────────────────────────────

abstract final class PrefKeys {
  static const String onboardingComplete = 'onboarding_complete';
  static const String themeMode = 'theme_mode';
  static const String readerFontSize = 'reader_font_size';
  static const String readerLanguage = 'reader_language';
  static const String wifiOnlyDownloads = 'wifi_only_downloads';
  static const String audioOnlyOnMobileData = 'audio_only_mobile_data';
}

// ── Theme mode ────────────────────────────────────────────────────────────────

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    _load();
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(PrefKeys.themeMode) ?? 'system';
    state = switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefKeys.themeMode, mode.name);
  }

  void toggle() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    setThemeMode(next);
  }
}

// ── Reader font size ──────────────────────────────────────────────────────────

@riverpod
class ReaderFontSizeNotifier extends _$ReaderFontSizeNotifier {
  @override
  double build() {
    _load();
    return AppTypography.fontSizeMedium;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getDouble(PrefKeys.readerFontSize) ??
        AppTypography.fontSizeMedium;
  }

  Future<void> setFontSize(double size) async {
    state = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(PrefKeys.readerFontSize, size);
  }

  void increase() {
    const sizes = AppTypography.readerFontSizes;
    final idx = sizes.indexOf(state);
    if (idx < sizes.length - 1) setFontSize(sizes[idx + 1]);
  }

  void decrease() {
    const sizes = AppTypography.readerFontSizes;
    final idx = sizes.indexOf(state);
    if (idx > 0) setFontSize(sizes[idx - 1]);
  }
}

// ── Reader language preference ────────────────────────────────────────────────

@riverpod
class ReaderLanguageNotifier extends _$ReaderLanguageNotifier {
  @override
  String build() {
    _load();
    return 'en';
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(PrefKeys.readerLanguage) ?? 'en';
  }

  Future<void> setLanguage(String lang) async {
    state = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefKeys.readerLanguage, lang);
  }
}

// ── Wi-Fi only downloads ─────────────────────────────────────────────────────

@riverpod
class WifiOnlyNotifier extends _$WifiOnlyNotifier {
  @override
  bool build() {
    _load();
    return true; // Default: Wi-Fi only
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(PrefKeys.wifiOnlyDownloads) ?? true;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefKeys.wifiOnlyDownloads, value);
  }
}

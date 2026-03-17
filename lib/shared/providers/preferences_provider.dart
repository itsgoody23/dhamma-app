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
  static const String wifiOnlySync = 'wifi_only_sync';
  static const String audioOnlyOnMobileData = 'audio_only_mobile_data';
  static const String readerPaginated = 'reader_paginated';
  static const String readerLineSpacing = 'reader_line_spacing';
  static const String appLocale = 'app_locale';
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

// ── Reader paginated mode ────────────────────────────────────────────────────

@riverpod
class ReaderPaginatedNotifier extends _$ReaderPaginatedNotifier {
  @override
  bool build() {
    _load();
    return true; // Default: paginated
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(PrefKeys.readerPaginated) ?? true;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefKeys.readerPaginated, state);
  }
}

// ── Reader line spacing ──────────────────────────────────────────────────────

@riverpod
class ReaderLineSpacingNotifier extends _$ReaderLineSpacingNotifier {
  static const List<double> options = [1.4, 1.7, 2.0];
  static const List<String> labels = ['Compact', 'Normal', 'Relaxed'];

  @override
  double build() {
    _load();
    return 1.7; // Default: normal
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getDouble(PrefKeys.readerLineSpacing) ?? 1.7;
  }

  Future<void> setLineSpacing(double value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(PrefKeys.readerLineSpacing, value);
  }
}

// ── Wi-Fi only sync ──────────────────────────────────────────────────────────

@riverpod
class WifiOnlySyncNotifier extends _$WifiOnlySyncNotifier {
  @override
  bool build() {
    _load();
    return true;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(PrefKeys.wifiOnlySync) ?? true;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefKeys.wifiOnlySync, value);
  }
}

// ── Audio only on mobile data ────────────────────────────────────────────

@riverpod
class AudioMobileDataNotifier extends _$AudioMobileDataNotifier {
  @override
  bool build() {
    _load();
    return false; // Default: stream audio on any connection
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(PrefKeys.audioOnlyOnMobileData) ?? false;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefKeys.audioOnlyOnMobileData, value);
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

// ── App locale (UI language) ─────────────────────────────────────────────────

@riverpod
class AppLocaleNotifier extends _$AppLocaleNotifier {
  @override
  Locale? build() {
    _load();
    return null; // null = follow system
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(PrefKeys.appLocale);
    if (code != null) {
      state = Locale(code);
    }
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(PrefKeys.appLocale);
    } else {
      await prefs.setString(PrefKeys.appLocale, locale.languageCode);
    }
  }
}

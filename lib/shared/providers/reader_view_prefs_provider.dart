import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Font family options ───────────────────────────────────────────────────────

abstract final class ReaderFontFamily {
  static const String serif = 'NotoSerif';
  static const String palatino = 'Palatino';
  static const String sans = 'NotoSans';

  static const List<(String id, String label)> options = [
    (serif, 'Serif'),
    (palatino, 'Palatino'),
    (sans, 'Sans'),
  ];
}

// ── Margin options ────────────────────────────────────────────────────────────

abstract final class ReaderMargin {
  static const String narrow = 'narrow';
  static const String normal = 'normal';
  static const String wide = 'wide';

  static const Map<String, double> horizontalPadding = {
    narrow: 12.0,
    normal: 20.0,
    wide: 48.0,
  };
}

// ── Smart selection mode ──────────────────────────────────────────────────────

abstract final class SmartSelectionMode {
  static const String word = 'word';
  static const String phrase = 'phrase';
  static const String sentence = 'sentence';
  static const String paragraph = 'paragraph';
}

// ── Font family notifier ──────────────────────────────────────────────────────

final readerFontFamilyProvider =
    NotifierProvider<ReaderFontFamilyNotifier, String>(
  ReaderFontFamilyNotifier.new,
);

class ReaderFontFamilyNotifier extends Notifier<String> {
  static const _key = 'reader_font_family';

  @override
  String build() {
    _load();
    return ReaderFontFamily.serif;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_key) ?? ReaderFontFamily.serif;
  }

  Future<void> set(String fontFamily) async {
    state = fontFamily;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, fontFamily);
  }
}

// ── Text color notifier ───────────────────────────────────────────────────────

final readerTextColorProvider =
    NotifierProvider<ReaderTextColorNotifier, String>(
  ReaderTextColorNotifier.new,
);

/// Stores a hex string like '#5C4A2A'. Empty string means use theme default.
class ReaderTextColorNotifier extends Notifier<String> {
  static const _key = 'reader_text_color';
  static const String auto = '';

  @override
  String build() {
    _load();
    return auto;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_key) ?? auto;
  }

  Future<void> set(String colorHex) async {
    state = colorHex;
    final prefs = await SharedPreferences.getInstance();
    if (colorHex.isEmpty) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, colorHex);
    }
  }
}

// ── Margin notifier ───────────────────────────────────────────────────────────

final readerMarginProvider =
    NotifierProvider<ReaderMarginNotifier, String>(
  ReaderMarginNotifier.new,
);

class ReaderMarginNotifier extends Notifier<String> {
  static const _key = 'reader_margin';

  @override
  String build() {
    _load();
    return ReaderMargin.normal;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_key) ?? ReaderMargin.normal;
  }

  Future<void> set(String margin) async {
    state = margin;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, margin);
  }
}

// ── Background color notifier ─────────────────────────────────────────────────

final readerBgColorProvider =
    NotifierProvider<ReaderBgColorNotifier, String>(
  ReaderBgColorNotifier.new,
);

/// Stores a hex string like '#FAF3E0'. Empty string means use theme default.
class ReaderBgColorNotifier extends Notifier<String> {
  static const _key = 'reader_bg_color';
  static const String auto = '';

  @override
  String build() {
    _load();
    return auto;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_key) ?? auto;
  }

  Future<void> set(String colorHex) async {
    state = colorHex;
    final prefs = await SharedPreferences.getInstance();
    if (colorHex.isEmpty) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, colorHex);
    }
  }
}

// ── Smart selection mode notifier ─────────────────────────────────────────────

final readerSmartSelectionModeProvider =
    NotifierProvider<ReaderSmartSelectionModeNotifier, String>(
  ReaderSmartSelectionModeNotifier.new,
);

class ReaderSmartSelectionModeNotifier extends Notifier<String> {
  static const _key = 'reader_smart_selection_mode';

  @override
  String build() {
    _load();
    return SmartSelectionMode.phrase;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_key) ?? SmartSelectionMode.phrase;
  }

  Future<void> set(String mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode);
  }
}

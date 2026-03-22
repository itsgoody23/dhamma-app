import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── UID abbreviation utility ──────────────────────────────────────────────────

/// Converts a sutta UID to an abbreviated display title.
/// e.g. "dn1" → "DN 1", "mn36" → "MN 36", "sn12.23" → "SN 12.23"
String uidToAbbrev(String uid) {
  final match =
      RegExp(r'^([a-z]+)(\d[\d.]*)').firstMatch(uid.toLowerCase());
  if (match == null) return uid.toUpperCase();
  return '${match.group(1)!.toUpperCase()} ${match.group(2)!}';
}

// ── Model ─────────────────────────────────────────────────────────────────────

class SuttaTab {
  const SuttaTab({
    required this.uid,
    required this.abbrev,
    this.scrollPosition = 0,
  });

  final String uid;

  /// Always the abbreviated form e.g. "DN 1" — not user-configurable.
  final String abbrev;
  final int scrollPosition;

  SuttaTab copyWith({int? scrollPosition}) => SuttaTab(
        uid: uid,
        abbrev: abbrev,
        scrollPosition: scrollPosition ?? this.scrollPosition,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'scrollPosition': scrollPosition,
      };

  factory SuttaTab.fromJson(Map<String, dynamic> json) => SuttaTab(
        uid: json['uid'] as String,
        abbrev: uidToAbbrev(json['uid'] as String),
        scrollPosition: (json['scrollPosition'] as num?)?.toInt() ?? 0,
      );
}

class TabsState {
  const TabsState({this.tabs = const [], this.activeUid});

  final List<SuttaTab> tabs;
  final String? activeUid;

  SuttaTab? get activeTab {
    if (tabs.isEmpty) return null;
    return tabs.firstWhere(
      (t) => t.uid == activeUid,
      orElse: () => tabs.first,
    );
  }

  TabsState copyWith({List<SuttaTab>? tabs, String? activeUid}) => TabsState(
        tabs: tabs ?? this.tabs,
        activeUid: activeUid ?? this.activeUid,
      );
}

// ── Provider ──────────────────────────────────────────────────────────────────

final tabsProvider =
    NotifierProvider<TabsNotifier, TabsState>(TabsNotifier.new);

class TabsNotifier extends Notifier<TabsState> {
  static const _tabsKey = 'tabs_open_v2';
  static const _activeKey = 'tabs_active_v2';

  @override
  TabsState build() {
    _load();
    return const TabsState();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_tabsKey);
    final activeUid = prefs.getString(_activeKey);
    if (raw == null) return;
    try {
      final list = (jsonDecode(raw) as List)
          .map((e) => SuttaTab.fromJson(e as Map<String, dynamic>))
          .toList();
      state = TabsState(
        tabs: list,
        activeUid: activeUid ?? (list.isEmpty ? null : list.first.uid),
      );
    } catch (_) {
      // malformed prefs — start fresh
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _tabsKey,
      jsonEncode(state.tabs.map((t) => t.toJson()).toList()),
    );
    if (state.activeUid != null) {
      await prefs.setString(_activeKey, state.activeUid!);
    } else {
      await prefs.remove(_activeKey);
    }
  }

  /// Opens a tab for [uid]. If already open, just activates it.
  void openTab(String uid) {
    final tabs = List<SuttaTab>.from(state.tabs);
    if (tabs.any((t) => t.uid == uid)) {
      state = state.copyWith(activeUid: uid);
    } else {
      tabs.add(SuttaTab(uid: uid, abbrev: uidToAbbrev(uid)));
      state = TabsState(tabs: tabs, activeUid: uid);
    }
    _persist();
  }

  void closeTab(String uid) {
    final tabs = List<SuttaTab>.from(state.tabs)
      ..removeWhere((t) => t.uid == uid);
    String? newActive = state.activeUid;
    if (state.activeUid == uid) {
      newActive = tabs.isEmpty ? null : tabs.last.uid;
    }
    state = TabsState(tabs: tabs, activeUid: newActive);
    _persist();
  }

  void setActive(String uid) {
    state = state.copyWith(activeUid: uid);
    _persist();
  }

  void nextTab() {
    if (state.tabs.isEmpty) return;
    final idx = state.tabs.indexWhere((t) => t.uid == state.activeUid);
    final next = (idx + 1) % state.tabs.length;
    setActive(state.tabs[next].uid);
  }

  void prevTab() {
    if (state.tabs.isEmpty) return;
    final idx = state.tabs.indexWhere((t) => t.uid == state.activeUid);
    final prev = (idx - 1 + state.tabs.length) % state.tabs.length;
    setActive(state.tabs[prev].uid);
  }

  /// Replaces [oldUid] tab with [newUid] in-place (used for Next/Prev sutta navigation
  /// so sequential browsing doesn't accumulate new tabs).
  void replaceTab(String oldUid, String newUid) {
    final tabs = state.tabs.map((t) {
      if (t.uid == oldUid) {
        return SuttaTab(uid: newUid, abbrev: uidToAbbrev(newUid));
      }
      return t;
    }).toList();
    state = TabsState(tabs: tabs, activeUid: newUid);
    _persist();
  }
}

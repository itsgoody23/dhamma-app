import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/notification_service.dart';

part 'notification_provider.g.dart';

// ── Daily reminder enabled ──────────────────────────────────────────────────

@riverpod
class DailyReminderEnabledNotifier extends _$DailyReminderEnabledNotifier {
  static const _key = 'daily_reminder_enabled';

  @override
  bool build() {
    _load();
    return false;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? false;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);

    if (value) {
      final time = ref.read(dailyReminderTimeProvider);
      await NotificationService.instance.requestPermission();
      await NotificationService.instance.scheduleDailyReminder(
        hour: time.hour,
        minute: time.minute,
        title: 'Daily Sutta',
        body: 'Your daily reading is waiting for you',
      );
    } else {
      await NotificationService.instance.cancelDailyReminder();
    }
  }
}

// ── Daily reminder time ─────────────────────────────────────────────────────

@riverpod
class DailyReminderTimeNotifier extends _$DailyReminderTimeNotifier {
  static const _hourKey = 'daily_reminder_hour';
  static const _minuteKey = 'daily_reminder_minute';

  @override
  TimeOfDay build() {
    _load();
    return const TimeOfDay(hour: 8, minute: 0); // default 8:00 AM
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final h = prefs.getInt(_hourKey);
    final m = prefs.getInt(_minuteKey);
    if (h != null) {
      state = TimeOfDay(hour: h, minute: m ?? 0);
    }
  }

  Future<void> setTime(TimeOfDay time) async {
    state = time;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hourKey, time.hour);
    await prefs.setInt(_minuteKey, time.minute);

    // Reschedule if enabled
    final enabled = ref.read(dailyReminderEnabledProvider);
    if (enabled) {
      await NotificationService.instance.scheduleDailyReminder(
        hour: time.hour,
        minute: time.minute,
        title: 'Daily Sutta',
        body: 'Your daily reading is waiting for you',
      );
    }
  }
}

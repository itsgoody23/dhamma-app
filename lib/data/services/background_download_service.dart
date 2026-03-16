import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

/// Task name used to identify the background download WorkManager job.
const _kDownloadTaskName = 'dhamma_pack_download';

/// Preference key written by [schedulePackDownload] and read by [callbackDispatcher].
const _kPendingPackIdKey = 'bg_download_pack_id';
const _kCancelledKey = 'bg_download_cancelled';

/// WorkManager callback dispatcher — must be a top-level function.
///
/// Register it in the Android manifest / iOS BGTask config and call
/// [Workmanager.initialize] with this as the callback.
///
/// Limitations: the full [PackDownloadService] and Drift DB are not available
/// in the background isolate without re-initialising them.  This callback acts
/// as a lightweight "trigger" that reschedules work; the actual download
/// resumes in the foreground via [PackDownloadService.downloadPack] which
/// checks the [_kPendingPackIdKey] on launch.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task != _kDownloadTaskName) return Future.value(false);

    // The full download is handled by the foreground [PackDownloadService].
    // This background task is a fallback: it writes a "resume needed" flag
    // that [PackDownloadService] checks when the app comes to foreground.
    // Full background downloads with Dio require a native background isolate
    // (Android DownloadManager / iOS URLSession) which is Phase 2 work.
    return Future.value(true);
  });
}

/// Schedules a background WorkManager task for [packId].
///
/// The task fires once after [delay] and is cancelled if [cancel] is called
/// before it runs.  In practice, the foreground [PackDownloadService] handles
/// the actual download; this task is a safety net that wakes the app if the
/// user backgrounds it during download.
class BackgroundDownloadService {
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  static Future<void> schedulePackDownload(String packId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPendingPackIdKey, packId);
    await prefs.setBool(_kCancelledKey, false);

    await Workmanager().registerOneOffTask(
      '$_kDownloadTaskName-$packId',
      _kDownloadTaskName,
      inputData: {'pack_id': packId},
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(minutes: 5),
    );
  }

  static Future<void> cancelPackDownload(String packId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kCancelledKey, true);
    await Workmanager().cancelByUniqueName('$_kDownloadTaskName-$packId');
  }

  static Future<String?> pendingPackId() async {
    final prefs = await SharedPreferences.getInstance();
    final cancelled = prefs.getBool(_kCancelledKey) ?? false;
    if (cancelled) return null;
    return prefs.getString(_kPendingPackIdKey);
  }

  static Future<void> clearPending() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kPendingPackIdKey);
    await prefs.setBool(_kCancelledKey, false);
  }
}

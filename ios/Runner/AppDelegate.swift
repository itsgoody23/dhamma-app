import UIKit
import Flutter
import workmanager

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register WorkManager BGTask identifier for one-off pack downloads.
    // Must match the identifier in Info.plist BGTaskSchedulerPermittedIdentifiers
    // and the task name used in BackgroundDownloadService.
    WorkmanagerPlugin.registerTask(withIdentifier: "dhamma_pack_download")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

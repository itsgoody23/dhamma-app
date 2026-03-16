import UIKit
import Flutter
import workmanager

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register WorkManager BGTask identifiers.
    // These must match the identifiers in Info.plist BGTaskSchedulerPermittedIdentifiers
    // and the task names used in BackgroundDownloadService.
    WorkmanagerPlugin.registerTask(withIdentifier: "dhamma_pack_download")
    WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "dhamma_pack_download", frequency: nil)

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

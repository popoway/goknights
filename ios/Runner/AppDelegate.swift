import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    window?.tintColor = UIColor(red: 231/255, green: 25/255, blue: 57/255, alpha: 1) // #E71939
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

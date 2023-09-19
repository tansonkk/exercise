import UIKit
import Flutter
import GoogleMaps 

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
        // TODO: Add your Google Maps API key
    GMSServices.provideAPIKey("AIzaSyBJ63O8ETKwJCc3zVtdDzQ-vdjW4KcntTU")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
}

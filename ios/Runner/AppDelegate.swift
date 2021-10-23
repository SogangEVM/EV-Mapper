import UIKit
import Flutter
//import TMapSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let tmapChannel = FlutterMethodChannel(name: "samples.flutter.dev/tmapInvoke",
                                                    binaryMessenger: controller.binaryMessenger)
      tmapChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      })
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

//private func invokeTmap(result: FlutterResult) {
//    var mapView = TMapView(frame: frame);
//    self.view.addSubview(mapView);
//    mapView.setAppKey("l7xxb841ff64eae6428a8b2ee688cd8abb94");
//    TMapApi.invokeRoute("신도림역", coordinate:mapView.getCenter());
//}

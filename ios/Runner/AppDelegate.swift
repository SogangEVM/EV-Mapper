import UIKit
import Flutter
import TMapSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, TMapTapiDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let tmapChannel = FlutterMethodChannel(name: "samples.flutter.dev/tmapInvoke",
                                                    binaryMessenger: controller.binaryMessenger)
      tmapChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          guard call.method == "tmapInvoke" else {
              result(FlutterMethodNotImplemented)
              return
          }
          //call.arguments[@"lat"]
          self.invokeTmap(result: result)
      })
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


    private func invokeTmap(result: FlutterResult) {
        let latlng  = CLLocationCoordinate2D(latitude: 37.558175, longitude: 126.925989)
        TMapApi.setSKTMapAuthenticationWithDelegate(self, apiKey: "l7xxb841ff64eae6428a8b2ee688cd8abb94")
        TMapApi.invokeRoute("시청역", coordinate: latlng)
    }
}


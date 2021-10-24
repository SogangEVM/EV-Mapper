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
      let tmapChannel = FlutterMethodChannel(name: "electric_vehicle_mapper/tmapInvoke",
                                                    binaryMessenger: controller.binaryMessenger)
      TMapApi.setSKTMapAuthenticationWithDelegate(self, apiKey: "l7xxb841ff64eae6428a8b2ee688cd8abb94")
      tmapChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          guard call.method == "tmapInvoke" else {
              result(FlutterMethodNotImplemented)
              return
          }
          guard let args = call.arguments as? [String : Any] else {return}
          let destination = args["destination"] as! String
          let lat = Double(args["lat"] as! String)!
          let lng = Double(args["lng"] as! String)!
          self.invokeTmap(result: result,destination: destination, lat: lat, lng: lng)
      })
      
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


    private func invokeTmap(result: FlutterResult, destination: String, lat: Double, lng: Double) {
        let installed = TMapApi.isTmapApplicationInstalled()
        let latlng  = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        if(!installed) {
            result(false)
        }
        else {
            TMapApi.invokeRoute(destination, coordinate: latlng)
            result(true)
        }
    }
}


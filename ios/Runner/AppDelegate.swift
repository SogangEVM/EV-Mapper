import UIKit
import Flutter
import TMapSDK
import KakaoSDKCommon
import KakaoSDKNavi

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, TMapTapiDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let tmapChannel = FlutterMethodChannel(name: "electric_vehicle_mapper/tmapChannel",
                                                    binaryMessenger: controller.binaryMessenger)
      let kakaoNaviChannel = FlutterMethodChannel(name: "electric_vehicle_mapper/kakaonaviChannel",
                                                    binaryMessenger: controller.binaryMessenger)
      TMapApi.setSKTMapAuthenticationWithDelegate(self, apiKey: "l7xxb841ff64eae6428a8b2ee688cd8abb94")
      KakaoSDKCommon.initSDK(appKey: "4b9a4abdfc5d02f9b075402afb3d754e")
      
      tmapChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          guard call.method == "invokeTmap" else {
              result(FlutterMethodNotImplemented)
              return
          }
          guard let args = call.arguments as? [String : Any] else {return}
          let destination = args["destination"] as! String
          let lat = Double(args["lat"] as! String)!
          let lng = Double(args["lng"] as! String)!
          self.invokeTmap(result: result,destination: destination, lat: lat, lng: lng)
      })
      
      kakaoNaviChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          guard call.method == "invokeKakaonavi" else {
              result(FlutterMethodNotImplemented)
              return
          }
          guard let args = call.arguments as? [String : Any] else {return}
          let destination = args["destination"] as! String
          let startLat = args["startLat"] as! String
          let startLng = args["startLng"] as! String
          let destLat = args["destLat"] as! String
          let destLng = args["destLng"] as! String
          self.invokeKakaonavi(result: result, destination: destination, startLat: startLat, startLng: startLng, destLat: destLat, destLng: destLng)
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
    
    private func invokeKakaonavi(result: FlutterResult, destination: String, startLat: String, startLng: String, destLat: String, destLng: String) {
        let option = NaviOption(coordType: CoordType.WGS84, vehicleType: VehicleType.First ,rpOption: RpOption.Fast, routeInfo: true, startX: startLng, startY: startLat, startAngle: 0, returnUri: URL(string: ""))
        let destinationLocation = NaviLocation(name: destination, x: destLng, y: destLat)
        guard let navigateUrl = NaviApi.shared.navigateUrl(destination: destinationLocation, option: option) else {
            return
        }
        let installed = UIApplication.shared.canOpenURL(navigateUrl)
        if(!installed) {
            result(false)
        }
        else {
            UIApplication.shared.open(navigateUrl,options: [:], completionHandler: nil)
            result(true)
        }
        
    }
}


import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "com.example.bloc_widget/sendWeatherState",
                                         binaryMessenger: controller.binaryMessenger)
      
      channel.setMethodCallHandler{ [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
          // This method is invoked on the UI thread.
          guard call.method == "sendWeatherState" else {
              result(FlutterMethodNotImplemented)
              return
          }
          
          guard let args = call.arguments as? [String: Any],
                let weatherState = args["weatherState"] as? [String: Any]
          else {
              result(FlutterError(code: "INVALID_ARGUMENT", message: "weatherState decoding 실패", details: nil))
              return
          }
          
          do {
              guard let locationAddressString = weatherState["locationAddress"] as? String,
                    let weatherString = weatherState["weather"] as? String,
                    let lat = weatherState["lat"] as? Double,
                    let lng = weatherState["lng"] as? Double
              else {
                  result(FlutterError(code: "INVALID_ARGUMENT", message: "weatherState jsonObject 실패", details: nil))
                  return
              }
              
              // locationAddress 디코딩
              let locationAddressData = Data(locationAddressString.utf8)
              let locationAddressEntity = try JSONDecoder().decode(LocationAddressEntity.self, from: locationAddressData)
              let locationAddress = LocationAddress.fromEntity(entity: locationAddressEntity, lat: lat, lng: lng)
              
              // weather 디코딩
              let weatherData = Data(weatherString.utf8)
              let weatherEntity = try JSONDecoder().decode(WeatherEntity.self, from: weatherData)
              let weather = Weather.fromEntity(entity: weatherEntity)
              
              
              
              result("Success")
          } catch {
              result(FlutterError(code: "JSON_DECODE_ERROR", message: "디코딩 실패", details: error.localizedDescription))
          }
      }
      
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

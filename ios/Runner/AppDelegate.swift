import UIKit
import AVFAudio
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      initChanel()
      GeneratedPluginRegistrant.register(with: self)
      
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
      
      // Get the singleton instance.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // Set the audio session category, mode, and options.
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
        } catch {
            print("Failed to set audio session category.")
        }
      
      do {
          if #available(iOS 10.0, *){
              try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
              try AVAudioSession.sharedInstance().setActive(true)
          }
      } catch {
          print(error)
      }
//      let bundle = Bundle.main

//      let url = bundle.path(forResource: "a1_1", ofType: "mp3" )
//      print(url)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func initChanel()
    {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

                let channel = FlutterMethodChannel(name: "klib.flutter.dev/native",
                                                          binaryMessenger: controller.binaryMessenger)
                
                channel.setMethodCallHandler({
                    [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
                    // Note: this method is invoked on the UI thread.
                    if call.method == "getFilePath" {
                        guard let args = call.arguments as? [String : Any] else {return}
                        let fileName = args["fileName"] as! String

                          self?.getFilePath(_fileName: fileName, result: result)
                    }
                    else {
                        result(FlutterError(code: "UNAVAILABLE",
                                            message: "invalid method name.",
                                            details: nil))
                    }
                })
    }
    
    
    private func getFilePath(_fileName:String ,result: FlutterResult) {

             let bundle = Bundle.main

     let url = bundle.path(forResource: _fileName, ofType: "" )
result(url)

        //    let device = UIDevice.current
        //    device.isBatteryMonitoringEnabled = true
        //    if device.batteryState == UIDevice.BatteryState.unknown {
        //        result(FlutterError(code: "UNAVAILABLE",
        //                            message: "Battery info unavailable",
        //                            details: nil))
        //    } else {
        //        result(Int(device.batteryLevel * 100))
        //    }
       }
    
    
 
       
   
}

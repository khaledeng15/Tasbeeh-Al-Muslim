import UIKit
import AVFAudio
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
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
      let bundle = Bundle.main

      let url = bundle.path(forResource: "a1_1", ofType: "mp3" )
      print(url)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

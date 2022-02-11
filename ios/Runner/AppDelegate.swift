import UIKit
import Flutter
import GoogleMaps
import UserNotifications
import Firebase
import background_locator


func registerPlugins(registry: FlutterPluginRegistry) -> () {
    if (!registry.hasPlugin("BackgroundLocatorPlugin")) {
        GeneratedPluginRegistrant.register(with: registry)
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self
      } else {
          // Fallback on earlier versions
      }
    GeneratedPluginRegistrant.register(with: self)
    BackgroundLocatorPlugin.setPluginRegistrantCallback(registerPlugins)
//    registerOtherPlugins()

    GMSServices.provideAPIKey("AIzaSyA1fCASJErNUjWPPhCrXofo9WRgFNy8f5Q")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
//    func registerOtherPlugins() {
//           if !hasPlugin("io.flutter.plugins.pathprovider") {
//               FLTPathProviderPlugin
//                   .register(with: registrar(forPlugin: "io.flutter.plugins.pathprovider"))
//           }
//       }
    
    @available(iOS 10.0, *)
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent     notification: UNNotification, withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions) -> Void) {
//        print("Push notification received in foreground.")
//        let userInfo = notification.request.content.userInfo
//
//              // Get aps object
//              let aps = userInfo["aps"] as! [String : Any]
//              // Do your stuff here
//
//        print(aps)
        
        completionHandler([.alert, .sound, .badge])
    }


     
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().delegate = self
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
       Messaging.messaging().apnsToken = deviceToken
       super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
     }
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
    }
    
    
}



import UIKit
import AppsFlyerLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , AppsFlyerTrackerDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        AppsFlyerTracker.shared().appsFlyerDevKey = "K2aMGPY3SkC9WckYUgHJ99"
        AppsFlyerTracker.shared().appleAppID = "123488888"
        
        AppsFlyerTracker.shared().delegate = self
        
        /* Set isDebud to true to see AppsFlyer debug logs */
        AppsFlyerTracker.shared().isDebug = true
        
        
        
        /* Register for Push Notification - used for uninstall tracking */
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
        

        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        /* Call trackAppLaunch to start tracking */
        AppsFlyerTracker.shared().trackAppLaunch()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    /* Conversion data is retrned on first launch, cached, then it returns the same data on every launch */
    func onConversionDataReceived(_ installData: [AnyHashable : Any]!) {
        if let data = installData{
            print("\(data)")
            if let status = data["af_status"] as? String{
                if(status == "Non-organic"){
                    if let sourceID = data["media_source"] , let campaign = data["campaign"]{
                        print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                    }
                } else {
                    print("This is an organic install.")
                }
            }
            
            if let is_first_launch = data["is_first_launch"] , let launch_code = is_first_launch as? Int {
                if(launch_code == 1){
                    print("First Launch")
                } else {
                    print("Not First Launch")
                }
            }
        }
    }
    
    func onConversionDataRequestFailure(_ error: Error!) {
    }
    
    /* onAppOpenAttribution is called only when a deep link is opened */
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]!) {
        if let data = attributionData {
            if let link = data["link"]{
                print("link:  \(link)")
            }
        }
    }
    
    func onAppOpenAttributionFailure(_ error: Error!) {
    }
    
    // Reports app open from a Universal Link for iOS 9 or later
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        AppsFlyerTracker.shared().continue(userActivity, restorationHandler: restorationHandler)
        return true
    }
    
    // Reports app open from deep link from apps which do not support Universal Links (Twitter) and for iOS8 and below
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        AppsFlyerTracker.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        return true
    }
    
    // Reports app open from deep link for iOS 10 or later
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        AppsFlyerTracker.shared().handleOpen(url, options: options)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /* Send device token to AppsFlyer servers for uninstall tracking */
        AppsFlyerTracker.shared().registerUninstall(deviceToken)
    }
    
    
    /* Track Push notification */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        AppsFlyerTracker.shared().handlePushNotification(userInfo)
    }
  
    
}

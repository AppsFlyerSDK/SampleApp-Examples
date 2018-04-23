//
//  AppDelegate.swift
//  AppsFlyerIAPSwift
//
//  Created by Jonathan Wesfield on 22/04/2018.
//  Copyright © 2018 AppsFlyer. All rights reserved.
//

import UIKit
import AppsFlyerLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , AppsFlyerTrackerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        
        AppsFlyerTracker.shared().appsFlyerDevKey = "<DEV_KEY>"
        AppsFlyerTracker.shared().appleAppID = "<APP_ID>"
        AppsFlyerTracker.shared().delegate = self
        
        AppsFlyerTracker.shared().isDebug = true
        AppsFlyerTracker.shared().useReceiptValidationSandbox = true
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerTracker.shared().trackAppLaunch()
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}


//
//  AppDelegate.swift
//  SegmentSwiftSampleApp
//
//  Created by Jonathan Wesfield on 03/05/2018.
//  Copyright © 2018 AppsFlyer. All rights reserved.
//

import UIKit
import Analytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , SEGAppsFlyerTrackerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let config:Analytics.SEGAnalyticsConfiguration = SEGAnalyticsConfiguration(writeKey: "SEGMENT_KEY")
        
        config.use(SEGAppsFlyerIntegrationFactory())
        config.enableAdvertisingTracking = true
        config.trackApplicationLifecycleEvents = true
        config.trackDeepLinks = true
        config.trackPushNotifications = true
        config.trackAttributionData = true
        
        Analytics.SEGAnalytics.debug(true)
        Analytics.SEGAnalytics.setup(with: config)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
      
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
     
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}


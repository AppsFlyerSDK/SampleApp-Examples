/*********************************************************************
 In order for us to provide optimal support,
 we would kindly ask you to submit any issues to support@appsflyer.com
 *********************************************************************/

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /** APPSFLYER INIT **/
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = @"<DEV_KEY>";
    [AppsFlyerTracker sharedTracker].appleAppID = @"<APP_ID>";
    
    [AppsFlyerTracker sharedTracker].delegate = self;
    
    /* Set isDebud to true to see AppsFlyer debug logs */
    [AppsFlyerTracker sharedTracker].isDebug = true;
    
    
    /* Register for Push Notification - used for uninstall tracking */
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /* Call trackAppLaunch to start tracking */
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}


- (void)applicationWillTerminate:(UIApplication *)application {

}



/* Conversion data is retrned on first launch, cached, then it returns the same data on every launch */
-(void)onConversionDataReceived:(NSDictionary*) installData {
    
    id status = [installData objectForKey:@"af_status"];
    if([status isEqualToString:@"Non-organic"]) {
        id sourceID = [installData objectForKey:@"media_source"];
        id campaign = [installData objectForKey:@"campaign"];
        NSLog(@"This is a none organic install. Media source: %@  Campaign: %@",sourceID,campaign);
    } else if([status isEqualToString:@"Organic"]) {
        NSLog(@"This is an organic install.");
    }
}
-(void)onConversionDataRequestFailure:(NSError *) error {
    NSLog(@"%@",error);
}

/* onAppOpenAttribution is called only when a deep link is opened */
- (void)onAppOpenAttribution:(NSDictionary *)attributionData{
    NSLog(@"%@",attributionData);
}

- (void)onAppOpenAttributionFailure:(NSError *)error{
     NSLog(@"%@",error);
}


// Reports app open from a Universal Link for iOS 9 or above
- (BOOL) application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler {
    [[AppsFlyerTracker sharedTracker] continueUserActivity:userActivity restorationHandler:restorationHandler];
    return YES;
}

// Reports app open from deep link from apps which do not support Universal Links (Twitter) and for iOS8 and below
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    [[AppsFlyerTracker sharedTracker] handleOpenURL:url sourceApplication:sourceApplication withAnnotation:annotation];
    return YES;
}
// Reports app open from deep link for iOS 10
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
            options:(NSDictionary *) options {
    [[AppsFlyerTracker sharedTracker] handleOpenUrl:url options:options];
    return YES;
}

/* Track Push notification */
-(void)application:(UIApplication *)app didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[AppsFlyerTracker sharedTracker] handlePushNotification:userInfo];
}


/* Send device token to AppsFlyer servers for uninstall tracking */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[AppsFlyerTracker sharedTracker] registerUninstall:deviceToken];
}




@end

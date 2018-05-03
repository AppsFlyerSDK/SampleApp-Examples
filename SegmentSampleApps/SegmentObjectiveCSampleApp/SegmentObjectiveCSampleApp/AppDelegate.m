//
//  AppDelegate.m
//  SegmentObjectiveCSampleApp
//
//  Created by Jonathan Wesfield on 03/05/2018.
//  Copyright © 2018 AppsFlyer. All rights reserved.
//

#import "AppDelegate.h"
#import "SEGAppsFlyerIntegrationFactory.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:@"<SEG_KEY>"];
    [config use:[SEGAppsFlyerIntegrationFactory createWithLaunchDelegate:self]];
    [config use:[SEGAppsFlyerIntegrationFactory instance]];
    
    config.enableAdvertisingTracking = YES;       //OPTIONAL
    config.trackApplicationLifecycleEvents = YES; //OPTIONAL
    config.trackDeepLinks = YES;                  //OPTIONAL
    config.trackPushNotifications = YES;          //OPTIONAL
    config.trackAttributionData = YES;            //OPTIONAL
    [SEGAnalytics debug:YES];                     //OPTIONAL
    [SEGAnalytics setupWithConfiguration:config];
    
    return YES;
}


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


- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {
  
}


@end

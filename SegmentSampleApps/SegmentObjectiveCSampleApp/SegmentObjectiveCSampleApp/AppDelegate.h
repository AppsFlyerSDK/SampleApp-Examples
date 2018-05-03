//
//  AppDelegate.h
//  SegmentObjectiveCSampleApp
//
//  Created by Jonathan Wesfield on 03/05/2018.
//  Copyright © 2018 AppsFlyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEGAppsFlyerIntegrationFactory.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate , SEGAppsFlyerTrackerDelegate>

@property (strong, nonatomic) UIWindow *window;


@end


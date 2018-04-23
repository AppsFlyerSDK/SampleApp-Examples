//
//  ShareInviteHelper.h
//  AppsFlyerLib
//
//  Created by Gil Meroz on 27/01/2017.
//
//

#import <Foundation/Foundation.h>
#import "AppsFlyerLinkGenerator.h"
@interface AppsFlyerShareInviteHelper : NSObject

NS_ASSUME_NONNULL_BEGIN

+ (AppsFlyerLinkGenerator* _Nonnull) generateInviteUrl;

+ (void) trackInvite:(nullable NSString *) channel
          parameters:(nullable NSDictionary *)parameters;
@end

NS_ASSUME_NONNULL_END
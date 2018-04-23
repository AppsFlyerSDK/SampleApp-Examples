//
//  LinkGenerator.h
//  AppsFlyerLib
//
//  Created by Gil Meroz on 27/01/2017.
//
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface AppsFlyerLinkGenerator: NSObject
- (nonnull id) initWithMeidaSource:(nonnull NSString *) mediaSource;
- (nullable NSString *) getMediaSource;
- (void)       setChannel           :(nonnull NSString *) channel;
- (void)       setReferrerCustomerId:(nonnull NSString *) referrerCustomerId;
- (void)       setCampaign          :(nonnull NSString *) campaign;
- (void)       setReferrerUID       :(nonnull NSString *) referrerUID;
- (void)       setReferrerName      :(nonnull NSString *) referrerName;
- (void)       setReferrerImageURL  :(nonnull NSString *) referrerImageURL;
- (void)       setBaseURL           :(nonnull NSString *) baseURL;
- (void)       setAppleAppID        :(nonnull NSString *) appleAppID;
- (void)       setDeeplinkPath      :(nonnull NSString *) deeplinkPath;
- (void)       setBaseDeeplink      :(nonnull NSString *) baseDeeplink;
- (void)       addParameterValue    :(nonnull NSString *) value forKey:(NSString*)key;
- (void)       addParameters        :(nonnull NSDictionary*) parameters;
- (nonnull NSString *) generateLink;
@end

NS_ASSUME_NONNULL_END

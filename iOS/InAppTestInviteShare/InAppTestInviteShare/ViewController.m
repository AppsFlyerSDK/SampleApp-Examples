//
//  ViewController.m
//  InApp Test Share
//
//  Created by Maxim Shoustin on 2/7/17.
//
//

#import "ViewController.h"
#import "NSString_URLEncoding.h"
#import <Social/Social.h>
#import <Foundation/NSException.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AppsFlyerLib/AppsFlyerTracker.h>


#define IsAtLeastiOSVersion(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)

static NSString *const kShareOptionMessage = @"message";
static NSString *const kShareOptionSubject = @"subject";
static NSString *const kShareOptionFiles = @"files";
static NSString *const kShareOptionUrl = @"url";

static NSString *const kAFChannelEmail = @"email";
static NSString *const kAFChannelWhatsapp = @"whatsapp";
static NSString *const kAFChannelFacebook = @"facebook";


static NSString *const kCrossPromotedAppId = @"22222222";
static NSString *const kCrossPromotedCampain = @"test campain";



@interface ViewController (){
    AppsFlyerLinkGenerator *linkGenerator;
}



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // generate imression for cross-promotion
    // (in real world it can be different view controller/ bunner with other application under cross promotion)
    
    [AppsFlyerCrossPromotionHelper trackCrossPromoteImpression:kCrossPromotedAppId campaign:kCrossPromotedCampain];
}


- (NSString*) buildAFLink: (NSString*)chanel{
    
    linkGenerator = [AppsFlyerShareInviteHelper generateInviteUrl];
    
    [linkGenerator setChannel:chanel];
    [linkGenerator setReferrerName:@"Boob"];
    [linkGenerator setReferrerImageURL:@"http://lh3.googleusercontent.com/-gkFMV23wXVs/AAAAAAAAAAI/AAAAAAAAAAA/ADPlhfL8Viv0vViwa0mF0avJk868C5PIAw/s32-c-mo/photo.jpg"];
    
    return [linkGenerator generateLink];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickCrossPromotion:(id)sender {
    [self crossPromotion];
}


- (IBAction)clickWhatsapp:(UIButton *)sender {
    [self shareViaWhatsApp];
}

- (IBAction)clickFacebook:(id)sender {
    [self shareViaFacebook];
}

- (IBAction)clickEmail:(id)sender {
    [self shareViaEmail];
}

- (IBAction)clickShare:(id)sender {
    
    NSDictionary* options = @{
                              kShareOptionMessage: @"share this",// not supported on some apps (Facebook, Instagram)
                              kShareOptionSubject: @"the fess's subject", // fi. for email
                              kShareOptionUrl: @"https://www.website.com/foo/#bar?a=b"
                              };
    
    [self shareInternal:options];
}

- (void) crossPromotion {
    
    [AppsFlyerCrossPromotionHelper trackAndOpenStore:kCrossPromotedAppId
                                            campaign:kCrossPromotedCampain
                                           paramters:nil
                                           openStore:^(NSURLSession *urlSession, NSURL *clickURL)
     {
         NSURLSessionDataTask *dataTask;
         
         dataTask = [urlSession dataTaskWithURL:clickURL
                              completionHandler:^(NSData * _Nullable data,
                                                  NSURLResponse * _Nullable response,
                                                  NSError * _Nullable error)
                     {
                         if (error) {
                             NSLog(@"AppsFlyer crossPromotionViewed Connection failed! Error - %@",[error localizedDescription]);
                         }
                         else
                         {
                             if (NSClassFromString(@"SKStoreProductViewController") == nil) {
                                 
                                 NSString *iTunesLink = [linkGenerator generateLink];
                                 
                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink] options:@{} completionHandler:^(BOOL success) {
                                     NSLog(@"AppsFlyer openAppStoreForAppID completionHandler result %d",success);
                                 }];
                             }
                             
                             
                         }
                         
                     }];
         [dataTask resume];
         
         if (NSClassFromString(@"SKStoreProductViewController") != nil) {
             [self openStoreKit:kCrossPromotedAppId viewController:self];
         }
     }];
}


- (void) openStoreKit:(NSString*) appID
       viewController: (UIViewController*) viewController
{
    
    SKStoreProductViewController *storeController = [[ SKStoreProductViewController alloc ] init ];
    
    NSDictionary *productParameters = @{ SKStoreProductParameterITunesItemIdentifier : appID };
    [ storeController loadProductWithParameters: productParameters completionBlock:^( BOOL result, NSError *error )
     {
         if ( result )
         {
             [viewController presentViewController:storeController animated:YES completion:nil];
         }
     }];
}

- (void)shareInternal:(NSDictionary*)options {
    
    NSString *message   = options[kShareOptionMessage];
    NSString *subject   = options[kShareOptionSubject];
    NSString *urlString = options[kShareOptionUrl];
    
    NSMutableArray *activityItems = [[NSMutableArray alloc] init];
    
    if (message != (id)[NSNull null] && message != nil) {
        [activityItems addObject:message];
    }
    
    if (urlString != (id)[NSNull null] && urlString != nil) {
        [activityItems addObject:[NSURL URLWithString:[urlString URLEncodedString]]];
    }
    
    UIActivity *activity = [[UIActivity alloc] init];
    NSArray *applicationActivities = [[NSArray alloc] initWithObjects:activity, nil];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
    if (subject != (id)[NSNull null] && subject != nil) {
        [activityVC setValue:subject forKey:@"subject"];
    }
    
    if ([activityVC respondsToSelector:(@selector(setCompletionWithItemsHandler:))]) {
        [activityVC setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray * returnedItems, NSError * activityError) {
            
            NSDictionary * result = @{@"completed":@(completed), @"app":activityType == nil ? @"" : activityType};
            
        }];
    } else {
        // let's suppress this warning otherwise folks will start opening issues while it's not relevant
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed) {
            //[self cleanupStoredFiles];
            NSDictionary * result = @{@"completed":@(completed), @"app":activityType};
        }];
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
    
    NSArray * socialSharingExcludeActivities = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SocialSharingExcludeActivities"];
    if (socialSharingExcludeActivities!=nil && [socialSharingExcludeActivities count] > 0) {
        activityVC.excludedActivityTypes = socialSharingExcludeActivities;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [[self getTopMostViewController] presentViewController:activityVC animated:YES completion:nil];
    });
    
}

- (void)shareViaInternal:(NSString *) type {
    
    NSString* urlString;
    NSString *message;
    
    if(type == SLServiceTypeFacebook){
        urlString = [self buildAFLink:kAFChannelFacebook];
        message = [NSString stringWithFormat:@"please, install this recommended app: %@", urlString];
    }
    
    
    // boldly invoke the target app, because the phone will display a nice message asking to configure the app
    SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:type];
    if (message != (id)[NSNull null]) {
        [composeViewController setInitialText:message];
    }
    
    if (urlString != (id)[NSNull null]) {
        [composeViewController addURL:[NSURL URLWithString:[urlString URLEncodedString]]];
    }
    
    [composeViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
        if (SLComposeViewControllerResultCancelled == result) {
            
        } else if ([self isAvailableForSharing:type]) {
            
        } else {
            // not available
        }
        // required for iOS6 (issues #162 and #167)
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [[self getTopMostViewController] presentViewController:composeViewController animated:YES completion:nil];
}



- (void)shareViaFacebook {
    [self shareViaInternal:SLServiceTypeFacebook];
}

- (void)shareViaFacebookWithPasteMessageHint{
    // If Fb app is installed a message is not prefilled.
    // When shared through the default iOS widget (iOS Settings > Facebook) the message is prefilled already.
    NSString *message = @"some messge ...";
    if (message != (id)[NSNull null]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1000 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
            BOOL fbAppInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]; // requires whitelisting on iOS9
            if (fbAppInstalled) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setValue:message forPasteboardType:@"public.text"];
                NSString *hint = @"some hint";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:hint delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                [alert show];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2800 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
                    [alert dismissWithClickedButtonIndex:-1 animated:YES];
                });
            }
        });
    }
    [self shareViaInternal:SLServiceTypeFacebook];
}

- (void)shareViaWhatsApp {
    
    // on iOS9 canShareVia('whatsapp'..) will only work if whatsapp:// is whitelisted.
    // If it's not, this method will ask permission to the user on iOS9 for opening the app,
    // which is of course better than WhatsApp sharing not working at all because you forgot to whitelist it.
    // Tradeoff: on iOS9 this method will always return true, so make sure to whitelist it and call canShareVia('whatsapp'..)
    if (!IsAtLeastiOSVersion(@"9.0")) {
        if (![self canShareViaWhatsApp]) {
            return;
        }
    }
    
    
    NSString* urlString = [self buildAFLink:kAFChannelWhatsapp];
    NSString *message = [NSString stringWithFormat:@"please, install this recommended app: %@", urlString]  ;
    
    // subject is not supported by the SLComposeViewController
    
    NSString *abid = @"";
    
    // append an url to a message, if both are passed
    NSString * shareString = @"";
    if (message != (id)[NSNull null]) {
        shareString = message;
    }
    if (urlString != (id)[NSNull null]) {
        if ([shareString isEqual: @""]) {
            shareString = urlString;
        } else {
            shareString = [NSString stringWithFormat:@"%@ %@", shareString, [urlString URLEncodedString]];
        }
    }
    NSString * encodedShareString = [shareString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // also encode the '=' character
    encodedShareString = [encodedShareString stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    encodedShareString = [encodedShareString stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    NSString * abidString = @"";
    if (abid != (id)[NSNull null]) {
        abidString = [NSString stringWithFormat:@"abid=%@&", abid];
    }
    NSString * encodedShareStringForWhatsApp = [NSString stringWithFormat:@"whatsapp://send?%@text=%@", abidString, encodedShareString];
    
    NSURL *whatsappURL = [NSURL URLWithString:encodedShareStringForWhatsApp];
    [[UIApplication sharedApplication] openURL: whatsappURL];
    
    NSDictionary *params = @{@"key": @"value", @"af_campagn":kCrossPromotedCampain};
    [AppsFlyerShareInviteHelper trackInvite:kAFChannelWhatsapp
                                 parameters:params];
    
}

- (void)shareViaEmail {
    if ([self isEmailAvailable]) {
        
        [self cycleTheGlobalMailComposer];
        
        self.globalMailComposer.mailComposeDelegate = self;
        
        NSString* url = [self buildAFLink:kAFChannelEmail];
        NSString *message = [NSString stringWithFormat:@"please, install this recommended app: %@", url];
        BOOL isHTML = [message rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch].location != NSNotFound;
        [self.globalMailComposer setMessageBody:message isHTML:isHTML];
        
        [self.globalMailComposer setSubject: @"the subject"];
        
        [self.globalMailComposer setToRecipients:@[@"somemail123@thecompany.com"]];
        
        
        
        [self runInBackground:^{
            [[self getTopMostViewController] presentViewController:self.globalMailComposer animated:YES completion:nil];
        }];
        
    }
    else {
        // ...
    }
}

/**
 * Delegate will be called after the mail composer did finish an action
 * to dismiss the view.
 */
- (void) mailComposeController:(MFMailComposeViewController*)controller
           didFinishWithResult:(MFMailComposeResult)result
                         error:(NSError*)error {
    bool ok = result == MFMailComposeResultSent;
    
    
    
    [self.globalMailComposer dismissViewControllerAnimated:YES completion:^{[self cycleTheGlobalMailComposer];}];
}


- (void)runInBackground:(void (^)())block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

- (bool)isEmailAvailable {
    Class messageClass = (NSClassFromString(@"MFMailComposeViewController"));
    return messageClass != nil && [messageClass canSendMail];
}

- (bool)isAvailableForSharing:(NSString *) type {
    // isAvailableForServiceType returns true if you pass it a type that is not
    // in the defined constants, this is probably a bug on apples part
    if(!([type isEqualToString:SLServiceTypeFacebook]
         || [type isEqualToString:SLServiceTypeTwitter]
         || [type isEqualToString:SLServiceTypeTencentWeibo]
         || [type isEqualToString:SLServiceTypeSinaWeibo])) {
        return false;
    }
    // wrapped in try-catch, because isAvailableForServiceType may crash if an invalid type is passed
    @try {
        return [SLComposeViewController isAvailableForServiceType:type];
    }
    @catch (NSException* exception) {
        return false;
    }
}

- (UIViewController*) getTopMostViewController {
    UIViewController *presentingViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    while (presentingViewController.presentedViewController != nil) {
        presentingViewController = presentingViewController.presentedViewController;
    }
    return presentingViewController;
}

- (NSString*) getBasenameFromAttachmentPath:(NSString*)path {
    if ([path hasPrefix:@"base64:"]) {
        NSString* pathWithoutPrefix = [path stringByReplacingOccurrencesOfString:@"base64:" withString:@""];
        return [pathWithoutPrefix substringToIndex:[pathWithoutPrefix rangeOfString:@"//"].location];
    }
    return [path componentsSeparatedByString: @"?"][0];
}

- (NSString*) getMimeTypeFromFileExtension:(NSString*)extension {
    if (!extension) {
        return nil;
    }
    // Get the UTI from the file's extension
    CFStringRef ext = (CFStringRef)CFBridgingRetain(extension);
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, ext, NULL);
    // Converting UTI to a mime type
    NSString *result = (NSString*)CFBridgingRelease(UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType));
    CFRelease(ext);
    CFRelease(type);
    return result;
}


-(void)cycleTheGlobalMailComposer {
    // we are cycling the damned GlobalMailComposer: http://stackoverflow.com/questions/25604552/i-have-real-misunderstanding-with-mfmailcomposeviewcontroller-in-swift-ios8-in/25604976#25604976
    self.globalMailComposer = nil;
    self.globalMailComposer = [[MFMailComposeViewController alloc] init];
}



// Dismisses the SMS composition interface when users taps Cancel or Send
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    bool ok = result == MessageComposeResultSent;
    [[self getTopMostViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (bool)canShareViaInstagram {
    return [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"instagram://app"]]; // requires whitelisting on iOS9
}

- (bool)canShareViaWhatsApp {
    return [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]]; // requires whitelisting on iOS9
}

#pragma mark - UIDocumentInteractionControllerDelegate methods

- (void) documentInteractionController: (UIDocumentInteractionController *) controller willBeginSendingToApplication: (NSString *) application {
    // note that the application actually contains the app bundle id which was picked (for whatsapp and instagram only)
    NSLog(@"SocialSharing app selected: %@", application);
}


@end

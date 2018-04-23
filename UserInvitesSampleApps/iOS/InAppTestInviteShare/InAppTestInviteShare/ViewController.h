//
//  ViewController.h
//  InApp Test Share
//
//  Created by Maxim Shoustin on 2/7/17.
//
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface ViewController : UIViewController <UIPopoverControllerDelegate, MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) MFMailComposeViewController *globalMailComposer;
@property (nonatomic, strong) UIDocumentInteractionController * documentInteractionController;
@property (retain) NSString * tempStoredFile;


@end


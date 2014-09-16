//
//  MCAShareViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 16/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface MCAShareViewController : UIViewController<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>{
    
    SLComposeViewController *mycomeposersheet;
}
-(IBAction)btnMailDidClicked:(id)sender;
-(IBAction)btnMessageDidClicked:(id)sender;
-(IBAction)btnTwitterDidClicked:(id)sender;
-(IBAction)btnFbDidClicked:(id)sender;
@end

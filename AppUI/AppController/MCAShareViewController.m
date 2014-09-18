//
//  MCAShareViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 16/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAShareViewController.h"

@interface MCAShareViewController ()

@end

@implementation MCAShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnFbDidClicked:(id)sender {
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        mycomeposersheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [   mycomeposersheet addURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/eadbook/id790237067?ls=1&mt=8"]];
        [   mycomeposersheet setInitialText:@"Please download this app."];
        
        [self presentViewController:mycomeposersheet animated:YES completion:nil];
        
        [   mycomeposersheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSLog(@"start completion block");
            NSString *output;
            UIAlertView *alert;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    alert = [[UIAlertView alloc] initWithTitle:@"Facebook Message" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Link Post Successfull";
                    break;
                default:
                    break;
            }
            if (result != SLComposeViewControllerResultCancelled)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Message" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                   [alert show];
                                   
                               });
                
                
            }
        }];
    }
    
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"You can't share application link right now, make sure your device has an internet connection and you have to  login from setting."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    
}



-(IBAction)btnTwitterDidClicked:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        mycomeposersheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [   mycomeposersheet addURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/eadbook/id790237067?ls=1&mt=8"]];
        [   mycomeposersheet setInitialText:@"Please download this app."];
        
        [self presentViewController:   mycomeposersheet animated:YES completion:nil];
        
        [   mycomeposersheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSLog(@"start completion block");
            NSString *output;
            UIAlertView *alert;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    alert = [[UIAlertView alloc] initWithTitle:@"Twitter Message" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Link Post Successfull";
                    break;
                default:
                    break;
            }
            if (result != SLComposeViewControllerResultCancelled)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Message" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                   [alert show];
                                   
                               });
                
                
                
            }
        }];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"You can't share application link right now, make sure your device has an internet connection and you have to  login from setting."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    
    
    
}
-(IBAction)btnMessageDidClicked:(id)sender {
    
    MFMessageComposeViewController *Txtcomposer=[[MFMessageComposeViewController alloc]init];
    [Txtcomposer setMessageComposeDelegate:self];
    if(	[MFMessageComposeViewController canSendText])
    {
        [Txtcomposer setBody:@"Type your message"];
        [self presentViewController:Txtcomposer animated:YES completion:nil];
    }
    
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    UIAlertView *alert;
    NSString *output;
    switch (result) {
        case MessageComposeResultSent:
            output=@"send";
            alert=[[UIAlertView alloc] initWithTitle:@"Messenger Message" message:output delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            break;
        case MessageComposeResultFailed:
            NSLog(@"failde");
            output=@"failde";
            alert= [[UIAlertView alloc]initWithTitle:@"Messenger Message" message:output delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            break;
        case MessageComposeResultCancelled:
            
            output=@"cancelled";
            alert = [[UIAlertView alloc] initWithTitle:@"Twitter Message" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
            
            
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


-(IBAction)btnMailDidClicked:(id)sender {
    
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"iOS programming ";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"balkaran.singh@aryavrat.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *output;
    UIAlertView *alert;
    switch (result)
    {            
        case MFMailComposeResultCancelled:
            output=@"Mail cancelled";
            alert=[[UIAlertView alloc]initWithTitle:@"Mail Message" message:output delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
            break;
        case MFMailComposeResultSaved:
            output=@"Mail saved";
            alert=[[UIAlertView alloc]initWithTitle:@"Mail Message" message:output delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
            break;
        case MFMailComposeResultSent:
            output=@"Mail sent";
            alert=[[UIAlertView alloc]initWithTitle:@"Mail Message" message:output delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end

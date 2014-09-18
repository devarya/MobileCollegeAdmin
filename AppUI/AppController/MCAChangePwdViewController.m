//
//  MCAChangePwdViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 12/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAChangePwdViewController.h"

@interface MCAChangePwdViewController ()

@end

@implementation MCAChangePwdViewController

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
    
    HUD=[AryaHUD new];
    [self.view addSubview:HUD];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePwdSuccess:) name:NOTIFICATION_CHANGE_PWD_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePwdFailed:) name:NOTIFICATION_CHANGE_PWD_FAILED object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tx_confirmPwd resignFirstResponder];
    [tx_newPwd resignFirstResponder];
    [tx_oldPwd resignFirstResponder];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - IB_ACTION

-(IBAction)btnDoneDidClicked:(id)sender{
    
    tx_oldPwd.text = [tx_oldPwd.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tx_newPwd.text = [tx_newPwd.text stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tx_confirmPwd.text = [tx_confirmPwd.text stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceAndNewlineCharacterSet]];
 
    if (![tx_oldPwd.text isEqualToString:@""]) {
        
        if ([tx_newPwd.text isEqualToString:tx_confirmPwd.text]) {
            
            NSMutableDictionary *info = [NSMutableDictionary new];
            [info setValue:tx_oldPwd.text forKey:@"pwd"];
            [info setValue:tx_newPwd.text forKey:@"new_pwd"];
            [info setValue:@"change_password" forKey:@"cmd"];
            
            NSString *str_jsonChangePwd = [NSString getJsonObject:info];
            [HUD showForTabBar];
            [self requestChangePwd:str_jsonChangePwd];
        }else{
            
              [MCAGlobalFunction showAlert:@"Confirm password and new password didn't match."];
        }
    }else{
        [MCAGlobalFunction showAlert:INVALID_PWD];
    }
}
#pragma mark - API CALLING

-(void)requestChangePwd:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForChangePwd:info];
    }else{
        [HUD hide];
        [MCAGlobalFunction showAlert:NET_NOT_AVAIALABLE];
    }
}
#pragma mark - NSNOTIFICATION SELECTOR

-(void)changePwdSuccess:(NSNotification*)notification{
    
    [HUD hide];
    
    [tx_newPwd resignFirstResponder];
    [tx_confirmPwd resignFirstResponder];
    [tx_oldPwd resignFirstResponder];
      
    UIAlertView *alert   = [[UIAlertView alloc]initWithTitle:@"Message"
                                                     message:notification.object
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil, nil];
    [alert show];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),^ {
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}
-(void)changePwdFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}

@end

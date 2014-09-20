//
//  MCAForgotPwdViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 04/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAForgotPwdViewController.h"

@interface MCAForgotPwdViewController ()

@end

@implementation MCAForgotPwdViewController

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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forgotPwdSuccess:) name:NOTIFICATION_FORGOT_PWD_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forgotPwdFailed:) name:NOTIFICATION_FORGOT_PWD_FAILED object:nil];
    
    HUD = [AryaHUD new];
    [self.view addSubview:HUD];
    
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self getLanguageStrings:nil];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tx_forgotPwd resignFirstResponder];
        
}
#pragma mark - LANGUAGE_SUPPORT

-(void)getLanguageStrings:(id)sender{
    
    navBar.topItem.title = [NSString languageSelectedStringForKey:@"fpassword"];
    tx_forgotPwd.placeholder = @"Email";
    [btn_submit setTitle:[NSString languageSelectedStringForKey:@"submit"] forState:UIControlStateNormal];
    
}

#pragma mark - IB_ACTION

-(IBAction)btnBackDidClicked:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)btnSubmitDidClicked:(id)sender{
    
     if (![tx_forgotPwd.text isEqualToString:@""] && [MCAValidation isValidEmailId:tx_forgotPwd.text]) {
        
         NSMutableDictionary *info=[NSMutableDictionary new];
         [info setValue:tx_forgotPwd.text forKey:@"signin_id"];
         
         [info setValue:@"forgot_password" forKey:@"cmd"];
         
         NSString *str_jsonForgotPwd = [NSString getJsonObject:info];
         
         [HUD show];
         [tx_forgotPwd resignFirstResponder];
         [self requestForgotPwd:str_jsonForgotPwd];

     }else{
         
         [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"emailValidate_msg"]];
     }
}
#pragma mark - API CALLING

-(void)requestForgotPwd:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForForgotPwd:info];
    }else{
        [HUD hide];
        [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"noInternetMsg"]];
    }
}

#pragma mark - NSNOTIFICATION SELECTOR

-(void)forgotPwdSuccess:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}

-(void)forgotPwdFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}
@end

//
//  MCALoginViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 01/07/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCALoginViewController.h"

@interface MCALoginViewController ()

@end

@implementation MCALoginViewController

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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess:) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginFailed:) name:NOTIFICATION_LOGIN_FAILED object:nil];
    
    HUD=[AryaHUD new];
    [self.view addSubview:HUD];
    
    [self btnSelectLangDidClicked:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tx_email resignFirstResponder];
    [tx_pwd resignFirstResponder];

    [self keyboardDisappeared];
    
}

#pragma mark - KEYBOARD_METHOD

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self keyboardAppeared];
    return  YES;
}
-(void) keyboardAppeared
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationBeginsFromCurrentState: NO];
  
    if (IS_IPHONE_5) {
         self.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    }else{
         self.view.frame = CGRectMake(0,-78, self.view.frame.size.width, self.view.frame.size.height);
    }
        
    [UIView commitAnimations];
}
-(void) keyboardDisappeared
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    
    if (IS_IPHONE_5)
    {
        self.view.frame =CGRectMake(0,0,  self.view.frame.size.width, self.view.frame.size.height);
       //this is iphone 5
    } else
    {
        self.view.frame =CGRectMake(0,0,  self.view.frame.size.width, self.view.frame.size.height);
        // this is iphone 4
    }
    
    [UIView commitAnimations];
}

#pragma mark - IB_ACTION

-(IBAction)ReturnKeyButton:(id)sender
{
    [sender resignFirstResponder];
    [self keyboardDisappeared];
}
-(IBAction)btnLoginDidClicked:(id)sender{
    
    if (![tx_email.text isEqualToString:@""] && ![tx_pwd.text isEqualToString:@""])
    {
        if (![MCAValidation isValidEmailId:tx_email.text]) {
            
            [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"emailValidate_msg"]];
            
        }else{
         
            NSMutableDictionary *info=[NSMutableDictionary new];
            [info setValue:tx_email.text forKey:@"signin_id"];
            [info setValue:tx_pwd.text forKey:@"pwd"];
            [info setValue:@"user_login" forKey:@"cmd"];

            NSString *str_jsonLogin = [NSString getJsonObject:info];
            
            [HUD show];
            [self requestLogin:str_jsonLogin];
        }
    }else{
        
        [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"userNameAndpass"]];
    }
}
-(IBAction)btnSelectLangDidClicked:(id)sender{
    
    if (isSpLang) {
        
        [[NSUserDefaults standardUserDefaults]setValue:SPANISH_LANG forKey:KEY_LANGUAGE_CODE];
        [btn_selectLang setTitle:[NSString languageSelectedStringForKey:@"languagevalueLogin"] forState:UIControlStateNormal];
        isSpLang = NO;
        
        
    }else{
        
        [[NSUserDefaults standardUserDefaults]setValue:ENGLISH_LANG forKey:KEY_LANGUAGE_CODE];
        [btn_selectLang setTitle:[NSString languageSelectedStringForKey:@"languagevalueLogin"] forState:UIControlStateNormal];
        isSpLang = YES;
        
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self getLanguageStrings:nil];
    
}

#pragma mark - LANGUAGE_SUPPORT
-(void)getLanguageStrings:(id)sender{
    
    lbl_logoText.text = [NSString languageSelectedStringForKey:@"logoText"];
    lbl_learnMore.text = [NSString languageSelectedStringForKey:@"learnMore"];
    
    tx_email.placeholder = [NSString languageSelectedStringForKey:@"userName"];
    tx_pwd.placeholder = [NSString languageSelectedStringForKey:@"password"];
    
    [btn_login setTitle:[NSString languageSelectedStringForKey:@"login"] forState:UIControlStateNormal];
    [btn_forgotPwd setTitle:[NSString languageSelectedStringForKey:@"fpassword"] forState:UIControlStateNormal];
    [btn_signUp setTitle:[NSString languageSelectedStringForKey:@"newUser"] forState:UIControlStateNormal];
    [btn_tutorial setTitle:[NSString languageSelectedStringForKey:@"tutorial"] forState:UIControlStateNormal];
    
}

#pragma mark - API CALLING

-(void)requestLogin:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
       
        [self keyboardDisappeared];
        [[MCARestIntraction sharedManager]requestForLogin:info];
        
    }else{
        
        [HUD hide];
        [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"noInternetMsg"]];
    }
}

#pragma mark - NSNOTIFICATION SELECTOR

-(void)loginSuccess:(NSNotification*)notification{
    
   [self keyboardDisappeared];
    
   MCALoginDHolder *loginDHolder = notification.object;
   [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_userId forKey:KEY_USER_ID];
   [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_signinId forKey:KEY_SIGNIN_ID];
   [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_userType forKey:KEY_USER_TYPE];
   [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_zipCode forKey:KEY_USER_ZIPCODE];
   [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_userName forKey:KEY_USER_NAME];
   [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_family forKey:KEY_USER_FAMILY];
   [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_grade forKey:KEY_USER_GRADE];
   [[NSUserDefaults standardUserDefaults]setInteger:loginDHolder.arr_StudentData.count forKey:KEY_STUDENT_COUNT];
   [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_userToken forKey:KEY_USER_TOKEN];
   [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_notifyByPush forKey:KEY_NOTIFY_BY_PUSH];
   [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_notifyByMail forKey:KEY_NOTIFY_BY_EMAIL];
   [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_priorityHigh forKey:KEY_PRIORITY_HIGH];
   [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_priorityRegular forKey:KEY_PRIORITY_REGULAR];
   [[NSUserDefaults standardUserDefaults]synchronize];
  
   [HUD hide];
   [self performSegueWithIdentifier:@"tabBarSeque" sender:self];
    
}
-(void)loginFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"tabBarSeque"]) {
                
        [[MCAGlobalData sharedManager]goToTabbarView:segue];
    }
}

@end

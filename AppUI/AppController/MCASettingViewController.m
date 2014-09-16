
//
//  MCASettingViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 11/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCASettingViewController.h"

@interface MCASettingViewController ()

@end

@implementation MCASettingViewController{
    
    BOOL isTaskAlertPush;
    BOOL isTaskAlertEmail;
    BOOL isPriorityHigh;
    BOOL isPriorityRegular;
}

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
    
    HUD = [AryaHUD new];
    [self.view addSubview:HUD];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestSettingSuccess:) name:NOTIFICATION_SETTING_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestSettingFailed:) name:NOTIFICATION_SETTING_FAILED object:nil];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_NOTIFY_BY_PUSH] isEqualToString:@"1"]) {
       [btn_taskAlertPush setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
        isTaskAlertPush = YES;
        
    }else{
        [btn_taskAlertPush setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
        isTaskAlertPush = NO;
    }
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_NOTIFY_BY_EMAIL] isEqualToString:@"1"]) {
        [btn_taskAlertEmail setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
        isTaskAlertEmail = YES;
        
    }else{
        [btn_taskAlertEmail setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
        isTaskAlertEmail = NO;
    }
    
    
    //Priority Alert
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_PRIORITY_HIGH] isEqualToString:@"1"]) {
        [btn_priorityAlertHigh setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
        isPriorityHigh = YES;
        
    }else{
        [btn_priorityAlertHigh setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
        isPriorityHigh = NO;
    }
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_PRIORITY_REGULAR] isEqualToString:@"1"]) {
        [btn_priorityAlertRegular setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
        isPriorityRegular = YES;
        
    }else{
        [btn_priorityAlertRegular setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
        isPriorityRegular = NO;
    }
    
    btn_add.layer.borderWidth = 0.5f;
    btn_add.layer.borderColor=[UIColor colorWithRed:32.0/255.0 green:36.0/255.0 blue:48.0/255.0 alpha:1].CGColor;
    btn_add.layer.cornerRadius = 3.0f;
    
    btn_ViewStudParent.layer.borderWidth = 0.5f;
    btn_ViewStudParent.layer.borderColor=[UIColor colorWithRed:32.0/255.0 green:36.0/255.0 blue:48.0/255.0 alpha:1].CGColor;
    btn_ViewStudParent.layer.cornerRadius = 3.0f;
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"]) {
        
         [btn_ViewStudParent setTitle:@"View My Student" forState:UIControlStateNormal];
        
    }else{
         [btn_ViewStudParent setTitle:@"View My Parent" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IB_ACTION

-(IBAction)btnChangePwdDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_changePwd" sender:nil];
    
}
-(IBAction)btnUserProfileDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_userProfile" sender:nil];
    
}
-(IBAction)btnAddStudParDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_add" sender:nil];
}

-(IBAction)btnTaskAlertPushDidCliked:(id)sender{
    
    if (isTaskAlertPush) {
        
        [btn_taskAlertPush setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
        isTaskAlertPush = NO;
        
    }else{
        
        [btn_taskAlertPush setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
        isTaskAlertPush = YES;
    }
    
    btn_taskAlertPush.tag = 1;
    btn_taskAlertEmail.tag = 0;
    btn_priorityAlertHigh.tag = 0;
    btn_priorityAlertRegular.tag = 0;
    
    [self setNotificationSetting:nil];
}
-(IBAction)btnTaskAlertEmailDidCliked:(id)sender{
    
    if (isTaskAlertEmail) {
        
        [btn_taskAlertEmail setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
        isTaskAlertEmail = NO;
        
    }else{
        
        [btn_taskAlertEmail setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
        isTaskAlertEmail = YES;
    }
    
    btn_taskAlertPush.tag = 0;
    btn_taskAlertEmail.tag = 1;
    btn_priorityAlertHigh.tag = 0;
    btn_priorityAlertRegular.tag = 0;
    
    [self setNotificationSetting:nil];
}

-(IBAction)btnPriorityAlertHighDidClicked:(id)sender{
    
    if (isPriorityHigh) {
        
        if(isPriorityRegular){
         
            [btn_priorityAlertHigh setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
            isPriorityHigh = NO;
            
        }else{
            
              [MCAGlobalFunction showAlert:@"Atleast one priority should be selected."];
              return;
        }
        
    }else{
        
        if (isPriorityRegular) {
            
            [btn_priorityAlertHigh setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
            isPriorityHigh = YES;
            
        }else{
            
            [MCAGlobalFunction showAlert:@"Atleast one priority should be selected."];
            return;
        }
    }
    
    btn_taskAlertPush.tag = 0;
    btn_taskAlertEmail.tag = 0;
    btn_priorityAlertHigh.tag = 1;
    btn_priorityAlertRegular.tag = 0;
    
     [self setNotificationSetting:nil];
}
-(IBAction)btnPriorityAlertRegularDidClicked:(id)sender{
    
    if (isPriorityRegular) {
        
        if (isPriorityHigh) {
            [btn_priorityAlertRegular setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
            isPriorityRegular = NO;

        }else{
            [MCAGlobalFunction showAlert:@"Atleast one priority should be selected."];
            return;
        }
    }else{
        if (isPriorityHigh) {
            
            [btn_priorityAlertRegular setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
            isPriorityRegular = YES;
        }else{
            [MCAGlobalFunction showAlert:@"Atleast one priority should be selected."];
            return;
        }
    }
    
    btn_taskAlertPush.tag = 0;
    btn_taskAlertEmail.tag = 0;
    btn_priorityAlertHigh.tag = 0;
    btn_priorityAlertRegular.tag = 1;
    
     [self setNotificationSetting:nil];
}
-(void)setNotificationSetting:(id)sender{
    
    NSMutableDictionary *info = [NSMutableDictionary new];
    
    [info setValue:@"" forKey:@"notify_by_email"];
    [info setValue:@"" forKey:@"notify_by_push"];
    [info setValue:@"" forKey:@"priority_high"];
    [info setValue:@"" forKey:@"priority_regular"];
    
    if (btn_taskAlertPush.tag == 1) {
        
        if (isTaskAlertPush) {
            [info setValue:@"1" forKey:@"notify_by_push"];
        }else{
            [info setValue:@"0" forKey:@"notify_by_push"];
        }
        
    }else if (btn_taskAlertEmail.tag == 1){
        
        if (isTaskAlertEmail) {
            [info setValue:@"1" forKey:@"notify_by_email"];
        }else{
            [info setValue:@"0" forKey:@"notify_by_email"];
        }
        
    }else if (btn_priorityAlertHigh.tag == 1){
     
        if (isPriorityHigh) {
            [info setValue:@"1" forKey:@"priority_high"];
        }else{
            [info setValue:@"0" forKey:@"priority_high"];
        }
        
    }else if (btn_priorityAlertRegular.tag == 1){
        
        if (isPriorityRegular) {
            [info setValue:@"1" forKey:@"priority_regular"];
        }else{
            [info setValue:@"0" forKey:@"priority_regular"];
        }
    }
 
    [info setValue:@"notification_setting" forKey:@"cmd"];
    NSString *str_jsonNotificationSetting = [NSString getJsonObject:info];
    [self requestNotificationSetting:str_jsonNotificationSetting];
    
}
#pragma mark - API CALLING

-(void)requestNotificationSetting:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForNotificationSetting:info];
    }else{
        [HUD hide];
        [MCAGlobalFunction showAlert:NET_NOT_AVAIALABLE];
    }
}
#pragma mark - NSNOTIFICATION SELECTOR

-(void)requestSettingSuccess:(NSNotification*)notification{
    
    [HUD hide];
    
    [[NSUserDefaults standardUserDefaults]setValue:[notification.object valueForKey:@"notify_by_email"] forKey:KEY_NOTIFY_BY_EMAIL];
     [[NSUserDefaults standardUserDefaults]setValue:[notification.object valueForKey:@"notify_by_push"] forKey:KEY_NOTIFY_BY_PUSH];
     [[NSUserDefaults standardUserDefaults]setValue:[notification.object valueForKey:@"priority_high"] forKey:KEY_PRIORITY_HIGH];
     [[NSUserDefaults standardUserDefaults]setValue:[notification.object valueForKey:@"priority_regular"] forKey:KEY_PRIORITY_REGULAR];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIAlertView *alert   = [[UIAlertView alloc]initWithTitle:@"Message"
                                                     message:@"Settings Updated Successfully."
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil, nil];
    [alert show];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),^ {
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
      
    });
    
}
-(void)requestSettingFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}

@end

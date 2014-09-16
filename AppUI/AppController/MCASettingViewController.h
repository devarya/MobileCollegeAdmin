//
//  MCASettingViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 11/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCASettingViewController : UIViewController{
    
   IBOutlet UIButton *btn_add;
   IBOutlet UIButton *btn_ViewStudParent;
   IBOutlet UIButton *btn_taskAlertPush;
   IBOutlet UIButton *btn_taskAlertEmail;
   IBOutlet UIButton *btn_priorityAlertHigh;
   IBOutlet UIButton *btn_priorityAlertRegular;
    
    AryaHUD *HUD;
    
}
-(IBAction)btnUserProfileDidClicked:(id)sender;
-(IBAction)btnChangePwdDidClicked:(id)sender;
-(IBAction)btnAddStudParDidClicked:(id)sender;
-(IBAction)btnTaskAlertPushDidCliked:(id)sender;
-(IBAction)btnTaskAlertEmailDidCliked:(id)sender;
-(IBAction)btnPriorityAlertHighDidClicked:(id)sender;
-(IBAction)btnPriorityAlertRegularDidClicked:(id)sender;
@end

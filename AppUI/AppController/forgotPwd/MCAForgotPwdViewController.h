//
//  MCAForgotPwdViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 04/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCAForgotPwdViewController : UIViewController{
    
    IBOutlet UIButton *btn_submit;
    IBOutlet UITextField *tx_forgotPwd;
    IBOutlet UINavigationBar *navBar;
    AryaHUD *HUD;
}
-(IBAction)btnBackDidClicked:(id)sender;
-(IBAction)btnSubmitDidClicked:(id)sender;
@end

//
//  MCALoginViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 01/07/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCALoginViewController : UIViewController{
    
    IBOutlet UITextField *tx_email;
    IBOutlet UITextField *tx_pwd;
    
    IBOutlet UILabel *lbl_logoText;
    IBOutlet UILabel *lbl_learnMore;
    
    IBOutlet UIButton *btn_selectLang;
    IBOutlet UIButton *btn_tutorial;
    IBOutlet UIButton *btn_login;
    IBOutlet UIButton *btn_forgotPwd;
    IBOutlet UIButton *btn_signUp;
    AryaHUD *HUD;
    
    BOOL isSpLang;

}
-(IBAction)btnSelectLangDidClicked:(id)sender;
-(IBAction)btnLoginDidClicked:(id)sender;
-(IBAction)ReturnKeyButton:(id)sender;
@end

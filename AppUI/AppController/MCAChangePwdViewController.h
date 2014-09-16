//
//  MCAChangePwdViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 12/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCAChangePwdViewController : UIViewController<UITextFieldDelegate>{
    
   IBOutlet UITextField *tx_oldPwd;
   IBOutlet UITextField *tx_newPwd;
   IBOutlet UITextField *tx_confirmPwd;
    
   AryaHUD *HUD;
}
-(IBAction)btnDoneDidClicked:(id)sender;
@end

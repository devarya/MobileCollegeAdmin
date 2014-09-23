//
//  MCAUserProfileViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 11/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCAUserProfileViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    
   IBOutlet UIView *view_stud;
   IBOutlet UIView *view_parent;
            UIView *view_Bg;
    
   IBOutlet UITextField *tx_pname;
   IBOutlet UITextField *tx_pemail;
   IBOutlet UITextField *tx_pzipcode;
    
   IBOutlet UITextField *tx_sname;
   IBOutlet UITextField *tx_semail;
   IBOutlet UITextField *tx_szipcode;
   IBOutlet UITextField *tx_sgrade;
   IBOutlet UITextField *tx_sfirstPerson;
  
   IBOutlet UILabel *lbl_pname;
   IBOutlet UILabel *lbl_pemail;
   IBOutlet UILabel *lbl_pzipcode;
    
   IBOutlet UILabel *lbl_sname;
   IBOutlet UILabel *lbl_semail;
   IBOutlet UILabel *lbl_sgrade;
   IBOutlet UILabel *lbl_sfirstPerson;
   IBOutlet UILabel *lbl_szipcode;
    
   UITableView *tbl_SelectPerson;
   NSArray *arr_SelectPersonList;
   AryaHUD *HUD;
}
-(IBAction)btnDoneDidClicked:(id)sender;
-(IBAction)btnSelectPersonDidCliked:(id)sender;
@end

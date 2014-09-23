//
//  MCAAddStudParentViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 16/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCAAddStudParentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
    UITableView *tbl_StudGradeList;
         UIView *view_Bg;
        NSArray *arr_GradeList;
    
    IBOutlet UIView *view_stud;
    IBOutlet UIView *view_parent;
    
    IBOutlet UITextField *tx_studName;
    IBOutlet UITextField *tx_studEmail;
    IBOutlet UITextField *tx_studGrade;
    
    IBOutlet UITextField *tx_parName;
    IBOutlet UITextField *tx_parEmail;
    
    IBOutlet UIButton *btn_addParent;
    IBOutlet UIButton *btn_addStudent;
    
    IBOutlet UILabel *lbl_parName;
    IBOutlet UILabel *lbl_parEmail;
    
    IBOutlet UILabel *lbl_studName;
    IBOutlet UILabel *lbl_studEmail;
    IBOutlet UILabel *lbl_studGrade;
   
    AryaHUD *HUD;
    
}
-(IBAction)btnAddStudentDidClicked:(id)sender;
-(IBAction)btnAddParentDidClicked:(id)sender;

@end

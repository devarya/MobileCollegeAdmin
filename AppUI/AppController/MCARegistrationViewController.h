//
//  MCARegistrationViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 01/07/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCAStudentDHolder.h"
#import "MCACustomButton.h"

@interface MCARegistrationViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    
    UIScrollView *scrollV_parent;
    UIScrollView *scrollV_stud;
    
    UITableView *tbl_StudGradeList;
    UITableView *tbl_StudList;
    UITableView *tbl_SelectPerson;
    
    UIWindow    * tempWindow;

    IBOutlet UISegmentedControl *segControl_UserType;
    IBOutlet UIView *view_ParentSignup;
    IBOutlet UIView *view_StudentSignup;
    IBOutlet UIView *view_AddStudent;
             UIView *view_Bg;
             UIView *view_StudListBg;
    
    IBOutlet UITextField *tx_parentName;
    IBOutlet UITextField *tx_parentEmail;
    IBOutlet UITextField *tx_parentZipCode;
    IBOutlet UITextField *tx_parentPwd;
    IBOutlet UITextField *tx_parentConfirmPwd;
    
    IBOutlet UITextField *tx_studName;
    IBOutlet UITextField *tx_studEmail;
    IBOutlet UITextField *tx_studGrade;
    IBOutlet UITextField *tx_studZipCode;
    IBOutlet UITextField *tx_studPwd;
    IBOutlet UITextField *tx_studConfirmPwd;
    IBOutlet UITextField *tx_studSelectPerson;
    
    IBOutlet UITextField *tx_addStudName;
    IBOutlet UITextField *tx_addStudEmail;
    IBOutlet UITextField *tx_addStudGrade;
    
    IBOutlet UIButton *btn_studentList;
    IBOutlet UIButton *btn_addStudent;
    
    IBOutlet UIButton *btn_parentNotifyEmail;
    IBOutlet UIButton *btn_parentNotifyPush;
    IBOutlet UIButton *btn_studNotifyEmail;
    IBOutlet UIButton *btn_studNotifyPush;
    
    IBOutlet UIButton *btn_parentAccept;
    IBOutlet UIButton *btn_studAccept;
             UIButton *btn_keyboardDone;
    
    NSMutableArray *arr_StudentList;
           NSArray *arr_GradeList;
           NSArray *arr_SelectPersonList;
    
    NSString *json_StudString;
    
    AryaHUD *HUD;
}
-(IBAction)btnBackDidClicked:(id)sender;
-(IBAction)btnSegControl_UserTypeDidClicked:(id)sender;
-(IBAction)btnParentSignUpDidClicked:(id)sender;
-(IBAction)btnAddStudDidClicked:(id)sender;
-(IBAction)btnAddStudDetailDidClicked:(id)sender;
-(IBAction)btnCancelStudDetailDidClicked:(id)sender;
-(IBAction)btnParentNotifyPushDidCliked:(id)sender;
-(IBAction)btnParentNotifyEmailDidCliked:(id)sender;
-(IBAction)btnParentAcceptTermsDidCliked:(id)sender;

-(IBAction)btnStudSignUpDidClicked:(id)sender;
-(IBAction)btnStudNotifyPushDidCliked:(id)sender;
-(IBAction)btnStudNotifyEmailDidCliked:(id)sender;
-(IBAction)btnStudAcceptTermsDidCliked:(id)sender;
-(IBAction)btnSelectPersonDidCliked:(id)sender;
@end

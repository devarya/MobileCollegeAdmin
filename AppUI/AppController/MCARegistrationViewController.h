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
    
    UIWindow    *tempWindow;

    IBOutlet UINavigationBar *navBar;
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
    IBOutlet UIButton *btn_addS;
    IBOutlet UIButton *btn_cancelS;
    
    IBOutlet UIButton *btn_parentNotifyEmail;
    IBOutlet UIButton *btn_parentNotifyPush;
    IBOutlet UIButton *btn_studNotifyEmail;
    IBOutlet UIButton *btn_studNotifyPush;
    
    IBOutlet UIButton *btn_parentAccept;
    IBOutlet UIButton *btn_studAccept;
    IBOutlet UIButton *btn_pSignUp;
    IBOutlet UIButton *btn_sSignUp;
             UIButton *btn_keyboardDone;
    
    IBOutlet UILabel *lbl_parentName;
    IBOutlet UILabel *lbl_parentEmail;
    IBOutlet UILabel *lbl_myStud;
    IBOutlet UILabel *lbl_pPush;
    IBOutlet UILabel *lbl_pEmail;
    IBOutlet UILabel *lbl_pTOU;
    IBOutlet UILabel *lbl_title;
    IBOutlet UILabel *lbl_pZipCode;
    IBOutlet UILabel *lbl_pTaskAlert;
    IBOutlet UILabel *lbl_pPwd;
    
    IBOutlet UILabel *lbl_studName;
    IBOutlet UILabel *lbl_studEmail;
    IBOutlet UILabel *lbl_studGrade;
    IBOutlet UILabel *lbl_studFPerson;
    IBOutlet UILabel *lbl_sPush;
    IBOutlet UILabel *lbl_sEmail;
    IBOutlet UILabel *lbl_sTOU;
    IBOutlet UILabel *lbl_sZipCode;
    IBOutlet UILabel *lbl_sTaskAlert;
    IBOutlet UILabel *lbl_sPwd;
    
    IBOutlet UILabel *lbl_addSName;
    IBOutlet UILabel *lbl_addSEmail;
    IBOutlet UILabel *lbl_addSGrade;
    IBOutlet UILabel *lbl_etStudDetail;
    
    NSMutableArray *arr_StudentList;
           NSArray *arr_GradeList;
           NSArray *arr_SelectPersonList;
    
    NSString *json_StudString;
    AryaHUD *HUD;
}

#pragma mark - PARENT_SIGNUP_ACTION

-(IBAction)btnBackDidClicked:(id)sender;
-(IBAction)btnSegControl_UserTypeDidClicked:(id)sender;
-(IBAction)btnParentSignUpDidClicked:(id)sender;
-(IBAction)btnAddStudDidClicked:(id)sender;
-(IBAction)btnAddStudDetailDidClicked:(id)sender;
-(IBAction)btnCancelStudDetailDidClicked:(id)sender;
-(IBAction)btnParentNotifyPushDidCliked:(id)sender;
-(IBAction)btnParentNotifyEmailDidCliked:(id)sender;
-(IBAction)btnParentAcceptTermsDidCliked:(id)sender;

#pragma mark - STUDENT_SIGNUP_ACTION

-(IBAction)btnStudSignUpDidClicked:(id)sender;
-(IBAction)btnStudNotifyPushDidCliked:(id)sender;
-(IBAction)btnStudNotifyEmailDidCliked:(id)sender;
-(IBAction)btnStudAcceptTermsDidCliked:(id)sender;
-(IBAction)btnSelectPersonDidCliked:(id)sender;
@end

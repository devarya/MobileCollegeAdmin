//
//  MCARegistrationViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 01/07/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCARegistrationViewController.h"

@interface MCARegistrationViewController ()

@end

@implementation MCARegistrationViewController
{
    BOOL isParentNotifyPush;
    BOOL isParentNotifyEmail;
    BOOL isParentAcceptTerms;
    
    BOOL isStudNotifyPush;
    BOOL isStudNotifyEmail;
    BOOL isStudAcceptTerms;
    
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addStudentSuccess:) name:NOTIFICATION_USER_EXIST_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addStudentFailed:) name:NOTIFICATION_USER_EXIST_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parentSignUpSuccess:) name:NOTIFICATION_PARENT_SIGNUP_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parentSignUpFailed:) name:NOTIFICATION_PARENT_SIGNUP_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(studSignUpSuccess:) name:NOTIFICATION_STUD_SIGNUP_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(studSignUpFailed:) name:NOTIFICATION_STUD_SIGNUP_FAILED object:nil];
    
    arr_StudentList = [NSMutableArray new];
    arr_GradeList = [[NSArray alloc]initWithObjects:@"12th",@"11th",@"10th", nil];
    arr_SelectPersonList = [[NSArray alloc]initWithObjects:@"Me",@"My Parents",@"My Brother/Sister",@"My Grandparents",@"No idea", nil];
    
    [self setNeedsStatusBarAppearanceUpdate];
    segControl_UserType.tintColor=[UIColor whiteColor];
    
    view_ParentSignup.frame = CGRectMake(0, 96, 320, 568);
    view_StudentSignup.frame = CGRectMake(0, 96, 320, 568);
    
    scrollV_stud = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 96, view_StudentSignup.frame.size.width, view_StudentSignup.frame.size.height)];
    [scrollV_stud setContentInset:UIEdgeInsetsMake(-96, 0, 0, 0)];
    [scrollV_stud setContentSize:CGSizeMake(320, 1040)];
    [scrollV_stud addSubview:view_StudentSignup];
       
    scrollV_parent = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 96, view_ParentSignup.frame.size.width, view_ParentSignup.frame.size.height)];
    [scrollV_parent setContentInset:UIEdgeInsetsMake(-96, 0, 0, 0)];
    [scrollV_parent setContentSize:CGSizeMake(320, 980)];
    [scrollV_parent addSubview:view_ParentSignup];
    scrollV_parent.delegate = self;
    
    [segControl_UserType setSelectedSegmentIndex:0];
    [self btnSegControl_UserTypeDidClicked:nil];
    
    btn_studentList.layer.borderWidth=0.5f;
    btn_studentList.layer.borderColor=[UIColor colorWithRed:32.0/255.0 green:36.0/255.0 blue:48.0/255.0 alpha:1].CGColor;
    btn_studentList.layer.cornerRadius=3.0f;
    
    btn_addStudent.layer.borderWidth=0.5f;
    btn_addStudent.layer.borderColor=[UIColor colorWithRed:32.0/255.0 green:36.0/255.0 blue:48.0/255.0 alpha:1].CGColor;
    btn_addStudent.layer.cornerRadius=3.0f;
    
    [view_AddStudent removeFromSuperview];
    
    isParentNotifyPush = YES;
    isStudNotifyPush = YES;
    
    HUD=[AryaHUD new];
    [self.view addSubview:HUD];
//    [HUD show];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getLanguageStrings:nil];
    [super viewWillAppear:animated];
    
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self
           selector:@selector(keyboardWillShow:)
               name:UIKeyboardWillShowNotification
             object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification removeObserver:self
                  name:UIKeyboardWillShowNotification
                object:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tx_parentConfirmPwd resignFirstResponder];
    [tx_parentEmail resignFirstResponder];
    [tx_parentName resignFirstResponder];
    [tx_parentPwd resignFirstResponder];
    [tx_parentZipCode resignFirstResponder];
    
    [tbl_StudGradeList removeFromSuperview];
    [tbl_StudList removeFromSuperview];
    [tbl_SelectPerson removeFromSuperview];
    [view_StudListBg removeFromSuperview];
    
    [tx_addStudName resignFirstResponder];
    [tx_addStudEmail resignFirstResponder];
    
    if(segControl_UserType.selectedSegmentIndex == 1){
        
        [view_Bg removeFromSuperview];
    }
}

#pragma mark - LANGUAGE_SUPPORT

-(void)getLanguageStrings:(id)sender{
    
    self.navigationItem.title = [NSString languageSelectedStringForKey:@"fpassword"];
    
    lbl_parentName.text = [NSString languageSelectedStringForKey:@"pname"];
    lbl_parentEmail.text = [NSString languageSelectedStringForKey:@"pemail"];
    lbl_myStud.text = [NSString languageSelectedStringForKey:@"viewStudent"];
    
    lbl_push.text = [NSString languageSelectedStringForKey:@"chk_push"];
    lbl_email.text = [NSString languageSelectedStringForKey:@"chk_email"];
    lbl_TOU.text = [NSString languageSelectedStringForKey:@"terms"];
    lbl_zipCode.text = [NSString languageSelectedStringForKey:@"zip"];
    lbl_pwd.text = [NSString languageSelectedStringForKey:@"password"];
    lbl_taskAlert.text = [NSString languageSelectedStringForKey:@"notification"];
    
    tx_parentName.placeholder = [NSString languageSelectedStringForKey:@"et_name"];
    tx_parentEmail.placeholder = [NSString languageSelectedStringForKey:@"et_email"];
    tx_parentZipCode.placeholder = [NSString languageSelectedStringForKey:@"et_zipCode"];
    tx_parentPwd.placeholder = [NSString languageSelectedStringForKey:@"et_password"];
    
    [btn_signUp setTitle:[NSString languageSelectedStringForKey:@"btn_signup"] forState:UIControlStateNormal];
    [btn_addStudent setTitle:[NSString languageSelectedStringForKey:@"addStudent"] forState:UIControlStateNormal];
    [btn_studentList setTitle:[NSString languageSelectedStringForKey:@"viewST"] forState:UIControlStateNormal];
    
}

#pragma mark - KEYBOARD_METHOD

-(void)resignTextField{
    
    [btn_keyboardDone removeFromSuperview];
    
    [tx_parentConfirmPwd resignFirstResponder];
    [tx_parentEmail resignFirstResponder];
    [tx_parentName resignFirstResponder];
    [tx_parentPwd resignFirstResponder];
    [tx_parentZipCode resignFirstResponder];
    
    [tx_studName resignFirstResponder];
    [tx_studEmail resignFirstResponder];
    [tx_studGrade resignFirstResponder];
    [tx_studPwd resignFirstResponder];
    [tx_studConfirmPwd resignFirstResponder];
    [tx_studZipCode resignFirstResponder];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [btn_keyboardDone removeFromSuperview];
    
    if([textField isEqual:tx_parentName])
    {
        [scrollV_parent setContentOffset:CGPointMake(0, 90)];
        scrollV_parent.frame = CGRectMake(0, 96, 320, 568);
    }
    else if([textField isEqual:tx_parentEmail])
    {
        [scrollV_parent setContentOffset:CGPointMake(0, 180)];
        scrollV_parent.frame = CGRectMake(0, 96, 320, 568);
    }
    else if([textField isEqual:tx_parentZipCode])
    {
        [scrollV_parent setContentOffset:CGPointMake(0, 270)];
        scrollV_parent.frame = CGRectMake(0, 96, 320, 568);
        [self keyboardWillShow:nil];
    }
    else if([textField isEqual:tx_parentPwd])
    {
        [scrollV_parent setContentOffset:CGPointMake(0, 366)];
        scrollV_parent.frame = CGRectMake(0, 96, 320, 568);
    }
    else if([textField isEqual:tx_parentConfirmPwd])
    {
        [scrollV_parent setContentOffset:CGPointMake(0, 420)];
        scrollV_parent.frame = CGRectMake(0, 96, 320, 568);
//        scrollV_parent.backgroundColor = [UIColor redColor];
    }
    
    else if([textField isEqual:tx_studName])
    {
        [scrollV_stud setContentOffset:CGPointMake(0, 90)];
        scrollV_stud.frame = CGRectMake(0, 96, 320, 568);
    }
    else if([textField isEqual:tx_studEmail])
    {
        [scrollV_stud setContentOffset:CGPointMake(0, 180)];
        scrollV_stud.frame = CGRectMake(0, 96, 320, 568);
    }
    else if([textField isEqual:tx_studGrade])
    {
        [scrollV_stud setContentOffset:CGPointMake(0, 270)];
        scrollV_stud.frame = CGRectMake(0, 96, 320, 568);
    }
    else if([textField isEqual:tx_studZipCode])
    {
        [scrollV_stud setContentOffset:CGPointMake(0, 342)];
        scrollV_stud.frame = CGRectMake(0, 96, 320, 568);
        [self keyboardWillShow:nil];
        
    }
    else if ([textField isEqual:tx_studPwd])
    {
        [scrollV_stud setContentOffset:CGPointMake(0, 434)];
        scrollV_stud.frame = CGRectMake(0, 96, 320, 568);
    }
    else if([textField isEqual:tx_studConfirmPwd]){
        
        [scrollV_stud setContentOffset:CGPointMake(0, 486)];
        scrollV_stud.frame = CGRectMake(0, 96, 320, 568);
    }
    
    [tbl_StudGradeList removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (IS_IPHONE_5) {
        
        scrollV_parent.frame = CGRectMake(0, 96, 320, 568);
        scrollV_stud.frame = CGRectMake(0, 96, 320, 568);
        
    }else{
        scrollV_parent.frame = CGRectMake(0, 96, 320, 568);
        scrollV_stud.frame = CGRectMake(0, 96, 320, 568);
    }
 
    [textField resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // create custom button
    
    if (!notification) {
        
        [btn_keyboardDone removeFromSuperview];
        
        btn_keyboardDone = [UIButton buttonWithType:UIButtonTypeCustom];
        if (IS_IPHONE_5) {
            btn_keyboardDone.frame = CGRectMake(0, 514, 106, 53);
        }else{
            btn_keyboardDone.frame = CGRectMake(0, 427, 106, 53);
        }
        
        [btn_keyboardDone showsTouchWhenHighlighted];
        [btn_keyboardDone setTitle:@"Done" forState:UIControlStateNormal];
        [btn_keyboardDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_keyboardDone addTarget:self
                             action:@selector(btn_keyBoardDoneDidClicked:)
                   forControlEvents:UIControlEventTouchUpInside];
        
        btn_keyboardDone.tag = 3;
        // locate keyboard view
        tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
        [tempWindow addSubview:btn_keyboardDone];
        
    }
}
-(void)btn_keyBoardDoneDidClicked:(id)sender{
    
    UIButton *btntmp=sender;
    [btntmp removeFromSuperview];
    [tx_parentZipCode resignFirstResponder];
    [tx_studZipCode resignFirstResponder];
    
}

#pragma mark - IBACTION
-(IBAction)btnBackDidClicked:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)btnSegControl_UserTypeDidClicked:(id)sender{
    
    if (segControl_UserType.selectedSegmentIndex == 0) {
    
        view_ParentSignup.hidden = NO ;
        view_StudentSignup.hidden = YES ;
        [self.view addSubview:scrollV_parent];
        
    }else{
        
        view_ParentSignup.hidden = YES ;
        view_StudentSignup.hidden = NO ;
        [self.view addSubview:scrollV_stud];
    }
    
    [self resignTextField];
}
-(IBAction)btnParentSignUpDidClicked:(id)sender{
        
    tx_parentName.text = [tx_parentName.text stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tx_parentPwd.text = [tx_parentPwd.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tx_parentZipCode.text = [tx_parentZipCode.text stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tx_parentConfirmPwd.text = [tx_parentConfirmPwd.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![tx_parentName.text isEqualToString:@""])
    {
       if ([MCAValidation isValidEmailId:tx_parentEmail.text]&& ![tx_parentEmail.text isEqualToString:@""])
        {
           if (![tx_parentPwd.text isEqualToString:@""])
            {
                if (isParentAcceptTerms)
               {
                   NSMutableDictionary *info=[NSMutableDictionary new];
                   if (tx_parentZipCode.text.length != 0)
                   {
                       if (tx_parentZipCode.text.length == 5)
                       {
                           [info setValue:tx_parentZipCode.text forKey:@"zipcode"];
                           
                       }else{
                           
                           [MCAGlobalFunction showAlert:ZIP_CODE_MSG];
                           return;
                       }
                     }else{
                       [info setValue:@"" forKey:@"zipcode"];
                       
                     }

                    [info setValue:tx_parentEmail.text forKey:@"signin_id"];
                    [info setValue:tx_parentPwd.text forKey:@"pwd"];
                    
                     if (json_StudString) {
                         
                         [info setValue:json_StudString forKey:@"students"];
                     }else{
                         [info setValue:@"[]" forKey:@"students"];
                     }
                    [info setValue:tx_parentName.text forKey:@"user_name"];
                     
                   
                    [info setValue:@"p" forKey:@"user_type"];
                    
                    if (isParentNotifyPush) {
                        [info setValue:@"1" forKeyPath:@"notify_by_push"];
                    }else{
                        [info setValue:@"0" forKeyPath:@"notify_by_push"];
                    }
                    
                    if (isParentNotifyEmail) {
                        [info setValue:@"1" forKeyPath:@"notify_by_email"];
                    }else{
                        [info setValue:@"0" forKeyPath:@"notify_by_email"];
                    }
                   
                  [info setValue:@"ios" forKey:@"device_type"];
                  [info setValue:@"user_register" forKey:@"cmd"];
                   
                   NSString *str_jsonParent = [NSString getJsonObject:info];
                   str_jsonParent = [str_jsonParent stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                   str_jsonParent = [str_jsonParent stringByReplacingOccurrencesOfString:@": \"\[" withString:@":["];
                   str_jsonParent = [str_jsonParent stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
                   
                   for (UIView* subV in tempWindow.subviews) {
                       if ([subV isKindOfClass:[UIButton class]])
                           [subV removeFromSuperview];
                   }
                   
                   [self resignTextField];
                   
                   [HUD show];
                   [self.view bringSubviewToFront:HUD];
                   [self requestParentSignUp:str_jsonParent];
            
              }else{
                [MCAGlobalFunction showAlert:ACCEPT_TERM_MESSAGE];
             }
        }else{
            [MCAGlobalFunction showAlert:INVALID_PWD];
        }
      }else{
         [MCAGlobalFunction showAlert:EMAIL_MESSAGE];
       }
    }else{
       [MCAGlobalFunction showAlert:INVALID_USERNAME];
    }
}
-(IBAction)btnStudSignUpDidClicked:(id)sender{
    
    [self.view addSubview:HUD];
    
    tx_studName.text = [tx_studName.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tx_studPwd.text = [tx_studPwd.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tx_studZipCode.text = [tx_studZipCode.text stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tx_studConfirmPwd.text = [tx_studConfirmPwd.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![tx_studName.text isEqualToString:@""])
    {
      if ([MCAValidation isValidEmailId:tx_studEmail.text]&&![tx_studEmail.text isEqualToString:@""])
       {
        if (![tx_studPwd.text isEqualToString:@""])
          {
           if (![tx_studGrade.text isEqualToString:@""] && ![tx_studSelectPerson.text isEqualToString:@""])
            {
              if (isStudAcceptTerms)
               {
                   NSMutableDictionary *info=[NSMutableDictionary new];
                   if (tx_studZipCode.text.length != 0)
                   {
                      if (tx_studZipCode.text.length == 5)
                      {
                            [info setValue:tx_studZipCode.text forKey:@"zipcode"];
                          
                       }else{
                           
                           [MCAGlobalFunction showAlert:ZIP_CODE_MSG];
                            return;
                        }
                    }else{
                        [info setValue:@"" forKey:@"zipcode"];
                    }
                   
                    [info setValue:tx_studEmail.text forKey:@"signin_id"];
                    [info setValue:tx_studPwd.text forKey:@"pwd"];
                    [info setValue:tx_studSelectPerson.text forKey:@"family"];
                    [info setValue:tx_studName.text forKey:@"user_name"];
                    tx_studGrade.text = [tx_studGrade.text stringByReplacingOccurrencesOfString:@"th" withString:@""];
                    [info setValue:tx_studGrade.text forKey:@"grade"];
                    [info setValue:@"s" forKey:@"user_type"];
                    
                    if (isStudNotifyPush) {
                        [info setValue:@"1" forKeyPath:@"notify_by_push"];
                    }else{
                        [info setValue:@"0" forKeyPath:@"notify_by_push"];
                    }
                    
                    if (isStudNotifyEmail) {
                        [info setValue:@"1" forKeyPath:@"notify_by_email"];
                    }else{
                        [info setValue:@"0" forKeyPath:@"notify_by_email"];
                    }
                    [info setValue:@"ios" forKey:@"device_type"];
                    [info setValue:@"user_register" forKey:@"cmd"];
               
                    NSString *str_jsonStud = [NSString getJsonObject:info];
                   
                    [HUD show];
                   for (UIView* subV in tempWindow.subviews) {
                       if ([subV isKindOfClass:[UIButton class]])
                           [subV removeFromSuperview];
                   }
                   
                    [self resignTextField];
                    [btn_keyboardDone removeFromSuperview];
                    [self requestStudentSignUp:str_jsonStud];
                
              }else{
                [MCAGlobalFunction showAlert:ACCEPT_TERM_MESSAGE];
            }
          }else{
              [MCAGlobalFunction showAlert:@"Please select Grade and Person."];
          }
        }else{
             [MCAGlobalFunction showAlert:INVALID_PWD];
        }
    }else{            
          [MCAGlobalFunction showAlert:EMAIL_MESSAGE];
      }
    }else{
       [MCAGlobalFunction showAlert:INVALID_USERNAME];
    }
}
-(IBAction)btnCancelStudDetailDidClicked:(id)sender{
    
    tx_addStudEmail.text = @"";
    tx_addStudGrade.text = @"";
    tx_addStudName.text = @"";
    
    [view_AddStudent removeFromSuperview];
    [view_Bg removeFromSuperview];
    
}
-(IBAction)btnGradeDidClicked:(id)sender{
    
    if(segControl_UserType.selectedSegmentIndex == 0) {
        
        tbl_StudGradeList = [[UITableView alloc]initWithFrame:CGRectMake(12, 228, 298, 110)];
        [tx_addStudName resignFirstResponder];
        [tx_addStudEmail resignFirstResponder];

    }else{
        
        if (IS_IPHONE_5) {
            view_Bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
        }else{
            view_Bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        }
        
        view_Bg.backgroundColor = [UIColor blackColor];
        view_Bg.layer.opacity = 0.6f;
        [self.view addSubview:view_Bg];
        tbl_StudGradeList = [[UITableView alloc]initWithFrame:CGRectMake(12, 102, 298, 110)];
    }
    tbl_StudGradeList.layer.borderWidth = 0.5f;
    tbl_StudGradeList.layer.cornerRadius = 3.0f;
    [self.view addSubview:tbl_StudGradeList];
    [self.view bringSubviewToFront:tbl_StudGradeList];
    
//    tbl_StudGradeList.backgroundColor = [UIColor redColor];
    tbl_StudGradeList.delegate = self;
    tbl_StudGradeList.dataSource = self;
    [tbl_StudGradeList reloadData];
    
    [self resignTextField];
}
-(IBAction)btnViewStudDidClicked:(id)sender{
    
    if (arr_StudentList.count>0)
    {
        if (IS_IPHONE_5) {
            view_StudListBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
        }else{
            view_StudListBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        }
        
        view_StudListBg.backgroundColor = [UIColor blackColor];
        view_StudListBg.layer.opacity = 0.6f;
        [self.view addSubview:view_StudListBg];
        
        tbl_StudList = [[UITableView alloc]initWithFrame:CGRectMake(10, 228, 302, 138)];
        tbl_StudList.layer.borderWidth = 0.5f;
        tbl_StudList.layer.cornerRadius = 3.0f;
        [self.view addSubview:tbl_StudList];
    //    [self.view bringSubviewToFront:tbl_StudList];
        
    //    tbl_StudList.backgroundColor = [UIColor redColor];
        tbl_StudList.delegate = self;
        tbl_StudList.dataSource = self;
     
             [tbl_StudList reloadData];
    }else{
       
        [MCAGlobalFunction showAlert:@"No Student Connected."];
        
    }
    [self resignTextField];
}

-(IBAction)btnAddStudDidClicked:(id)sender{
    
    if (IS_IPHONE_5) {
        view_Bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
         view_Bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    view_Bg.backgroundColor = [UIColor blackColor];
    view_Bg.layer.opacity = 0.6f;
    [self.view addSubview:view_Bg];

    view_AddStudent.frame = CGRectMake(10, 102, view_AddStudent.frame.size.width, view_AddStudent.frame.size.height);
    view_AddStudent.layer.borderWidth = 0.5f;
    view_AddStudent.layer.cornerRadius = 3.0f;
    view_AddStudent.layer.masksToBounds = YES;
    view_AddStudent.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:view_AddStudent];
    [self resignTextField];

}
-(IBAction)btnAddStudDetailDidClicked:(id)sender{
    
if (![tx_addStudEmail.text isEqualToString:@""]&&![tx_addStudGrade.text isEqualToString:@""] && ![tx_addStudName.text isEqualToString:@""])
  {
    if (![tx_addStudEmail.text isEqualToString:@""]&&[MCAValidation isValidEmailId:tx_addStudEmail.text])
    {
            NSMutableDictionary *info=[NSMutableDictionary new];
            [info setValue:tx_addStudEmail.text forKey:@"signin_id"];
            
            [info setValue:@"user_exists" forKey:@"cmd"];
        
            NSString *str_jsonUserExist = [NSString getJsonObject:info];
            [HUD show];
            [self.view bringSubviewToFront:HUD];
            [self requestAddStudent:str_jsonUserExist];
    }else{
        
        [MCAGlobalFunction showAlert:EMAIL_MESSAGE];
    }
  }else{
        
        [MCAGlobalFunction showAlert:MANDATORY_MESSAGE];
    }
}
-(IBAction)btnParentNotifyPushDidCliked:(id)sender{
    
    if (isParentNotifyPush) {
        
        [btn_parentNotifyPush setImage:[UIImage imageNamed:@"unCheckmark.png"] forState:UIControlStateNormal];
        isParentNotifyPush = NO;
        btn_parentNotifyPush.tag = 0;
        
    }else{
        
        [btn_parentNotifyPush setImage:[UIImage imageNamed:@"checkMark.png"] forState:UIControlStateNormal];
        isParentNotifyPush = YES;
        btn_parentNotifyPush.tag = 1;
    }
}
-(IBAction)btnParentNotifyEmailDidCliked:(id)sender{
    
    if (isParentNotifyEmail) {
        
        [btn_parentNotifyEmail setImage:[UIImage imageNamed:@"unCheckmark.png"] forState:UIControlStateNormal];
        isParentNotifyEmail = NO;
        btn_parentNotifyEmail.tag = 0;
        
    }else{
        
        [btn_parentNotifyEmail setImage:[UIImage imageNamed:@"checkMark.png"] forState:UIControlStateNormal];
        isParentNotifyEmail = YES;
        btn_parentNotifyEmail.tag = 1;
    }
}

-(IBAction)btnStudNotifyPushDidCliked:(id)sender{
    
    if (isStudNotifyPush) {
        
        [btn_studNotifyPush setImage:[UIImage imageNamed:@"unCheckmark.png"] forState:UIControlStateNormal];
        isStudNotifyPush = NO;
        btn_studNotifyPush.tag = 0;
        
    }else{
        
        [btn_studNotifyPush setImage:[UIImage imageNamed:@"checkMark.png"] forState:UIControlStateNormal];
        isStudNotifyPush = YES;
        btn_studNotifyPush.tag = 1;
    }
}
-(IBAction)btnStudNotifyEmailDidCliked:(id)sender{
    
    if (isStudNotifyEmail) {
        
        [btn_studNotifyEmail setImage:[UIImage imageNamed:@"unCheckmark.png"] forState:UIControlStateNormal];
        isStudNotifyEmail = NO;
        btn_studNotifyEmail.tag = 0;
        
    }else{
        
        [btn_studNotifyEmail setImage:[UIImage imageNamed:@"checkMark.png"] forState:UIControlStateNormal];
        isStudNotifyEmail = YES;
        btn_studNotifyEmail.tag = 1;
    }
}
-(IBAction)btnParentAcceptTermsDidCliked:(id)sender{
    
    if (isParentAcceptTerms) {
         [btn_parentAccept setImage:[UIImage imageNamed:@"unCheckmark.png"] forState:UIControlStateNormal];
         isParentAcceptTerms = NO;
    }else{
         [btn_parentAccept setImage:[UIImage imageNamed:@"checkMark.png"] forState:UIControlStateNormal];
         isParentAcceptTerms = YES;
    }
}
-(IBAction)btnStudAcceptTermsDidCliked:(id)sender{
    
    if (isStudAcceptTerms) {
        [btn_studAccept setImage:[UIImage imageNamed:@"unCheckmark.png"] forState:UIControlStateNormal];
        isStudAcceptTerms = NO;
    }else{
        [btn_studAccept setImage:[UIImage imageNamed:@"checkMark.png"] forState:UIControlStateNormal];
        isStudAcceptTerms = YES;
    }
}
-(IBAction)btnSelectPersonDidCliked:(id)sender{
    
    if (IS_IPHONE_5) {
        view_StudListBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        view_StudListBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    view_StudListBg.backgroundColor = [UIColor blackColor];
    view_StudListBg.layer.opacity = 0.6f;
    [self.view addSubview:view_StudListBg];
    
    tbl_SelectPerson = [[UITableView alloc]initWithFrame:CGRectMake(10, 228, 302, 164)];
    tbl_SelectPerson.layer.borderWidth = 0.5f;
    tbl_SelectPerson.layer.cornerRadius = 3.0f;
    [self.view addSubview:tbl_SelectPerson];
   
    tbl_SelectPerson.delegate = self;
    tbl_SelectPerson.dataSource = self;
    [tbl_SelectPerson reloadData];
    
    [self resignTextField];
    
}

#pragma mark - UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
   return 26;
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == tbl_StudList) {
      
        return 28;
    }else{
        
        return 28;
    }
   
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == tbl_StudGradeList) {
        // 1. The view for the header
        
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,30)];
        
        // 2. Set a custom background color and a border
        headerView.backgroundColor = [UIColor colorWithRed:31.0/255 green:37.0/255 blue:48.0/255 alpha:1];
        
        // 3. Add an image
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(0, 0,tableView.frame.size.width,22);
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        headerLabel.text = @"Select Grade";
        headerLabel.textAlignment = NSTextAlignmentCenter;
        
        [headerView addSubview:headerLabel];
        
        // 5. Finally return
        return headerView;
    }else if(tableView == tbl_StudList){
        
        // 1. The view for the header
        
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tbl_StudList.frame.size.width,30)];
        
        // 2. Set a custom background color and a border
        headerView.backgroundColor = [UIColor colorWithRed:31.0/255 green:37.0/255 blue:48.0/255 alpha:1];
        
        // 3. Add an image
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(12,2,298,22);
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        headerLabel.text = @"Student List";
        headerLabel.textAlignment = NSTextAlignmentCenter;
        
        [headerView addSubview:headerLabel];
        
        // 5. Finally return
        return headerView;
    }else{
        
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tbl_SelectPerson.frame.size.width,30)];
        
        // 2. Set a custom background color and a border
        headerView.backgroundColor = [UIColor colorWithRed:31.0/255 green:37.0/255 blue:48.0/255 alpha:1];
        
        // 3. Add an image
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(12,2,298,22);
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        headerLabel.text = @"Select Person";
        headerLabel.textAlignment = NSTextAlignmentCenter;
        
        [headerView addSubview:headerLabel];
        
        // 5. Finally return
        return headerView;
       
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    if (tableView == tbl_StudList) {
        return YES;
    }else{
        
        return NO;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [arr_StudentList removeObjectAtIndex:indexPath.row];
        [tbl_StudList reloadData];
        
        [self addStudentSuccess:nil];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tbl_StudGradeList) {
         return arr_GradeList.count;
    }
    else if(tableView == tbl_StudList){
        return arr_StudentList.count;
    }else{
         return arr_SelectPersonList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tbl_StudGradeList) {
        
        NSString *cellIdentifier =@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:cellIdentifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.textLabel.text = [arr_GradeList objectAtIndex:indexPath.row];
        tbl_StudGradeList.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
        return cell;

    }else if(tableView == tbl_StudList){
      
        NSString *cellIdentifier =@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:cellIdentifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.textLabel.text = [[arr_StudentList valueForKey:@"user_name"] objectAtIndex:indexPath.row];
     
//         MCACustomButton *btn_studDelete = [MCACustomButton buttonWithType:UIButtonTypeCustom];
//         btn_studDelete.frame = CGRectMake(260, 2, 22, 22);
//         [btn_studDelete setImage:[UIImage imageNamed:@"delete2.png"]
//                         forState:UIControlStateNormal];
//         [btn_studDelete addTarget:self
//                   action:@selector(btn_deleteStudDidClicked:)
//         forControlEvents:UIControlEventTouchUpInside];
//         btn_studDelete.index = indexPath.row;
//         [cell addSubview:btn_studDelete];
         tbl_StudList.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
         return cell;

    }else{
      
        NSString *cellIdentifier =@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:cellIdentifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.textLabel.text = [arr_SelectPersonList objectAtIndex:indexPath.row];
        tbl_SelectPerson.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == tbl_StudGradeList)
    {
        if (segControl_UserType.selectedSegmentIndex == 0) {
            tx_addStudGrade.text = [arr_GradeList objectAtIndex:indexPath.row];
            [tbl_StudGradeList removeFromSuperview];
        }
        else{
            tx_studGrade.text = [arr_GradeList objectAtIndex:indexPath.row];
            [tbl_StudGradeList removeFromSuperview];
            [view_Bg removeFromSuperview];
        }
    }else if(tableView == tbl_StudList){
        
      
    }else{
        tx_studSelectPerson.text = [arr_SelectPersonList objectAtIndex:indexPath.row];
        [tbl_SelectPerson removeFromSuperview];
        [view_StudListBg removeFromSuperview];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (scrollView == scrollV_parent) {
        [tbl_StudList removeFromSuperview];
        [view_Bg removeFromSuperview];
    }
}
-(void)btn_deleteStudDidClicked:(id)sender{
    
    MCACustomButton *btn_tmp = (MCACustomButton *)sender;
    
    [arr_StudentList removeObjectAtIndex:btn_tmp.index];
    [tbl_StudList reloadData];
    
    [self addStudentSuccess:nil];
}
#pragma mark - API CALLING

-(void)requestAddStudent:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForUserExist:info];
    }else{
        [HUD hide];
        [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"noInternetMsg"]];
    }
}
-(void)requestParentSignUp:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForParentSignUp:info];
    }else{
        [HUD hide];
        [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"noInternetMsg"]];
    }
}
-(void)requestStudentSignUp:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForStudentSignUp:info];
    }else{
        [HUD hide];
        [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"noInternetMsg"]];
    }
}

#pragma mark - NSNOTIFICATION SELECTOR

-(void)addStudentSuccess:(NSNotification*)notification{
    
    [HUD hide];
    
    NSMutableDictionary *dict_Student =[NSMutableDictionary new];
    [dict_Student setValue:tx_addStudEmail.text forKey:@"signin_id"];
    tx_addStudGrade.text = [tx_addStudGrade.text stringByReplacingOccurrencesOfString:@"th" withString:@""];
    [dict_Student setValue:tx_addStudGrade.text forKey:@"grade"];
    [dict_Student setValue:tx_addStudName.text forKey:@"user_name"];
    [dict_Student setValue:@"" forKey:@"user_id"];
    [dict_Student setValue:@"s" forKey:@"user_type"];
    
    if (tx_addStudEmail.text.length > 0) {
        
         [arr_StudentList addObject:dict_Student];
    }
    
//    NSError* error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr_StudentList
//                                                        options:NSJSONWritingPrettyPrinted
//                                                          error:&error];
//    
//    json_StudString = [[NSString alloc] initWithData:jsonData
//                                            encoding:NSUTF8StringEncoding];
//    json_StudString = [json_StudString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    
//    json_StudString = [json_StudString stringByReplacingOccurrencesOfString:@" " withString:@""];
//    json_StudString = [json_StudString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    json_StudString = [NSString getJsonArray:arr_StudentList];
       
    [view_Bg removeFromSuperview];
    [view_AddStudent removeFromSuperview];
    
    tx_addStudEmail.text = @"";
    tx_addStudGrade.text = @"";
    tx_addStudName.text = @"";

}
-(void)addStudentFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}
-(void)parentSignUpSuccess:(NSNotification*)notification{
    
    [HUD hide];
    MCASignUpDHolder *signUpDHolder = notification.object;
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_userId forKey:KEY_USER_ID];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_signinId forKey:KEY_SIGNIN_ID];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_userType forKey:KEY_USER_TYPE];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_zipCode forKey:KEY_USER_ZIPCODE];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_userName forKey:KEY_USER_NAME];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_family forKey:KEY_USER_FAMILY];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_grade forKey:KEY_USER_GRADE];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_userToken forKey:KEY_USER_TOKEN];
    [[NSUserDefaults standardUserDefaults]setInteger:signUpDHolder.arr_StudentData.count forKey:KEY_STUDENT_COUNT];
     if (![signUpDHolder.str_lang isKindOfClass:[NSNull class]]) {
         [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_lang forKey:KEY_LANGUAGE_CODE];
    }

    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_notifyByPush forKey:KEY_NOTIFY_BY_PUSH];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_notifyByMail forKey:KEY_NOTIFY_BY_EMAIL];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_priorityHigh forKey:KEY_PRIORITY_HIGH];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_priorityRegular forKey:KEY_PRIORITY_REGULAR];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self performSegueWithIdentifier:@"signUpTabBarSegue" sender:self];
    
}
-(void)parentSignUpFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}
-(void)studSignUpSuccess:(NSNotification*)notification{
   
    [HUD hide];
    MCASignUpDHolder *signUpDHolder = notification.object;
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_userId forKey:KEY_USER_ID];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_signinId forKey:KEY_SIGNIN_ID];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_userType forKey:KEY_USER_TYPE];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_zipCode forKey:KEY_USER_ZIPCODE];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_userName forKey:KEY_USER_NAME];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_family forKey:KEY_USER_FAMILY];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_grade forKey:KEY_USER_GRADE];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_userToken forKey:KEY_USER_TOKEN];
    [[NSUserDefaults standardUserDefaults]setInteger:signUpDHolder.arr_StudentData.count forKey:KEY_STUDENT_COUNT];
    if (![signUpDHolder.str_lang isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_lang forKey:KEY_LANGUAGE_CODE];
    }
    
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_notifyByPush forKey:KEY_NOTIFY_BY_PUSH];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_notifyByMail forKey:KEY_NOTIFY_BY_EMAIL];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_priorityHigh forKey:KEY_PRIORITY_HIGH];
    [[NSUserDefaults standardUserDefaults]setValue:signUpDHolder.str_priorityRegular forKey:KEY_PRIORITY_REGULAR];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self performSegueWithIdentifier:@"signUpTabBarSegue" sender:self];
    
}
-(void)studSignUpFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
    
}
#pragma mark OTHER_METHOD
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"signUpTabBarSegue"]) {
        
        [[MCAGlobalData sharedManager]goToTabbarView:segue];
    }
}
@end

//
//  MCAAddStudParentViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 16/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAAddStudParentViewController.h"

@interface MCAAddStudParentViewController ()

@end

@implementation MCAAddStudParentViewController

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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addParentSuccess:) name:NOTIFICATION_ADD_PARENT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addParentFailed:) name:NOTIFICATION_ADD_PARENT_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addStudentSuccess:) name:NOTIFICATION_ADD_STUDENT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addStudentFailed:) name:NOTIFICATION_ADD_STUDENT_FAILED object:nil];
    
    HUD = [AryaHUD new];
    [self.view addSubview:HUD];
    
    view_parent.hidden = YES;
    view_stud.hidden = YES;
    
    arr_GradeList = [[NSArray alloc]initWithObjects:@"12th",@"11th",@"10th", nil];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"]) {
        
        view_stud.hidden = NO;
        view_stud.frame = CGRectMake(view_stud.frame.origin.x, 0, view_stud.frame.size.width, view_stud.frame.size.height);
        self.navigationItem.title = @"Add Student";
            
    }else{
        
        view_parent.hidden = NO;
        view_parent.frame = CGRectMake(view_parent.frame.origin.x, 0, view_parent.frame.size.width, view_parent.frame.size.height);
        self.navigationItem.title = @"Add Parent";
    }
    
    btn_addParent.layer.cornerRadius = 5.0f;
    btn_addParent.layer.masksToBounds = YES;
    
    btn_addStudent.layer.cornerRadius = 5.0f;
    btn_addStudent.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignTextField:nil];
    [view_Bg removeFromSuperview];
    [tbl_StudGradeList removeFromSuperview];
}
-(void)resignTextField:(id)sender{
    
    [tx_parEmail resignFirstResponder];
    [tx_parName resignFirstResponder];
    [tx_studEmail resignFirstResponder];
    [tx_studGrade resignFirstResponder];
    [tx_studName resignFirstResponder];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - IB_ACTION

-(IBAction)btnGradeDidClicked:(id)sender{
    
    [tx_studEmail resignFirstResponder];
    [tx_studName resignFirstResponder];
    
    if (IS_IPHONE_5) {
        view_Bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        view_Bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    view_Bg.backgroundColor = [UIColor blackColor];
    view_Bg.layer.opacity = 0.6f;
    [self.view addSubview:view_Bg];
    tbl_StudGradeList = [[UITableView alloc]initWithFrame:CGRectMake(10, 102, 300, 130)];
 
    tbl_StudGradeList.layer.borderWidth = 0.5f;
    [self.view addSubview:tbl_StudGradeList];
    [self.view bringSubviewToFront:tbl_StudGradeList];
    
    //    tbl_StudGradeList.backgroundColor = [UIColor redColor];
    tbl_StudGradeList.delegate = self;
    tbl_StudGradeList.dataSource = self;
    [tbl_StudGradeList reloadData];
    
}
-(IBAction)btnAddStudentDidClicked:(id)sender{
    
    if (![tx_studName.text isEqualToString:@""] && ![tx_studEmail.text isEqualToString:@""] && ![tx_studGrade.text isEqualToString:@""]) {
        
        if ([MCAValidation isValidEmailId:tx_studEmail.text]) {
           
            NSMutableDictionary *dict_Student =[NSMutableDictionary new];
            [dict_Student setValue:tx_studEmail.text forKey:@"signin_id"];
            [dict_Student setValue:[tx_studGrade.text stringByReplacingOccurrencesOfString:@"th" withString:@""] forKey:@"grade"];
            [dict_Student setValue:tx_studName.text forKey:@"user_name"];
            [dict_Student setValue:@"" forKey:@"user_id"];
            [dict_Student setValue:@"s" forKey:@"user_type"];
            [dict_Student setValue:@"1" forKey:@"notify_by_push"];
            [dict_Student setValue:@"1" forKey:@"notify_by_email"];
            [dict_Student setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID] forKey:@"parent_id"];
            
            NSMutableArray *arr_student = [NSMutableArray new];
            [arr_student addObject:dict_Student];
            
            NSString *str_jsonStudent = [NSString getJsonArray:arr_student];
            
            NSMutableDictionary * info = [NSMutableDictionary new];
            [info setValue:@"child_parent_registration" forKey:@"cmd"];
            [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_NAME] forKey:@"user_name"];
            [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] forKey:@"user_type"];
            [info setValue:str_jsonStudent forKey:@"student"];
            
            
            NSString *str_jsonAddStudent = [NSString getJsonObject:info];
            
         str_jsonAddStudent = [str_jsonAddStudent stringByReplacingOccurrencesOfString:@"\\" withString:@""];
         str_jsonAddStudent = [str_jsonAddStudent stringByReplacingOccurrencesOfString:@": \"\[" withString:@":["];
         str_jsonAddStudent = [str_jsonAddStudent stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
            
            [HUD showForTabBar];
           [self requestAddStudent:str_jsonAddStudent];
            
            
        }else{
            
        }
    }else{
        
        [MCAGlobalFunction showAlert:MANDATORY_MESSAGE];
    }
}
-(IBAction)btnAddParentDidClicked:(id)sender{
    
    if (![tx_parEmail.text isEqualToString:@""] && ![tx_parName.text isEqualToString:@""]) {
        
        if ([MCAValidation isValidEmailId:tx_parEmail.text]) {
            
            NSMutableDictionary *dict_Parent =[NSMutableDictionary new];
            [dict_Parent setValue:tx_parEmail.text forKey:@"signin_id"];
            [dict_Parent setValue:tx_parName.text forKey:@"user_name"];
            [dict_Parent setValue:@"p" forKey:@"user_type"];
            [dict_Parent setValue:@"1" forKey:@"notify_by_push"];
            [dict_Parent setValue:@"1" forKey:@"notify_by_email"];
            [dict_Parent setValue:@"" forKey:@"user_id"];
            
            NSMutableArray *arr_parent= [NSMutableArray new];
            [arr_parent addObject:dict_Parent];
            
            NSString *str_jsonParent = [NSString getJsonArray:arr_parent];
            
            NSMutableDictionary * info = [NSMutableDictionary new];
            [info setValue:@"child_parent_registration" forKey:@"cmd"];
            [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_NAME] forKey:@"user_name"];
            [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] forKey:@"user_type"];
            [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_GRADE] forKey:@"grade"];
            [info setValue:str_jsonParent forKey:@"parent"];
            
            
            NSString *str_jsonAddParent = [NSString getJsonObject:info];
            
            str_jsonAddParent = [str_jsonAddParent stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            str_jsonAddParent = [str_jsonAddParent stringByReplacingOccurrencesOfString:@": \"\[" withString:@":["];
            str_jsonAddParent = [str_jsonAddParent stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
            
            [HUD showForTabBar];
            [self requestAddParent:str_jsonAddParent];
            
            
        }else{
            
        }
    }else{
        
        [MCAGlobalFunction showAlert:MANDATORY_MESSAGE];
    }
}

#pragma mark - UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 34;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 32;
   
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,34)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1];
    
    // 3. Add an image
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(0,0,tableView.frame.size.width,34);
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.text = @"Select Grade";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:headerLabel];
    
    // 5. Finally return
    return headerView;
 }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      return arr_GradeList.count;
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    cell = [[UITableViewCell alloc]
        initWithStyle:UITableViewCellStyleDefault
        reuseIdentifier:cellIdentifier];

    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = [arr_GradeList objectAtIndex:indexPath.row];
    tbl_StudGradeList.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tx_studGrade.text = [arr_GradeList objectAtIndex:indexPath.row];
//    tx_studGrade.text = [tx_studGrade.text stringByAppendingString:@"th"];
    [view_Bg removeFromSuperview];
    [tbl_StudGradeList removeFromSuperview];
}

#pragma mark - API CALLING

-(void)requestAddStudent:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForAddStudent:info];
    }else{
        [HUD hide];
        [MCAGlobalFunction showAlert:NET_NOT_AVAIALABLE];
    }
}
-(void)requestAddParent:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForAddParent:info];
    }else{
        [HUD hide];
        [MCAGlobalFunction showAlert:NET_NOT_AVAIALABLE];
    }
}
#pragma mark - NSNOTIFICATION SELECTOR

-(void)addParentSuccess:(NSNotification*)notification{
    
    [HUD hide];
    
    MCALoginDHolder *loginDHolder = notification.object;
    [[NSUserDefaults standardUserDefaults]setInteger:loginDHolder.arr_StudentData.count forKey:KEY_STUDENT_COUNT];
    [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_notifyByMail forKey:KEY_NOTIFY_BY_EMAIL];
    [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_notifyByPush forKey:KEY_NOTIFY_BY_PUSH];
    [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_priorityHigh forKey:KEY_PRIORITY_HIGH];
    [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_priorityRegular forKey:KEY_PRIORITY_REGULAR];
    [[NSUserDefaults standardUserDefaults]synchronize];

    UIAlertView *alert   = [[UIAlertView alloc]initWithTitle:@"Message"
                                                     message:@"Parent connected successfully."
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil, nil];
    [alert show];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),^ {
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}
-(void)addParentFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}
-(void)addStudentSuccess:(NSNotification*)notification{
    
    [HUD hide];
    
    MCALoginDHolder *loginDHolder = notification.object;
    [[NSUserDefaults standardUserDefaults]setInteger:loginDHolder.arr_StudentData.count forKey:KEY_STUDENT_COUNT];
    [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_notifyByMail forKey:KEY_NOTIFY_BY_EMAIL];
    [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_notifyByPush forKey:KEY_NOTIFY_BY_PUSH];
    [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_priorityHigh forKey:KEY_PRIORITY_HIGH];
    [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_priorityRegular forKey:KEY_PRIORITY_REGULAR];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIAlertView *alert   = [[UIAlertView alloc]initWithTitle:@"Message"
                                                     message:@"Student connected successfully."
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil, nil];
    [alert show];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),^ {
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}
-(void)addStudentFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}

@end

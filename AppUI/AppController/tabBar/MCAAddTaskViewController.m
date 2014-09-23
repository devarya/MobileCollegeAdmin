//
//  MCAAddTaskViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 09/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAAddTaskViewController.h"
#import "Reachability.h"
@interface MCAAddTaskViewController ()
@end

@implementation MCAAddTaskViewController
@synthesize taskEditDHolder,delegate;

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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addTaskSuccess:) name:NOTIFICATION_ADD_TASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addTaskFailed:) name:NOTIFICATION_ADD_TASK_FAILED object:nil];
    
    [[NSUserDefaults standardUserDefaults]setInteger:3 forKey:KEY_ANIMATION_FILE_RAND_NO];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //Arya HUD
    HUD=[AryaHUD new];
    [self.view addSubview:HUD];
    
    tv_description.layer.borderWidth = 0.5f;
    tv_description.layer.cornerRadius = 3.0f;
    tv_description.layer.masksToBounds = YES;
    
    NSUInteger numberOfViewControllersOnStack = [self.navigationController.viewControllers count];
    UIViewController *parentViewController = self.navigationController.viewControllers[numberOfViewControllersOnStack - 2];
    Class parentVCClass = [parentViewController class];
    className = NSStringFromClass(parentVCClass);
    
       //check for reachability change
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(reachabilityStatusChange:)
//                                                name:kReachabilityChangedNotification
//                                              object:nil];
    
    

}
-(void)viewWillAppear:(BOOL)animated{
        
    if ([className isEqualToString:@"MCATaskViewController"]){
        
        self.navigationItem.title = [NSString languageSelectedStringForKey:@"t_header"];
        
        tv_description.text = [NSString languageSelectedStringForKey:@"description"];
        tv_description.textColor = [UIColor lightGrayColor];
        
    }else{
        
        self.navigationItem.title = [NSString languageSelectedStringForKey:@"edit_headr"];
        
        if ([taskEditDHolder.str_taskPriority isEqualToString:@"h"]) {
            
            tx_priority.text = [NSString languageSelectedStringForKey:@"higher"];
            
        }else{
            
            tx_priority.text = [NSString languageSelectedStringForKey:@"regular"];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
        [dateFormatter1 setDateFormat:@"yyyy/MMM/dd"];
        NSDate *date_Temp =[dateFormatter dateFromString:taskEditDHolder.str_taskStartDate];
        NSString *str_date = [dateFormatter1 stringFromDate:date_Temp];
        
        tx_chooseDate.text = str_date;
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] isEqualToString:ENGLISH_LANG]) {
           
            tv_description.text = taskEditDHolder.str_taskDetailEng;
            tx_taskName.text = taskEditDHolder.str_taskNameEng;
        }else{
            tv_description.text = taskEditDHolder.str_taskDetailSp;
            tx_taskName.text = taskEditDHolder.str_taskNameSp;
        }
    }
        
    [self getLanguageStrings:nil];
}
-(void)reachabilityStatusChange:(NSNotification*)notification{
    
    if([MCAGlobalFunction isConnectedToInternet])
    {
        NSMutableArray *arr_taskTemp = [NSMutableArray new];
        NSMutableArray * arr_Temp = [[MCADBIntraction databaseInteractionManager]retrieveTask:@"0"];
       
        if (arr_Temp.count > 0)
        {
            for (int i = 0; i<arr_Temp.count; i++)
            {
                MCATaskDetailDHolder *taskDHolder = (MCATaskDetailDHolder*)[arr_Temp objectAtIndex:i];
                
                NSMutableDictionary *dict_Task =[NSMutableDictionary new];
                [dict_Task setValue:taskDHolder.str_taskStartDate forKey:@"task_start_date"];
                [dict_Task setValue:taskDHolder.str_taskPriority forKey:@"task_priority"];
                [dict_Task setValue:taskDHolder.str_taskNameEng forKey:@"task_name_eng"];
                [dict_Task setValue:taskDHolder.str_taskDetailEng forKey:@"task_detail_eng"];
                [dict_Task setValue:taskDHolder.str_taskId forKey:@"task_id"];
                
                if ([[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE]) {
                    [dict_Task setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] forKey:@"language_code"];
                }else{
                    [dict_Task setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] forKey:@"language_code"];
                }
                
                [arr_taskTemp addObject:dict_Task];
            }
            
            NSError* error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr_taskTemp
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
            
            json_TaskString  = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
            json_TaskString = [json_TaskString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            json_TaskString = [json_TaskString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            
            [self addOrEditTask:nil];

        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [tx_priority resignFirstResponder];
    [tx_chooseDate resignFirstResponder];
    [tx_taskName resignFirstResponder];
    
    [view_transBg removeFromSuperview];
    [tbl_priority removeFromSuperview];
    
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}

#pragma mark - UI_TEXTFIELD / UI_TEXTVIEW METHOD

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([[textView text] isEqualToString:[NSString languageSelectedStringForKey:@"description"]]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [self keyboardAppeared];
    return  YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([[textView text] length] == 0) {
        textView.text = [NSString languageSelectedStringForKey:@"description"];
        textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [tv_description resignFirstResponder];
        [self keyboardDisappeared];
    }
    return YES;
}

-(void) keyboardAppeared
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    self.view.frame=CGRectMake(self.view.frame.origin.x,-90,self.view.frame.size.width,self.view.frame.size.height);
   
    [UIView commitAnimations];
}
-(void) keyboardDisappeared
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    self.view.frame=CGRectMake(self.view.frame.origin.x,64,self.view.frame.size.width,self.view.frame.size.height);
   
    [UIView commitAnimations];
}
#pragma mark - LANGUAGE_SUPPORT

-(void)getLanguageStrings:(id)sender{
    
    arr_priority = [[NSMutableArray alloc]initWithObjects:[NSString languageSelectedStringForKey:@"higher"],
                    [NSString languageSelectedStringForKey:@"regular"], nil];
    
    lbl_taskName.text = [NSString languageSelectedStringForKey:@"t_name"];
    lbl_startDate.text = [NSString languageSelectedStringForKey:@"t_date"];
    lbl_priority.text = [NSString languageSelectedStringForKey:@"priority"];
    lbl_description.text = [NSString languageSelectedStringForKey:@"description"];
    
    tx_taskName.placeholder = [NSString languageSelectedStringForKey:@"ett_name"];
    tx_chooseDate.placeholder = [NSString languageSelectedStringForKey:@"etc_date"];
    tx_priority.placeholder = [NSString languageSelectedStringForKey:@"txt_priority"];
    
}
#pragma mark - IB_ACTION

-(IBAction)selectPriorityDidClicked:(id)sender{
    
    [tx_taskName resignFirstResponder];
    
    if (IS_IPHONE_5) {
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    view_transBg.backgroundColor = [UIColor blackColor];
    view_transBg.layer.opacity = 0.7f;
    [self.view addSubview:view_transBg];
    
    tbl_priority = [[UITableView alloc]initWithFrame:CGRectMake(16, 160, 288, 98)];
    tbl_priority.scrollEnabled = NO;
    tbl_priority.dataSource = self;
    tbl_priority.delegate = self;
    [tbl_priority reloadData];
    [self.view addSubview:tbl_priority];
    [self.view bringSubviewToFront:tbl_priority];
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;

}
-(IBAction)chooseDateDidClicked:(id)sender{
    
    [tx_taskName resignFirstResponder];
    
    sheet_datePicker = [[UIActionSheet alloc]
                        initWithTitle:@""
                        delegate:self cancelButtonTitle:nil
                        destructiveButtonTitle:nil otherButtonTitles:nil];
    sheet_datePicker.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    sheet_datePicker.backgroundColor=[UIColor whiteColor];
    
    UIToolbar *tools=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,320,36)];
    tools.barTintColor=[UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1];
    tools.layer.borderWidth=1;
    tools.layer.borderColor=[[UIColor whiteColor] CGColor];
    btnBar_done=[[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                style:UIBarButtonItemStylePlain
                                                target:self
                                               action:@selector(btnBar_doneDidClicked:)];
    
    btnBar_cancel=[[UIBarButtonItem alloc]initWithTitle:[NSString languageSelectedStringForKey:@"cancel"]
                                                  style:UIBarButtonItemStylePlain
                                                  target:self
                                                 action:@selector(btnBar_cancelDidClicked:)];
   
    tools.tintColor=[UIColor whiteColor];
    
    UIBarButtonItem *flexSpace= [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                 target:nil action:nil];
    
    NSArray *array = [[NSArray alloc]initWithObjects:btnBar_cancel,flexSpace,btnBar_done,nil];
    [tools setItems:array];
    
    //picker title
    UILabel *lblPickerTitle=[[UILabel alloc]initWithFrame:CGRectMake(120,6, 200, 25)];
    lblPickerTitle.text = [NSString languageSelectedStringForKey:@"please_select_date"];
    lblPickerTitle.backgroundColor=[UIColor clearColor];
    lblPickerTitle.textColor=[UIColor whiteColor];
    lblPickerTitle.font=[UIFont boldSystemFontOfSize:14];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,0, 320, 200)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setMinimumDate: [NSDate date]];
    [sheet_datePicker addSubview:datePicker];
    
    [tools addSubview:lblPickerTitle];
    [sheet_datePicker addSubview:tools];
    [sheet_datePicker showInView:self.view];
    [sheet_datePicker setBounds:CGRectMake(0, 0, 320, 360)];

}
-(IBAction)btnBarDoneDidClicked:(id)sender{
    
    if (![tx_taskName.text isEqualToString:@""] && ![tx_priority.text isEqualToString:@""] && ![tx_chooseDate.text isEqualToString:@""] && ![tv_description.text isEqualToString:@""] && ![tv_description.text isEqualToString:[NSString languageSelectedStringForKey:@"description"]])
    {
        [self keyboardDisappeared];
        NSMutableDictionary *dict_addTask =[NSMutableDictionary new];
        
        if (taskEditDHolder) {
            
            if (str_dateSelected)
            {
                [dict_addTask setValue:str_dateSelected forKey:@"task_start_date"];
            }else
            {
                [dict_addTask setValue:taskEditDHolder.str_taskStartDate forKey:@"task_start_date"];
            }
            
            [dict_addTask setValue:taskEditDHolder.str_taskId forKey:@"task_id"];
            
        }else{
            
            [dict_addTask setValue:str_dateSelected forKey:@"task_start_date"];
            [dict_addTask setValue:@"" forKey:@"task_id"];
        }
        
        if ([tx_priority.text isEqualToString:[NSString languageSelectedStringForKey:@"higher"]]) {
             [dict_addTask setValue:@"h" forKey:@"task_priority"];
        }else{
             [dict_addTask setValue:@"r" forKey:@"task_priority"];
        }
       
        [dict_addTask setValue:tx_taskName.text forKey:@"task_name"];
        [dict_addTask setValue:tv_description.text forKey:@"task_detail"];
    
        [dict_addTask setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] forKey:@"language_code"];
        
        NSMutableArray *arr_addTask = [NSMutableArray new];
        [arr_addTask addObject:dict_addTask];
        
        json_TaskString = [NSString getJsonArray:arr_addTask];
        
        [self addOrEditTask:nil];
        
    }else{
        
        [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"allFieldMsg"]];
    }
}
-(void)addOrEditTask:(id)sender{
    
    NSMutableDictionary *info=[NSMutableDictionary new];
    
    [info setValue:json_TaskString forKeyPath:@"task"];
    [info setValue:@"add_task" forKey:@"cmd"];
    
    NSString *str_jsonAddOrEditTask = [NSString getJsonObject:info];
    
    str_jsonAddOrEditTask = [str_jsonAddOrEditTask stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    str_jsonAddOrEditTask = [str_jsonAddOrEditTask stringByReplacingOccurrencesOfString:@": \"\[" withString:@":["];
    str_jsonAddOrEditTask = [str_jsonAddOrEditTask stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
    
    [HUD showForTabBar];
    [self.view bringSubviewToFront:HUD];
    [self requestAddTask:str_jsonAddOrEditTask];

}

#pragma mark -  UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 34;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == tbl_priority) {
        // 1. The view for the header
        
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
        
        // 2. Set a custom background color and a border
        headerView.backgroundColor = [UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1];
        
        // 3. Add an image
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(0, 0, tableView.frame.size.width, 34);
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:16];
        headerLabel.text = [NSString languageSelectedStringForKey:@"txt_priority"];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        
        [headerView addSubview:headerLabel];
        
        // 5. Finally return
        return headerView;
    }else{
        
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 32;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arr_priority.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        NSString *cellIdentifier =@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:cellIdentifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.text = [arr_priority objectAtIndex:indexPath.row];
    
        tbl_priority.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
        
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tx_priority.text = [arr_priority objectAtIndex:indexPath.row];
    [view_transBg removeFromSuperview];
    [tbl_priority removeFromSuperview];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}
#pragma mark - API CALLING

-(void)requestAddTask:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForAddTask:info];
    }else{
        
        [HUD hide];
        [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"noInternetMsg"]];
//        MCATaskDetailDHolder *taskAddDHolder = [MCATaskDetailDHolder new];
//        
//        taskAddDHolder.str_userId = [[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID];
//        taskAddDHolder.str_createdBy = @"p";
//        taskAddDHolder.str_taskStatus = @"o";
//        taskAddDHolder.str_status = @"1";
//        taskAddDHolder.str_taskId = @"";
//        taskAddDHolder.str_taskName = tx_taskName.text;
//        taskAddDHolder.str_taskDetail = tv_description.text;
//        taskAddDHolder.str_taskStartDate = str_dateSelected;
//        taskAddDHolder.str_network = @"0";
//        if ([tx_priority.text isEqualToString:@"High"]) {
//            
//            taskAddDHolder.str_taskPriority = @"h";
//          
//        }else{
//            
//            taskAddDHolder.str_taskPriority = @"r";
//        }
//        
//        NSMutableArray *arr_offlineTask = [NSMutableArray new];
//        [arr_offlineTask addObject:taskAddDHolder];
//        [[MCADBIntraction databaseInteractionManager]insertTaskList:arr_offlineTask];
//        
//        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - NSNOTIFICATION SELECTOR

-(void)addTaskSuccess:(NSNotification*)notification{
    
    [HUD hide];
    [self keyboardDisappeared];
    UIAlertView *alert ;
    if (taskEditDHolder) {
        
        taskEditDHolder.str_taskDetailEng = tv_description.text;
        taskEditDHolder.str_taskNameEng  = tx_taskName.text;
        
        if ([tx_priority.text isEqualToString:[NSString languageSelectedStringForKey:@"higher"]]) {
            taskEditDHolder.str_taskPriority = @"h";
        }else{
            taskEditDHolder.str_taskPriority = @"r";
        }
             
        if (str_dateSelected) {
            taskEditDHolder.str_taskStartDate = str_dateSelected;
        }
        
        [delegate editTaskDetail:taskEditDHolder];
        
        alert = [[UIAlertView alloc]initWithTitle:[NSString languageSelectedStringForKey:@"msg"]
                                          message:[NSString languageSelectedStringForKey:@"edit_msg"]
                                         delegate:nil
                                cancelButtonTitle:nil
                                otherButtonTitles:nil, nil];
        
    }else{
        
      alert = [[UIAlertView alloc]initWithTitle:[NSString languageSelectedStringForKey:@"msg"]
                                                         message:[NSString languageSelectedStringForKey:@"task_added_msg"]
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:nil, nil];

        
    }
    
    [alert show];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),^ {
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(void)addTaskFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}

#pragma mark - OTHER_METHOD

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
-(void)btnBar_doneDidClicked:(id)sender{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MMM/dd"];
    NSString *str_date = [dateFormatter stringFromDate:datePicker.date];
    tx_chooseDate.text = str_date;
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd 00:00:00"];
    str_dateSelected = [dateFormatter1 stringFromDate:datePicker.date];
    [sheet_datePicker dismissWithClickedButtonIndex:0 animated:YES];
    
}
-(void)btnBar_cancelDidClicked:(id)sender{
    
    [sheet_datePicker dismissWithClickedButtonIndex:0 animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

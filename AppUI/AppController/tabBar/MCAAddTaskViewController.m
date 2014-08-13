//
//  MCAAddTaskViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 09/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAAddTaskViewController.h"

@interface MCAAddTaskViewController ()

@end

@implementation MCAAddTaskViewController

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
    
    //Arya HUD
    HUD=[AryaHUD new];
    [self.view addSubview:HUD];
    
    tv_description.layer.borderWidth = 0.5f;
    tv_description.layer.cornerRadius = 3.0f;
    tv_description.layer.masksToBounds = YES;
    
    arr_priority = [[NSMutableArray alloc]initWithObjects:@"Higher",@"Regular", nil];
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [tx_priority resignFirstResponder];
    [tx_chooseDate resignFirstResponder];
    [tx_taskNAme resignFirstResponder];
    
    [view_transBg removeFromSuperview];
    [tbl_priority removeFromSuperview];
    
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self keyboardAppeared];
    return  YES;
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
#pragma mark - IB_ACTION

-(IBAction)selectPriorityDidClicked:(id)sender{
    
    [tx_taskNAme resignFirstResponder];
    
    if (IS_IPHONE_5) {
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    view_transBg.backgroundColor = [UIColor blackColor];
    view_transBg.layer.opacity = 0.7f;
    [self.view addSubview:view_transBg];
    
    tbl_priority = [[UITableView alloc]initWithFrame:CGRectMake(20, 160, 282, 82)];
    tbl_priority.scrollEnabled = NO;
    tbl_priority.dataSource = self;
    tbl_priority.delegate = self;
    [tbl_priority reloadData];
    [self.view addSubview:tbl_priority];
    [self.view bringSubviewToFront:tbl_priority];
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;

}
-(IBAction)chooseDateDidClicked:(id)sender{
    
    [tx_taskNAme resignFirstResponder];
    
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
    btnBar_done=[[UIBarButtonItem alloc]initWithTitle:@"done"
                                                style:UIBarButtonItemStylePlain
                                                target:self
                                               action:@selector(btnBar_doneDidClicked:)];
    
    btnBar_cancel=[[UIBarButtonItem alloc]initWithTitle:@"cancel"
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
    lblPickerTitle.text=@"Choose Date";
    lblPickerTitle.backgroundColor=[UIColor clearColor];
    lblPickerTitle.textColor=[UIColor whiteColor];
    lblPickerTitle.font=[UIFont boldSystemFontOfSize:14];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,0, 320, 200)];
    datePicker.tintAdjustmentMode = UIDatePickerModeDate;
    [datePicker setMinimumDate: [NSDate date]];
    [sheet_datePicker addSubview:datePicker];
    
    [tools addSubview:lblPickerTitle];
    [sheet_datePicker addSubview:tools];
    [sheet_datePicker showInView:self.view];
    [sheet_datePicker setBounds:CGRectMake(0, 0, 320, 360)];

}
-(IBAction)btnBarDoneDidClicked:(id)sender{
    
    if (![tx_taskNAme.text isEqualToString:@""] && ![tx_priority.text isEqualToString:@""] && ![tx_chooseDate.text isEqualToString:@""] && ![tv_description.text isEqualToString:@""])
    {
        [self keyboardDisappeared];
        NSMutableDictionary *dict_addTask =[NSMutableDictionary new];
        [dict_addTask setValue:str_dateSelected forKey:@"task_start_date"];
        if ([tx_priority.text isEqualToString:@"Higher"]) {
             [dict_addTask setValue:@"h" forKey:@"task_priority"];
        }else{
             [dict_addTask setValue:@"r" forKey:@"task_priority"];
        }
       
        [dict_addTask setValue:tx_taskNAme.text forKey:@"task_name"];
        [dict_addTask setValue:tv_description.text forKey:@"task_detail"];
        [dict_addTask setValue:@"" forKey:@"task_id"];
    
        if ([[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE]) {
            [dict_addTask setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] forKey:@"language_code"];
        }else{
            [dict_addTask setValue:@"en_us" forKey:@"language_code"];
        }
        
        NSMutableArray *arr_addTask = [NSMutableArray new];
        [arr_addTask addObject:dict_addTask];
        
        NSError* error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr_addTask
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        NSString*json_AddTaskString = [[NSString alloc] initWithData:jsonData
                                                encoding:NSUTF8StringEncoding];
        json_AddTaskString = [json_AddTaskString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        json_AddTaskString = [json_AddTaskString stringByReplacingOccurrencesOfString:@" " withString:@""];
        json_AddTaskString = [json_AddTaskString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        NSMutableDictionary *info=[NSMutableDictionary new];
     
        [info setValue:json_AddTaskString forKeyPath:@"task"];
        [info setValue:@"add_task" forKey:@"cmd"];
        [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TOKEN] forKey:@"user_token"];
        [info setValue:@"" forKey:@"app_token"];
        [info setValue:@"ad607645c57ceb4" forKey:@"device_id"];
        [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID] forKey:@"user_id"];
        [info setValue:@"1.0" forKey:@"app_ver"];
        
        NSData * jsonTaskData = [NSJSONSerialization dataWithJSONObject:info
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        NSString* jsonAddTaskData =  [[NSString alloc] initWithData:jsonTaskData
                                                          encoding:NSUTF8StringEncoding];
        jsonAddTaskData = [jsonAddTaskData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        jsonAddTaskData = [jsonAddTaskData stringByReplacingOccurrencesOfString:@" " withString:@""];
        jsonAddTaskData = [jsonAddTaskData stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        jsonAddTaskData = [jsonAddTaskData stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        jsonAddTaskData = [jsonAddTaskData stringByReplacingOccurrencesOfString:@": \"\[" withString:@":["];
        jsonAddTaskData = [jsonAddTaskData stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
        
        [HUD show];
        [self requestAddTask:jsonAddTaskData];
        
        
    }else{
        
        [MCAGlobalFunction showAlert:MANDATORY_MESSAGE];
    }
}
#pragma mark -  UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 26;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == tbl_priority) {
        // 1. The view for the header
        
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,30)];
        
        // 2. Set a custom background color and a border
        headerView.backgroundColor = [UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1];
        
        // 3. Add an image
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(0,2,282,22);
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        headerLabel.text = @"Select Priority";
        headerLabel.textAlignment = NSTextAlignmentCenter;
        
        [headerView addSubview:headerLabel];
        
        // 5. Finally return
        return headerView;
    }else{
        
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 28;
    
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
        
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
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
       
        [MCAGlobalFunction showAlert:NET_NOT_AVAIALABLE];
    }
}
#pragma mark - NSNOTIFICATION SELECTOR

-(void)addTaskSuccess:(NSNotification*)notification{
    
    [HUD hide];
    [self.navigationController popViewControllerAnimated:YES];
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
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
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

@end

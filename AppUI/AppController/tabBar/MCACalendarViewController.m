//
//  MCACalendarViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 22/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCACalendarViewController.h"
#import "MCATaskDetailViewController.h"

@interface MCACalendarViewController ()

@end

@implementation MCACalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Arya HUD
    HUD=[AryaHUD new];
    [self.view addSubview:HUD];
    
    lbl_noEvent.hidden = YES;
    
    arr_monthTask = [NSMutableArray new];
    arr_studentList = [NSMutableArray new];
    
    arr_studentList = [[MCADBIntraction databaseInteractionManager]retrieveStudList:nil];
    //Navigation Bar Setting
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[[UIImage alloc] init]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
     arr_gradeList = [[NSArray alloc]initWithObjects:@"12th",@"11th",@"10th", nil];
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:KEY_STUDENT_COUNT] > 0)
    {
        UIImage* img_student = [UIImage imageNamed:@"student.png"];
        CGRect img_studFrame = CGRectMake(0, 0, img_student.size.width, img_student.size.height);
        UIButton *btn_student = [[UIButton alloc] initWithFrame:img_studFrame];
        [btn_student setBackgroundImage:img_student forState:UIControlStateNormal];
        [btn_student addTarget:self
                        action:@selector(btnBar_studentDidClicked:)
              forControlEvents:UIControlEventTouchUpInside];
        [btn_student setShowsTouchWhenHighlighted:YES];
        
        UIBarButtonItem *btnBar_student =[[UIBarButtonItem alloc] initWithCustomView:btn_student];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_student,nil]];
     
    }else
    {    
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"])
        {
            UIImage* img_grade = [UIImage imageNamed:@"grade.png"];
            CGRect img_gradeFrame = CGRectMake(0, 0, img_grade.size.width, img_grade.size.height);
            UIButton *btn_grade = [[UIButton alloc] initWithFrame:img_gradeFrame];
            [btn_grade setBackgroundImage:img_grade forState:UIControlStateNormal];
            [btn_grade addTarget:self
                          action:@selector(btnBar_gradeDidClicked:)
                forControlEvents:UIControlEventTouchUpInside];
            [btn_grade setShowsTouchWhenHighlighted:YES];
            
           UIBarButtonItem *btnBar_grade =[[UIBarButtonItem alloc] initWithCustomView:btn_grade];
           [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_grade, nil]];
        }
    }
    
   
}
-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(taskListSuccess:) name:NOTIFICATION_TASK_LIST_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(taskListFailed:) name:NOTIFICATION_TASK_LIST_FAILED object:nil];
    
    [view_transBg removeFromSuperview];
    [tbl_gradeList removeFromSuperview];
    [tbl_studentList removeFromSuperview];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    tabBarMCACtr.tabBar.userInteractionEnabled = YES;
    
    lbl_noEvent.hidden = YES;
    [self getLanguageStrings:nil];
    [self getTaskList:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    for (UIView* subV in self.view.subviews)
    {
        if ([subV isKindOfClass:[MCACalendarView class]]){
             [subV removeFromSuperview];
        }
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_TASK_LIST_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_TASK_LIST_FAILED object:nil];
   
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [view_transBg removeFromSuperview];
    [tbl_gradeList removeFromSuperview];
    [tbl_studentList removeFromSuperview];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    tabBarMCACtr.tabBar.userInteractionEnabled = YES;
    
}
#pragma mark - LANGUAGE_SUPPORT

-(void)getLanguageStrings:(id)sender{
    
    self.navigationItem.title = [NSString languageSelectedStringForKey:@"tab_calendar"];
}
#pragma mark - IB_ACTION

-(void)btnBar_gradeDidClicked:(id)sender{
    
    if (IS_IPHONE_5) {
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    view_transBg.backgroundColor = [UIColor blackColor];
    view_transBg.layer.opacity = 0.6f;
    [self.view addSubview:view_transBg];
    
    tbl_gradeList = [[UITableView alloc]initWithFrame:CGRectMake(20, 160, 282, 128)];
    tbl_gradeList.dataSource = self;
    tbl_gradeList.delegate = self;
    [tbl_gradeList reloadData];
    [self.view addSubview:tbl_gradeList];
    [self.view bringSubviewToFront:tbl_gradeList];
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    tabBarMCACtr.tabBar.userInteractionEnabled = NO;
}
-(void)btn_selectGradeDidClicked:(id)sender{
    
    MCACustomButton *btn_temp = (MCACustomButton*)sender;
    NSString *str_selectedGrade = [arr_gradeList objectAtIndex:btn_temp.index];
    
    [[NSUserDefaults standardUserDefaults]setInteger:btn_temp.index forKey:KEY_TASK_GRADE_INDEX];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    str_selectedGrade = [str_selectedGrade stringByReplacingOccurrencesOfString:@"th" withString:@""];
    
    [view_transBg removeFromSuperview];
    [tbl_gradeList removeFromSuperview];
   
    [self createTaskList:str_selectedGrade];
    NSInteger month = [[NSUserDefaults standardUserDefaults]integerForKey:KEY_CAL_CURRENT_MONTH];
    NSInteger year = [[NSUserDefaults standardUserDefaults]integerForKey:KEY_CAL_CURRENT_YEAR];
    NSInteger height = [[NSUserDefaults standardUserDefaults]integerForKey:KEY_CAL_HEIGHT];
    [self calendarView:calendar switchedToMonth:(int)month switchedToYear:(int)year targetHeight:(int)height animated:YES];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    
}
-(void)btnBar_studentDidClicked:(id)sender{
    
    if (IS_IPHONE_5) {
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    view_transBg.backgroundColor = [UIColor blackColor];
    view_transBg.layer.opacity = 0.6f;
    [self.view addSubview:view_transBg];
    
    if (arr_studentList.count > 4) {
        
        tbl_studentList = [[UITableView alloc]initWithFrame:CGRectMake(20, 160, 282, 160)];
        
    }else{
        
        tbl_studentList = [[UITableView alloc]initWithFrame:CGRectMake(20, 160, 282, arr_studentList.count * 32 + 64)];
    }

    tbl_studentList.delegate = self;
    tbl_studentList.dataSource = self;
    [tbl_studentList reloadData];
    [self.view addSubview:tbl_studentList];
    [self.view bringSubviewToFront:tbl_studentList];
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
}
-(void)btn_selectStudDidClicked:(id)sender{
    
    MCACustomButton *btn_temp = (MCACustomButton*)sender;
    MCASignUpDHolder *studDHolder;
    NSString *str_userId;
    if (btn_temp.index == 0) {
        
        str_userId = @"All";
        
    }else{
        
        studDHolder = [arr_studentList objectAtIndex:btn_temp.index-1];
        str_userId = studDHolder.str_userId;
    }
    
    [[NSUserDefaults standardUserDefaults]setInteger:btn_temp.index forKey:KEY_TASK_STUD_INDEX];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [view_transBg removeFromSuperview];
    [tbl_studentList removeFromSuperview];
  
    [self createTaskList:str_userId];
    NSInteger month = [[NSUserDefaults standardUserDefaults]integerForKey:KEY_CAL_CURRENT_MONTH];
    NSInteger year = [[NSUserDefaults standardUserDefaults]integerForKey:KEY_CAL_CURRENT_YEAR];
    NSInteger height = [[NSUserDefaults standardUserDefaults]integerForKey:KEY_CAL_HEIGHT];
    [self calendarView:calendar switchedToMonth:(int)month switchedToYear:(int)year targetHeight:(int)height animated:YES];

    self.navigationController.navigationBar.userInteractionEnabled = YES;
    
}

#pragma mark - CALENDAR_VIEW METHODS

-(void)calendarView:(MCACalendarView *)calendarView switchedToMonth:(int)month switchedToYear:(int)year targetHeight:(float)targetHeight animated:(BOOL)animated {
    
    lbl_noEvent.hidden = YES;
    
    [[NSUserDefaults standardUserDefaults]setInteger:month forKey:KEY_CAL_CURRENT_MONTH];
    [[NSUserDefaults standardUserDefaults]setInteger:year forKey:KEY_CAL_CURRENT_YEAR];
    [[NSUserDefaults standardUserDefaults]setInteger:targetHeight forKey:KEY_CAL_HEIGHT];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSMutableArray  *arr_taskDates    = [NSMutableArray new];
    NSMutableArray  *arr_taskPriority = [NSMutableArray new];
                        arr_monthTask = [NSMutableArray new];
    
    for (int i=0; i<arr_currentTaskList.count; i++)
    {
        MCATaskDetailDHolder *taskDHolder = (MCATaskDetailDHolder *)[arr_currentTaskList objectAtIndex:i];
        NSString *str_startDate = taskDHolder.str_taskStartDate;
      
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
        NSDate *date = [formatter dateFromString:str_startDate];
        
        if(date!=nil)
        {
            NSInteger age = [date timeIntervalSinceNow]/31556926;
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
            NSInteger selectedDay = [components day];
            NSInteger selectedMonth = [components month];
            NSInteger selectedYear = [components year];
            
            NSLog(@"Day:%d Month:%ld Year:%ld Age:%ld",selectedDay,(long)selectedMonth,(long)selectedYear,(long)age);
            
            if (month == selectedMonth && year == selectedYear)
            {
                [arr_taskDates addObject:[NSNumber numberWithInt:selectedDay]];
                [arr_taskPriority addObject:taskDHolder.str_taskPriority];
                [calendarView markDates:arr_taskDates priorityQueue:arr_taskPriority];
                [arr_monthTask addObject:taskDHolder];
            }
        }
    }
    
    tbl_monthTask.frame = CGRectMake(0, targetHeight, 320, tbl_monthTask.frame.size.height);
    tbl_monthTask.delegate = self;
    tbl_monthTask.dataSource = self;
    [tbl_monthTask reloadData];
}

-(void)calendarView:(MCACalendarView *)calendarView dateSelected:(NSDate *)date {
    
    NSLog(@"Selected date = %@",date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * str_selectedDate  = [dateFormatter stringFromDate:date];
   
    arr_monthTask = [NSMutableArray new];
    NSMutableArray *arr_taskDTemp = [NSMutableArray new];
    arr_taskDTemp = [[MCADBIntraction databaseInteractionManager]retrieveSelectedTask:str_selectedDate];
    
    NSString *str_selectedGrade = [arr_gradeList objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_GRADE_INDEX]];
    str_selectedGrade = [str_selectedGrade stringByReplacingOccurrencesOfString:@"th" withString:@""];
    
    NSInteger int_selectedStud = [[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_STUD_INDEX];
    NSString *str_selectedStud;
    
    if (int_selectedStud == 0) {
        
        str_selectedStud = @"All";
        
    }else{
        str_selectedStud  = [[arr_studentList valueForKey:@"str_userId"] objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_STUD_INDEX]-1];
    }
    
    for (int i=0; i<arr_taskDTemp.count; i++)
    {
        MCATaskDetailDHolder *taskDHolder = (MCATaskDetailDHolder *)[arr_taskDTemp objectAtIndex:i];
        
        if ([taskDHolder.str_status isEqualToString:@"1"])
        {
           if ([[NSUserDefaults standardUserDefaults]integerForKey:KEY_STUDENT_COUNT] > 0)
            {
                if ([str_selectedStud isEqualToString:@"All"] || [str_selectedStud isEqualToString:@"12"])
                {
                    if ([taskDHolder.str_taskStatus isEqualToString:@"o"])
                    {
                        [arr_monthTask addObject:taskDHolder];
                        
                    }
                }else
                {
                    if ([taskDHolder.str_taskStatus isEqualToString:@"o"] && [taskDHolder.str_userId isEqualToString:str_selectedStud]) {
                        
                        [arr_monthTask addObject:taskDHolder];
                    }
                }
            }else
            {
               if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"])
                {
                    if (([taskDHolder.str_grade isEqualToString:str_selectedGrade]) || ([taskDHolder.str_userId isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID]] && [taskDHolder.str_createdBy isEqualToString:@"p"]))
                    {
                     
                        [arr_monthTask addObject:taskDHolder];
                        
                    }
                }else{
                    
                        [arr_monthTask addObject:taskDHolder];
                     }
               }
          }
    }
    
    lbl_noEvent.frame = CGRectMake(6, tbl_monthTask.frame.origin.y, 300, 30);
    
    if (arr_monthTask.count == 0) {
    
        lbl_noEvent.text = KEY_NO_EVENT_FOUND;
        lbl_noEvent.hidden = NO;
        
    }else{
        
        lbl_noEvent.hidden = YES;
      
    }
       [tbl_monthTask reloadData];
}

#pragma mark - UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == tbl_gradeList || tableView == tbl_studentList) {
        return 32;
    }else{
        return 0;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == tbl_gradeList) {
        // 1. The view for the header
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,30)];
        
        // 2. Set a custom background color and a border
        headerView.backgroundColor = [UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1];
        
        // 3. Add an image
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(0,2,282,22);
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        headerLabel.text = @"Select a grade";
        headerLabel.textAlignment = NSTextAlignmentCenter;
        
        [headerView addSubview:headerLabel];
        
        // 5. Finally return
        return headerView;
    }else if (tableView == tbl_studentList)
    {
        // 1. The view for the header
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,30)];
        
        // 2. Set a custom background color and a border
        headerView.backgroundColor = [UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1];
        
        // 3. Add an image
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(0,2,282,22);
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        headerLabel.text = @"Select Student";
        headerLabel.textAlignment = NSTextAlignmentCenter;
        
        [headerView addSubview:headerLabel];
        
        // 5. Finally return
        return headerView;
    }else {
        
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == tbl_gradeList || tableView == tbl_studentList) {
        return 32;
    }else{
        return 72;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == tbl_gradeList) {
        return arr_gradeList.count;
    }else if(tableView == tbl_studentList){
        return arr_studentList.count + 1;
    }else{
        return arr_monthTask.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == tbl_gradeList) {
        NSString *cellIdentifier =@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.textLabel.text = [arr_gradeList objectAtIndex:indexPath.row];
        
        MCACustomButton *btn_selectGrade = [MCACustomButton buttonWithType:UIButtonTypeCustom];
        btn_selectGrade.frame = CGRectMake(242, 4, 24, 24);
        btn_selectGrade.layer.cornerRadius = 12.0f;
        
        if (indexPath.row == [[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_GRADE_INDEX]) {
            
            [btn_selectGrade setBackgroundImage:[UIImage imageNamed:@"blue_checkMark.png"]
                                       forState:UIControlStateNormal];
            
        }
        
        btn_selectGrade.layer.borderColor = [UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1].CGColor;
        btn_selectGrade.layer.borderWidth = 1.0f;
        [btn_selectGrade addTarget:self
                            action:@selector(btn_selectGradeDidClicked:)
                  forControlEvents:UIControlEventTouchUpInside];
        btn_selectGrade.index = indexPath.row;
        [cell addSubview:btn_selectGrade];
        
        tbl_gradeList.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
        
        return cell;

    }else if(tableView == tbl_studentList){
    
        NSString *cellIdentifier =@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if (cell == nil)
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"All";
            
        }else{
            
            MCASignUpDHolder *studDHolder = [arr_studentList objectAtIndex:indexPath.row-1];
            
            cell.textLabel.text = studDHolder.str_userName;
        }
        
        MCACustomButton *btn_selectStudent = [MCACustomButton buttonWithType:UIButtonTypeCustom];
        btn_selectStudent.frame = CGRectMake(242, 4, 24, 24);
        btn_selectStudent.layer.cornerRadius = 12.0f;
        
        if (indexPath.row == [[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_STUD_INDEX]) {
            
            [btn_selectStudent setBackgroundImage:[UIImage imageNamed:@"blue_checkMark.png"]
                                         forState:UIControlStateNormal];
            
        }
        
        btn_selectStudent.layer.borderColor = [UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1].CGColor;
        btn_selectStudent.layer.borderWidth = 1.0f;
        [btn_selectStudent addTarget:self
                              action:@selector(btn_selectStudDidClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
        btn_selectStudent.index = indexPath.row;
        [cell addSubview:btn_selectStudent];
        
        tbl_studentList.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
        return cell;

    }else{
        
        static NSString *cellIdentifier = @"Cell";
        CustomTableViewCell *cell  = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:                                                 cellIdentifier forIndexPath:indexPath];
        
        MCATaskDetailDHolder *taskDetailDHolder = (MCATaskDetailDHolder *)[arr_monthTask objectAtIndex:indexPath.row];
     
        if ([taskDetailDHolder.str_taskPriority isEqualToString:@"h"]) {
            
            cell.lbl_taskPriority.text = [NSString languageSelectedStringForKey:@"higher"];
            cell.lbl_taskPriority.textColor = [UIColor colorWithRed:252.0/255.0 green:109.0/255.0 blue:36.0/255.0 alpha:1.0];
            cell.lbl_taskColor.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:109.0/255.0 blue:36.0/255.0  alpha:1.0];
            
        }else{
            
            cell.lbl_taskPriority.text = [NSString languageSelectedStringForKey:@"regular"];
            cell.lbl_taskPriority.textColor = [UIColor colorWithRed:39.0/255.0 green:166.0/255.0 blue:213.0/255.0 alpha:1.0];
            cell.lbl_taskColor.backgroundColor = [UIColor colorWithRed:39.0/255.0 green:166.0/255.0 blue:213.0/255.0 alpha:1.0];
        }
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] isEqualToString:ENGLISH_LANG]) {
            cell.lbl_taskName.text =  taskDetailDHolder.str_taskNameEng;
        }else{
            cell.lbl_taskName.text =  taskDetailDHolder.str_taskNameSp;
        }

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter1 setDateFormat:@"yyyy/MMM/dd"];
        NSDate *date_Temp =[dateFormatter dateFromString:taskDetailDHolder.str_taskStartDate];
        NSString *str_date = [dateFormatter1 stringFromDate:date_Temp];
        cell.lbl_taskStartDate.text = str_date;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![tableView isEqual: tbl_gradeList])
    {
        if (![tableView isEqual:tbl_studentList])
        {
            MCATaskDetailDHolder *taskDetailDHolder;
            if (tableView == tbl_monthTask) {
                
                taskDetailDHolder  = [arr_monthTask objectAtIndex:indexPath.row];
            }
            [self performSegueWithIdentifier:@"segue_calTaskDetail" sender:taskDetailDHolder];
        }
    }
}
#pragma mark - API CALL

-(void)getTaskList:(id)sender{
    
    NSMutableDictionary *info=[NSMutableDictionary new];
    [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] forKey:@"user_type"];
    [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] forKey:@"language_code"];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:KEY_NOW_DATE]) {
        [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_NOW_DATE] forKey:@"now_date"];
    }else{
        [info setValue:@"" forKey:@"now_date"];
    }
    
    [info setValue:@"get_task_list" forKey:@"cmd"];
    
    NSString *str_jsonTask = [ NSString getJsonObject:info];
    
    [HUD showForTabBar];
    [self.view bringSubviewToFront:HUD];
    [self requestTaskList:str_jsonTask];
    
}

#pragma mark - API CALLING

-(void)requestTaskList:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForTaskList:info];
    }else{
        
        [HUD hide];
   
        [self taskListSuccess:nil];
    }
}
#pragma mark - NSNOTIFICATION SELECTOR

-(void)taskListSuccess:(NSNotification*)notification{
  
    [HUD hide];
    
    dict_taskList  = (NSMutableDictionary*)notification.object;
    arr_taskList = [dict_taskList valueForKey:KEY_TASK_ALL_DATA];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:KEY_NOW_DATE]) {
        
        [[MCADBIntraction databaseInteractionManager]deleteTask:arr_taskList];
        [[MCADBIntraction databaseInteractionManager]insertTaskList:arr_taskList];
        
    }else{
        
        [[MCADBIntraction databaseInteractionManager]insertTaskList:arr_taskList];
    }
    
    NSString *str_selectedGrade = [arr_gradeList objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_GRADE_INDEX]];
    str_selectedGrade = [str_selectedGrade stringByReplacingOccurrencesOfString:@"th" withString:@""];
    
    NSInteger int_selectedStud = [[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_STUD_INDEX];
    NSString *str_selectedStud;
    
    if (int_selectedStud == 0) {
        
        str_selectedStud = @"All";
        
    }else{
        str_selectedStud  = [[arr_studentList valueForKey:@"str_userId"] objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_STUD_INDEX]-1];
    }
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:KEY_STUDENT_COUNT] > 0) {
        [self createTaskList:str_selectedStud];
    }else {
        [self createTaskList:str_selectedGrade];
    }
    
    calendar = [[MCACalendarView alloc] init];
    calendar.delegate = self;
    [self.view addSubview:calendar];
}
-(void)taskListFailed:(NSNotification*)notification{
    
    [HUD hide];
}

#pragma mark - OTHER_METHOD

-(void)createTaskList:(id)sender{
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_PRIORITY_REGULAR] isEqualToString:@"1"] && [[[NSUserDefaults standardUserDefaults]valueForKey:KEY_PRIORITY_HIGH] isEqualToString:@"1"] ) {
        
        arr_taskList = [[MCADBIntraction databaseInteractionManager]retrieveTaskList:nil];
        
    }else if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_PRIORITY_HIGH] isEqualToString:@"1"]){
        
        arr_taskList = [[MCADBIntraction databaseInteractionManager]retrieveHighPriorityTaskList:nil];
        
    }else if([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_PRIORITY_REGULAR] isEqualToString:@"1"]){
        
        arr_taskList = [[MCADBIntraction databaseInteractionManager]retrieveRegularPriorityTaskList:nil];
    }
    
//    arr_taskList = [[MCADBIntraction databaseInteractionManager]retrieveTaskList:nil];
    arr_currentTaskList = [NSMutableArray new];
    
    for (int i=0; i<arr_taskList.count; i++)
    {
        MCATaskDetailDHolder *taskDHolder = (MCATaskDetailDHolder *)[arr_taskList objectAtIndex:i];
        
        if ([taskDHolder.str_status isEqualToString:@"1"])
        {
            if ([[NSUserDefaults standardUserDefaults]integerForKey:KEY_STUDENT_COUNT] > 0)
            {
                if ([sender isEqualToString:@"All"] || [sender isEqualToString:@"12"])
                {
                    if ([taskDHolder.str_taskStatus isEqualToString:@"o"])
                    {
                        [arr_currentTaskList addObject:taskDHolder];
                
                    }
                }else
                {
                    if ([taskDHolder.str_taskStatus isEqualToString:@"o"] && [taskDHolder.str_userId isEqualToString:sender]) {
                        
                        [arr_currentTaskList addObject:taskDHolder];
                    }
                }
         }else{
                if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"])
                {
                    if (([taskDHolder.str_taskStatus isEqualToString:@"o"] && [taskDHolder.str_grade isEqualToString:sender])
                        || ([taskDHolder.str_taskStatus isEqualToString:@"o"] && [taskDHolder.str_userId isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID]] && [taskDHolder.str_createdBy isEqualToString:@"p"]))
                    {
                        [arr_currentTaskList addObject:taskDHolder];
                    }
                }else{
                    
                    if ([taskDHolder.str_taskStatus isEqualToString:@"o"]){
                        
                        [arr_currentTaskList addObject:taskDHolder];
                        
                    }
                }
            }
        }
    }
//    [calendar removeFromSuperview];
   
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segue_calTaskDetail"]) {
        
        MCATaskDetailViewController *taskDetailViewCtr = (MCATaskDetailViewController*)[segue destinationViewController];
        
        taskDetailViewCtr.taskDetailDHolder = (MCATaskDetailDHolder*)sender;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
@end

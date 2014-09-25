 //
//  MCATaskViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 05/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCATaskViewController.h"
#import "MCATaskDetailViewController.h"
@interface MCATaskViewController ()

@end

@implementation MCATaskViewController

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
    
    //Arya HUD
    HUD=[AryaHUD new];
    [self.view addSubview:HUD];
    
    //Navigation Bar Setting
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[[UIImage alloc] init]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
    arr_taskList = [NSMutableArray new];
    arr_studentList = [NSMutableArray new];
       
    arr_studentList = [[MCADBIntraction databaseInteractionManager]retrieveStudList:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteTaskSuccess:) name:NOTIFICATION_DELETE_TASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(completeTaskSuccess:) name:NOTIFICATION_COMPLETE_TASK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteOrCompleteTaskFailed:) name:NOTIFICATION_DELETE_COMPLETE_TASK_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addTaskSuccess:) name:NOTIFICATION_ADD_TASK_SUCCESS object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addTaskFailed:) name:NOTIFICATION_ADD_TASK_FAILED object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(viewNotificationTable:) name:NOTIFICATION_LOCAL_UINOTIFICATION_SUCCESS object:nil];
    
    segControl_task.tintColor=[UIColor whiteColor];
    
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:KEY_TASK_STUD_INDEX];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:KEY_ANIMATION_FILE_RAND_NO];
    [[NSUserDefaults standardUserDefaults]synchronize];

    if ([[NSUserDefaults standardUserDefaults]integerForKey:KEY_STUDENT_COUNT] > 0) {
      
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
        
//        [nav_TaskBar setItems:[NSArray arrayWithObject:self.navigationItem]];
//        [nav_TaskBar setItems:[NSArray arrayWithObject:self.navigationItem]];
    }else{

//        arr_gradeList = [[NSArray alloc]initWithObjects:@"12th",@"11th",@"10th", nil];
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:KEY_TASK_GRADE_INDEX];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"])
        {
            UIImage* img_add = [UIImage imageNamed:@"add.png"];
            CGRect img_addFrame = CGRectMake(0, 0, img_add.size.width, img_add.size.height);
            UIButton *btn_add = [[UIButton alloc] initWithFrame:img_addFrame];
            [btn_add setBackgroundImage:img_add forState:UIControlStateNormal];
            [btn_add addTarget:self
                        action:@selector(btnBar_addDidClicked:)
              forControlEvents:UIControlEventTouchUpInside];
            [btn_add setShowsTouchWhenHighlighted:YES];
            
            UIImage* img_grade = [UIImage imageNamed:@"grade1.png"];
            CGRect img_gradeFrame = CGRectMake(0, 0, img_grade.size.width, img_grade.size.height);
            UIButton *btn_grade = [[UIButton alloc] initWithFrame:img_gradeFrame];
            [btn_grade setBackgroundImage:img_grade forState:UIControlStateNormal];
            [btn_grade addTarget:self
                          action:@selector(btnBar_gradeDidClicked:)
                           forControlEvents:UIControlEventTouchUpInside];
            [btn_grade setShowsTouchWhenHighlighted:YES];
            
            UIBarButtonItem *btnBar_add =[[UIBarButtonItem alloc] initWithCustomView:btn_add];
            UIBarButtonItem *btnBar_grade =[[UIBarButtonItem alloc] initWithCustomView:btn_grade];
            [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_add,btnBar_grade, nil]];
            
        }else{
            
            UIImage* img_add = [UIImage imageNamed:@"add.png"];
            CGRect img_addFrame = CGRectMake(0, 0, img_add.size.width, img_add.size.height);
            UIButton *btn_add = [[UIButton alloc] initWithFrame:img_addFrame];
            [btn_add setBackgroundImage:img_add forState:UIControlStateNormal];
            [btn_add addTarget:self
                        action:@selector(btnBar_addDidClicked:)
              forControlEvents:UIControlEventTouchUpInside];
            [btn_add setShowsTouchWhenHighlighted:YES];
            
            UIBarButtonItem *btnBar_add =[[UIBarButtonItem alloc] initWithCustomView:btn_add];
            [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_add,nil]];
        }
    }
    
     tbl_taskCompleted.tableFooterView = [[UIView alloc] init];
     tbl_taskCurrent.tableFooterView = [[UIView alloc] init];
     tbl_taskDeleted.tableFooterView = [[UIView alloc] init];
    
//    [self performSelector:@selector(apiCalling:) withObject:nil afterDelay:1];
    
}
-(void)viewNotificationTable:(id)sender{
    
    MCANotificationTable *notificationV = [[MCANotificationTable alloc]
                                           initWithFrame:CGRectMake( 15, 20, 290, 328)];
    
    notificationV.delegate = self;
  
//    for (UIView* subV in self.view.subviews) {
//        
//        if ([subV isKindOfClass:[UIView class]])
//            
//            [subV removeFromSuperview];
//    }

    [view_transBg removeFromSuperview];
    
    if (IS_IPHONE_5) {
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
     
    view_transBg.backgroundColor = [UIColor blackColor];
    view_transBg.layer.opacity = 0.6f;
    
    [self.view addSubview:view_transBg];
    [self.view addSubview:notificationV];
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    tabBarMCACtr.tabBar.userInteractionEnabled = NO;

}
-(void)reminderView:(id)sender{
    
    [view_transBg  removeFromSuperview];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    tabBarMCACtr.tabBar.userInteractionEnabled = YES;

}
-(void)apiCalling:(id)sender{
    
    arr_taskList = [[MCADBIntraction databaseInteractionManager]retrieveTaskList:nil];
    //Api calling
    if (!arr_taskList.count > 0)
    {
        arr_taskList = [NSMutableArray new];
        [self getTaskList:nil];
    }else{
        [self createTaskList:@"12"];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [view_transBg removeFromSuperview];
    [tbl_gradeList removeFromSuperview];
    [tbl_studentList removeFromSuperview];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    tabBarMCACtr.tabBar.userInteractionEnabled = YES;
    
}
-(void)viewWillAppear:(BOOL)animated{
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(taskListSuccess:) name:NOTIFICATION_TASK_LIST_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(taskListFailed:) name:NOTIFICATION_TASK_LIST_FAILED object:nil];
    
    [self getTaskList:nil];

    [view_transBg removeFromSuperview];
    [tbl_gradeList removeFromSuperview];
    [tbl_studentList removeFromSuperview];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    tabBarMCACtr.tabBar.userInteractionEnabled = YES;
    
    [self getLanguageStrings:nil];

}
-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_TASK_LIST_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_TASK_LIST_FAILED object:nil];

}

#pragma mark - LANGUAGE_SUPPORT

-(void)getLanguageStrings:(id)sender{
    
   [[MCAGlobalData sharedManager]getTabBarTitle:nil];
    
    arr_gradeList = [[NSArray alloc]initWithObjects:[NSString languageSelectedStringForKey:@"twelve"],
                     [NSString languageSelectedStringForKey:@"eleven"],
                     [NSString languageSelectedStringForKey:@"ten"], nil];
    
    self.navigationItem.title = [NSString languageSelectedStringForKey:@"task_manage"];
    [segControl_task setTitle:[NSString languageSelectedStringForKey:@"current"] forSegmentAtIndex:0];
    [segControl_task setTitle:[NSString languageSelectedStringForKey:@"completed"] forSegmentAtIndex:1];
    [segControl_task setTitle:[NSString languageSelectedStringForKey:@"deleted"] forSegmentAtIndex:2];
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

-(void)confirmationApi:(id)sender{
    
    NSMutableDictionary *info=[NSMutableDictionary new];
    
    NSMutableArray *arr_Temp = [dict_taskList valueForKey:KEY_TASK_DELETED_ARRAY];
    
    if(arr_Temp.count>0){
        
       NSString *str_jsonDelete = [NSString getJsonArray:arr_Temp];
       [info setValue:str_jsonDelete forKey:@"deleted_task"];
        
    }else{
        
       [info setValue:@"[]" forKey:@"deleted_task"];
    }
    
    [info setValue:@"conform" forKey:@"cmd"];
   
    NSString *str_jsonConfirmTask = [NSString getJsonObject:info];
    
    str_jsonConfirmTask = [str_jsonConfirmTask stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    str_jsonConfirmTask = [str_jsonConfirmTask stringByReplacingOccurrencesOfString:@": \"\[" withString:@":["];
    str_jsonConfirmTask = [str_jsonConfirmTask stringByReplacingOccurrencesOfString:@"] \"" withString:@"]"];
    
//    [HUD show];
//    [self.view bringSubviewToFront:HUD];
    [self requestConfirmation:str_jsonConfirmTask];
    
}
#pragma mark - IB_ACTION

-(IBAction)btnSegControl_taskDidClicked:(id)sender{
    
    if (segControl_task.selectedSegmentIndex == 0) {
        
        [tbl_taskCompleted removeFromSuperview];
        [tbl_taskDeleted removeFromSuperview];
        
        tbl_taskCurrent.delegate = self;
        tbl_taskCurrent.dataSource = self;
        if (IS_IPHONE_5) {
             tbl_taskCurrent.frame = CGRectMake(0, 36, 320, 422);
        }else{
             tbl_taskCurrent.frame = CGRectMake(0, 36, 320, 332);
        }
       
        [tbl_taskCurrent reloadData];
        [self.view addSubview:tbl_taskCurrent];
        
    }else if(segControl_task.selectedSegmentIndex == 1){
        
        [tbl_taskCurrent removeFromSuperview];
        [tbl_taskDeleted removeFromSuperview];
        
        tbl_taskCompleted.delegate = self;
        tbl_taskCompleted.dataSource = self;
        if (IS_IPHONE_5) {
            tbl_taskCompleted.frame = CGRectMake(0, 36, 320, 422);
        }else{
            tbl_taskCompleted.frame = CGRectMake(0, 36, 320, 332);
        }
        
        [tbl_taskCompleted reloadData];
        [self.view addSubview:tbl_taskCompleted];
      
        [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:KEY_ANIMATION_FILE_RAND_NO];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }else{
        
        [tbl_taskCompleted removeFromSuperview];
        [tbl_taskCurrent removeFromSuperview];
        
        tbl_taskDeleted.delegate = self;
        tbl_taskDeleted.dataSource = self;
        if (IS_IPHONE_5) {
            tbl_taskDeleted.frame = CGRectMake(0, 36, 320, 422);
        }else{
            tbl_taskDeleted.frame = CGRectMake(0, 36, 320, 332);
        }
        
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:KEY_ANIMATION_FILE_RAND_NO];
        [[NSUserDefaults standardUserDefaults]synchronize];
      
        [tbl_taskDeleted reloadData];
        [self.view addSubview:tbl_taskDeleted];
    }
}
-(void)btnBar_addDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_addTask" sender:nil];
}
-(void)btnBar_gradeDidClicked:(id)sender{
    
    if (IS_IPHONE_5) {
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    view_transBg.backgroundColor = [UIColor blackColor];
    view_transBg.layer.opacity = 0.6f;
    
    tbl_gradeList = [[UITableView alloc]initWithFrame:CGRectMake(20, 140, 282, 150)];
    tbl_gradeList.layer.borderWidth = 0.5f;
    tbl_gradeList.dataSource = self;
    tbl_gradeList.delegate = self;
    [tbl_gradeList reloadData];
    
    [self.view addSubview:view_transBg];
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
    [HUD showForTabBar];
    [self.view bringSubviewToFront:HUD];
    [self createTaskList:str_selectedGrade];
     self.navigationController.navigationBar.userInteractionEnabled = YES;
    
}
-(void)btnBar_studentDidClicked:(id)sender{
    
    arr_studentList = [[MCADBIntraction databaseInteractionManager]retrieveStudList:nil];
    
    if (IS_IPHONE_5) {
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        view_transBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    view_transBg.backgroundColor = [UIColor blackColor];
    view_transBg.layer.opacity = 0.6f;
   
    if (arr_studentList.count > 3) {
        
         tbl_studentList = [[UITableView alloc]initWithFrame:CGRectMake(20, 140, 282, 150)];
        
    }else{
        
        tbl_studentList = [[UITableView alloc]initWithFrame:CGRectMake(20, 140, 282, arr_studentList.count * 38 + 74)];
    }
    
    tbl_studentList.layer.borderWidth = 0.5f;
    tbl_studentList.dataSource = self;
    tbl_studentList.delegate = self;
    [tbl_studentList reloadData];
    
    [self.view addSubview:view_transBg];
    [self.view addSubview:tbl_studentList];
    [self.view bringSubviewToFront:tbl_studentList];
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
}
-(void)btn_selectStudDidClicked:(id)sender{
    
    MCACustomButton *btn_temp = (MCACustomButton*)sender;
    MCASignUpDHolder *studDHolder;
    NSString *str_userId;
    if (btn_temp.index == 0) {
        
        str_userId = [NSString languageSelectedStringForKey:@"all"];
        
    }else{
        
       studDHolder = [arr_studentList objectAtIndex:btn_temp.index-1];
       str_userId = studDHolder.str_userId;
    }
    
    [[NSUserDefaults standardUserDefaults]setInteger:btn_temp.index forKey:KEY_TASK_STUD_INDEX];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [view_transBg removeFromSuperview];
    [tbl_studentList removeFromSuperview];
    [HUD showForTabBar];
    [self.view bringSubviewToFront:HUD];
    [self createTaskList:str_userId];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    
}
#pragma mark -  UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == tbl_gradeList || tableView == tbl_studentList) {
        
        return 36;
        
    }else{
        
        return 0;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == tbl_gradeList) {
        // 1. The view for the header
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,36)];
        
        // 2. Set a custom background color and a border
        headerView.backgroundColor = [UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1];
        
        // 3. Add an image
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(0, 0,tableView.frame.size.width, 36);
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:16];
        headerLabel.text = [NSString languageSelectedStringForKey:@"et_sgrade"];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        
        [headerView addSubview:headerLabel];
        
        // 5. Finally return
        return headerView;
    }else if (tableView == tbl_studentList)
    {
        // 1. The view for the header
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 36)];
        
        // 2. Set a custom background color and a border
        headerView.backgroundColor = [UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1];
        
        // 3. Add an image
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(0, 0, tableView.frame.size.width, 36);
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:16];
        headerLabel.text = [NSString languageSelectedStringForKey:@"Select_a_student"];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        
        [headerView addSubview:headerLabel];
        
        // 5. Finally return
        return headerView;
    }
    else{
        
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == tbl_gradeList || tableView == tbl_studentList) {
        return 38;
    }else{
        return 72;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       
    if (tableView == tbl_taskCurrent) {
        
        return arr_currentTaskList.count;
        
     }else if (tableView == tbl_taskCompleted){
        
        return arr_completedTaskList.count;
         
     }else if(tableView == tbl_taskDeleted){
         
         return arr_deletedTaskList.count;
         
     }else if(tableView == tbl_gradeList){
         
         return arr_gradeList.count;
         
     }else{
         
         return arr_studentList.count + 1;
     }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == tbl_gradeList)
    {
     
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
        btn_selectGrade.frame = CGRectMake(240, 0, 38, 38);
      
        if (indexPath.row == [[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_GRADE_INDEX]) {
           
            [btn_selectGrade setImage:[UIImage imageNamed:@"blue_checkMark.png"]
                                       forState:UIControlStateNormal];
        }else{
            
            [btn_selectGrade setImage:[UIImage imageNamed:@"blue_uncheckMark.png"]
                                       forState:UIControlStateNormal];
        }
        
         [btn_selectGrade addTarget:self
                     action:@selector(btn_selectGradeDidClicked:)
           forControlEvents:UIControlEventTouchUpInside];
         btn_selectGrade.index = indexPath.row;
         [cell addSubview:btn_selectGrade];
        
        tbl_gradeList.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
        return cell;

    }else if(tableView == tbl_studentList)
    {        
        NSString *cellIdentifier =@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if (cell == nil)
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        
        if (indexPath.row == 0) {
          
            cell.textLabel.text = [NSString languageSelectedStringForKey:@"all"];
            
        }else{
            
            MCASignUpDHolder *studDHolder = [arr_studentList objectAtIndex:indexPath.row-1];
            cell.textLabel.text = studDHolder.str_userName;
        }
        
        MCACustomButton *btn_selectStudent = [MCACustomButton buttonWithType:UIButtonTypeCustom];
        btn_selectStudent.frame = CGRectMake(240, 0, 38, 38);
        
        if (indexPath.row == [[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_STUD_INDEX]) {
            
            [btn_selectStudent setImage:[UIImage imageNamed:@"blue_checkMark.png"]
                                         forState:UIControlStateNormal];
            
        }else{
            [btn_selectStudent setImage:[UIImage imageNamed:@"blue_uncheckMark.png"]
                             forState:UIControlStateNormal];

        }

        [btn_selectStudent addTarget:self
                              action:@selector(btn_selectStudDidClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
        btn_selectStudent.index = indexPath.row;
        [cell addSubview:btn_selectStudent];
        tbl_studentList.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
        return cell;
     
    }else{
        
        CustomTableViewCell *cell;
        MCATaskDetailDHolder *taskDHolder;
        
        if (tableView == tbl_taskCurrent)
        {
            static NSString *cellIdentifier = @"Cell";
            taskDHolder = (MCATaskDetailDHolder *)[arr_currentTaskList objectAtIndex:indexPath.row];
            cell  = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:                                                 cellIdentifier forIndexPath:indexPath];
            
            NSMutableArray *leftUtilityButtons;
            NSMutableArray *rightUtilityButtons;
            
            if (![[NSUserDefaults standardUserDefaults]integerForKey:KEY_STUDENT_COUNT] > 0) {
                
                // Add utility buttons
                leftUtilityButtons = [NSMutableArray new];
                rightUtilityButtons = [NSMutableArray new];
                
            }
            
            if ([taskDHolder.str_taskPriority isEqualToString:@"h"]) {
             
                [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:252.0/255.0 green:109.0/255.0 blue:36.0/255.0  alpha:1.0]icon:[UIImage imageNamed:@"taskSelect.png"]];
                
            }else{
          
                [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:39.0/255.0 green:166.0/255.0 blue:213.0/255.0 alpha:1.0]icon:[UIImage imageNamed:@"taskSelect.png"]];
            }
            
            [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor]
                                                         icon:[UIImage imageNamed:@"delete1.png"]];
            
            cell.leftUtilityButtons = leftUtilityButtons;
            cell.rightUtilityButtons = rightUtilityButtons;
            
        }else if (tableView == tbl_taskCompleted){
            
            static NSString *cellIdentifier = @"Cell";
            taskDHolder = (MCATaskDetailDHolder *)[arr_completedTaskList objectAtIndex:indexPath.row];
            cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:                                                 cellIdentifier forIndexPath:indexPath];
            
        }else{
            
            static NSString *cellIdentifier = @"Cell";
            taskDHolder = (MCATaskDetailDHolder *)[arr_deletedTaskList objectAtIndex:indexPath.row];
            cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:                                                 cellIdentifier forIndexPath:indexPath];
            
           }
        
        // Configure the cell
        
        if([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] isEqualToString:ENGLISH_LANG]){
            
            cell.lbl_taskName.text = taskDHolder.str_taskNameEng;
        }else{
            cell.lbl_taskName.text = taskDHolder.str_taskNameSp;
        }
        
        cell.lbl_taskName.font = [UIFont systemFontOfSize:16];
        cell.lbl_taskName.adjustsFontSizeToFitWidth = YES;
        cell.lbl_taskName.minimumScaleFactor = 0.8;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
        
       [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
       [dateFormatter1 setDateFormat:@"yyyy/MMM/dd"];
        NSDate *dateTemp =[dateFormatter dateFromString:taskDHolder.str_taskStartDate];
        NSString *strDate = [dateFormatter1 stringFromDate:dateTemp];
        cell.lbl_taskStartDate.text = strDate;
        
        if ([taskDHolder.str_taskPriority isEqualToString:@"h"]) {
            
            cell.lbl_taskPriority.text = [NSString languageSelectedStringForKey:@"higher"];
            cell.lbl_taskPriority.textColor = [UIColor colorWithRed:252.0/255.0 green:109.0/255.0 blue:36.0/255.0 alpha:1.0];
            cell.lbl_taskColor.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:109.0/255.0 blue:36.0/255.0  alpha:1.0];
            
        }else{
            
            cell.lbl_taskPriority.text = [NSString languageSelectedStringForKey:@"regular"];
            cell.lbl_taskPriority.textColor = [UIColor colorWithRed:39.0/255.0 green:166.0/255.0 blue:213.0/255.0 alpha:1.0];
            cell.lbl_taskColor.backgroundColor = [UIColor colorWithRed:39.0/255.0 green:166.0/255.0 blue:213.0/255.0 alpha:1.0];
            
        }
        
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
            if (tableView == tbl_taskCurrent) {
                
                taskDetailDHolder  = [arr_currentTaskList objectAtIndex:indexPath.row];
            }else if(tableView == tbl_taskCompleted){
                
                taskDetailDHolder = [arr_completedTaskList objectAtIndex:indexPath.row];
            }else if (tableView == tbl_taskDeleted){
                
                taskDetailDHolder = [arr_deletedTaskList objectAtIndex:indexPath.row];
            }
            
            [self performSegueWithIdentifier:@"segue_taskDetail" sender:taskDetailDHolder];
        }
    }
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            NSIndexPath *cellIndexPath = [tbl_taskCurrent indexPathForCell:cell];
            MCATaskDetailDHolder *taskDHolder  = [arr_currentTaskList objectAtIndex:cellIndexPath.row];
            
            NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc]init];
            [dateFormatterTime setDateFormat:@"yyyy-MM-dd 00:00:00"];
            NSString *str_dateTime = [dateFormatterTime stringFromDate:[NSDate date]];
            
            arr_completedTaskDetail = [NSMutableArray new];
            taskDHolder.str_taskStatus = @"c";
            [arr_completedTaskDetail addObject:taskDHolder];
            
            NSMutableDictionary *info=[NSMutableDictionary new];
            [info setValue:str_dateTime forKey:@"updated_at"];
            [info setValue:@"c" forKey:@"task_status"];
            [info setValue:taskDHolder.str_taskId forKey:@"task_id"];
            
            [info setValue:@"task_status" forKey:@"cmd"];
            
            NSString *str_jsonCompleteTask = [NSString getJsonObject:info];
            
            [HUD showForTabBar];
            [self.view bringSubviewToFront:HUD];
            [self requestDeleteOrCompleteTask:str_jsonCompleteTask];
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
            default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
   
    [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:KEY_ANIMATION_FILE_RAND_NO];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    switch (index) {
      case 0:
      {
           NSIndexPath *cellIndexPath = [tbl_taskCurrent indexPathForCell:cell];
          
           MCAAlertView *alertView = [MCAGlobalFunction
                                       showAlert:[NSString languageSelectedStringForKey:@"delete_msg"]
                                       title:[NSString languageSelectedStringForKey:@"delete"]
                                       delegate:self
                                       btnOk:[NSString languageSelectedStringForKey:@"conform"]
                                       btnCancel:[NSString languageSelectedStringForKey:@"cancel"]];
          
          alertView.index = cellIndexPath.row;
          [cell hideUtilityButtonsAnimated:YES];
          
           break;
        }
           default:
           break;
     }
}
#pragma mark - API CALLING

-(void)requestTaskList:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForTaskList:info];
    }else{
        [HUD hide];
//        arr_taskList = [[MCADBIntraction databaseInteractionManager]retrieveTaskList:nil];
        [self taskListSuccess:nil];
//        [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"noInternetMsg"]];
    }
}
-(void)requestConfirmation:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForConfirmationApi:info];
    }else{
        [HUD hide];
//        [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"noInternetMsg"]];
    }
}
-(void)requestDeleteOrCompleteTask:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForDeleteOrCompleteTask:info :@"task"];
    }else{
        [HUD hide];
        [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"noInternetMsg"]];
    }
}
#pragma mark - NSNOTIFICATION SELECTOR

-(void)taskListSuccess:(NSNotification*)notification{

    dict_taskList  = (NSMutableDictionary*)notification.object;
    
    arr_taskList = [dict_taskList valueForKey:KEY_TASK_ALL_DATA];
    arr_taskDeletedList = [dict_taskList valueForKey:KEY_TASK_DELETED_DATA];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:KEY_NOW_DATE]) {
        
        if (arr_taskDeletedList.count>0) {
             [[MCADBIntraction databaseInteractionManager]deleteTask:arr_taskDeletedList];
        }
        
        [[MCADBIntraction databaseInteractionManager]deleteTask:arr_taskList];
        [[MCADBIntraction databaseInteractionManager]insertTaskList:arr_taskList];
        
    }else{
        
        [[MCADBIntraction databaseInteractionManager]insertTaskList:arr_taskList];
    }
    
    [self confirmationApi:nil];
    
    NSString *str_selectedGrade = [arr_gradeList objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_GRADE_INDEX]];
    str_selectedGrade = [str_selectedGrade stringByReplacingOccurrencesOfString:@"th" withString:@""];
    
    NSInteger int_selectedStud = [[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_STUD_INDEX];
    NSString *str_selectedStud;
    
    if (int_selectedStud == 0) {
        
        str_selectedStud = [NSString languageSelectedStringForKey:@"all"];
        
    }else{
         str_selectedStud  = [[arr_studentList valueForKey:@"str_userId"] objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_STUD_INDEX]-1];
    }
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:KEY_STUDENT_COUNT] > 0) {
        [self createTaskList:str_selectedStud];
    }else {
        [self createTaskList:str_selectedGrade];
    }

    
//    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:KEY_TASK_GRADE_INDEX];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    
//    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:KEY_TASK_STUD_INDEX];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    [tbl_gradeList reloadData];
    
}
-(void)taskListFailed:(NSNotification*)notification{
    
    [HUD hide];
    [self taskListSuccess:nil];
}
-(void)deleteTaskSuccess:(NSNotification*)notification{

//    [self getTaskList:nil];
    [[MCADBIntraction databaseInteractionManager]updateTaskList:arr_deletedTaskDetail];
  
    NSString *str_selectedGrade = [arr_gradeList objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_GRADE_INDEX]];
    str_selectedGrade = [str_selectedGrade stringByReplacingOccurrencesOfString:@"th" withString:@""];
    
    [self createTaskList:str_selectedGrade];
}
-(void)completeTaskSuccess:(NSNotification*)notification{
    
    [[MCADBIntraction databaseInteractionManager]updateTaskList:arr_completedTaskDetail];
    
    NSString *str_selectedGrade = [arr_gradeList objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:KEY_TASK_GRADE_INDEX]];
    str_selectedGrade = [str_selectedGrade stringByReplacingOccurrencesOfString:@"th" withString:@""];
    [self createTaskList:str_selectedGrade];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString languageSelectedStringForKey:@"msg"]
                                               message:[NSString languageSelectedStringForKey:@"taskCompleted_msg"]
                                               delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:nil, nil];
    
    [alert show];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),^ {
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        
        NSMutableArray *arr_animationVideo = [[NSMutableArray alloc]initWithObjects:@"ducksmall",
                                              @"mousesmall",@"pigsmall",
                                              @"rabbitsmall", nil];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:[arr_animationVideo objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:KEY_ANIMATION_FILE_RAND_NO]] withExtension:@"mp4"];
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
        
        // Create an AVPlayerItem using the asset
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
        
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
        self.videoPlayer = player;
        
        // Create an AVPlayerLayer using the player
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        if (IS_IPHONE_5) {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
        }else{
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        }
        
        view.backgroundColor = [UIColor whiteColor];
        playerLayer.frame = view.bounds;
        // Add it to your view's sublayers
        [view.layer addSublayer:playerLayer];
        [self.view addSubview:view];
        
        //    [self.view bringSubviewToFront:view];
        [player play];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[player currentItem]];
        
        tabBarMCACtr.tabBar.hidden = YES;
        self.navigationController.navigationBarHidden = YES;
    });
}
-(void)deleteOrCompleteTaskFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}
-(void)addTaskSuccess:(NSNotification*)notification{
    
    [segControl_task setSelectedSegmentIndex:0];
   
}
-(void)addTaskFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}

#pragma mark - UIALERTVIEW_METHOD

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MCAAlertView *mcaAlert = (MCAAlertView*)alertView;
    
    if (buttonIndex == 1)
    {
        MCATaskDetailDHolder *taskDHolder  = [arr_currentTaskList objectAtIndex:mcaAlert.index];
        
        NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc]init];
        [dateFormatterTime setDateFormat:@"yyyy-MM-dd 00:00:00"];
        NSString *str_dateTime = [dateFormatterTime stringFromDate:[NSDate date]];
        
        arr_deletedTaskDetail = [NSMutableArray new];
        taskDHolder.str_taskStatus = @"d";
        [arr_deletedTaskDetail addObject:taskDHolder];
        
        NSMutableDictionary *info=[NSMutableDictionary new];
        [info setValue:str_dateTime forKey:@"updated_at"];
        [info setValue:@"d" forKey:@"task_status"];
        [info setValue:taskDHolder.str_taskId forKey:@"task_id"];
        
        [info setValue:@"task_status" forKey:@"cmd"];
        
        NSString *str_jsonDeletetask = [NSString getJsonObject:info];
        
        [HUD showForTabBar];
        [self.view bringSubviewToFront:HUD];
        [self requestDeleteOrCompleteTask:str_jsonDeletetask];
        
    }
}

#pragma mark - OTHER_METHODS

-(void)createTaskList:(id)sender{
    
    arr_taskList = [NSMutableArray new];
    arr_currentTaskList  = [NSMutableArray new];
    arr_completedTaskList  = [NSMutableArray new];
    arr_deletedTaskList = [NSMutableArray new];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_PRIORITY_REGULAR] isEqualToString:@"1"] && [[[NSUserDefaults standardUserDefaults]valueForKey:KEY_PRIORITY_HIGH] isEqualToString:@"1"] ) {
        
        arr_taskList = [[MCADBIntraction databaseInteractionManager]retrieveTaskList:nil];
        
    }else if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_PRIORITY_HIGH] isEqualToString:@"1"]){
        
         arr_taskList = [[MCADBIntraction databaseInteractionManager]retrieveHighPriorityTaskList:nil];
        
    }else if([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_PRIORITY_REGULAR] isEqualToString:@"1"]){
        
         arr_taskList = [[MCADBIntraction databaseInteractionManager]retrieveRegularPriorityTaskList:nil];
    }
    
    for (int i = 0; i < arr_taskList.count; i++)
    {
      MCATaskDetailDHolder *taskDHolder = (MCATaskDetailDHolder *)[arr_taskList objectAtIndex:i];
        
        if ([taskDHolder.str_status isEqualToString:@"1"])
        {
          if ([[NSUserDefaults standardUserDefaults]integerForKey:KEY_STUDENT_COUNT] > 0)
           {
               if ([sender isEqualToString:[NSString languageSelectedStringForKey:@"all"]] || [sender isEqualToString:@"12"]) {
                    
                    if ([taskDHolder.str_taskStatus isEqualToString:@"o"]) {
                        
                        [arr_currentTaskList addObject:taskDHolder];
                        
                    }else if([taskDHolder.str_taskStatus isEqualToString:@"c"]){
                        
                        [arr_completedTaskList addObject:taskDHolder];
                        
                    }else if([taskDHolder.str_taskStatus isEqualToString:@"d"]){
                        
                        [arr_deletedTaskList addObject:taskDHolder];
                    }
                  }else{
                    if ([taskDHolder.str_taskStatus isEqualToString:@"o"] && [taskDHolder.str_userId isEqualToString:sender]) {
                        
                        [arr_currentTaskList addObject:taskDHolder];
                        
                    }else if([taskDHolder.str_taskStatus isEqualToString:@"c"] && [taskDHolder.str_userId isEqualToString:sender]){
                        
                        [arr_completedTaskList addObject:taskDHolder];
                        
                    }else if([taskDHolder.str_taskStatus isEqualToString:@"d"] && [taskDHolder.str_userId isEqualToString:sender]){
                        
                        [arr_deletedTaskList addObject:taskDHolder];
                    }
                }
         }else
         {                
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"])
            {
                if (([taskDHolder.str_taskStatus isEqualToString:@"o"] && [taskDHolder.str_grade isEqualToString:sender]) || ([taskDHolder.str_taskStatus isEqualToString:@"o"] && [taskDHolder.str_userId isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID]] && [taskDHolder.str_createdBy isEqualToString:@"p"])){
                    
                    [arr_currentTaskList addObject:taskDHolder];
                    
                }else if (([taskDHolder.str_taskStatus isEqualToString:@"c"] && [taskDHolder.str_grade isEqualToString:sender])||([taskDHolder.str_taskStatus isEqualToString:@"c"] && [taskDHolder.str_userId isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID]] && [taskDHolder.str_createdBy isEqualToString:@"p"])){
                    
                    [arr_completedTaskList addObject:taskDHolder];
                    
                }else if(([taskDHolder.str_taskStatus isEqualToString:@"d"] && [taskDHolder.str_grade isEqualToString:sender]) || ([taskDHolder.str_taskStatus isEqualToString:@"d"] && [taskDHolder.str_userId isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID]] && [taskDHolder.str_createdBy isEqualToString:@"p"])){
                    
                    [arr_deletedTaskList addObject:taskDHolder];
                }
            }else{
                
                if ([taskDHolder.str_taskStatus isEqualToString:@"o"]){
                    
                    [arr_currentTaskList addObject:taskDHolder];
                    
                }else if ([taskDHolder.str_taskStatus isEqualToString:@"c"]){
                    
                    [arr_completedTaskList addObject:taskDHolder];
                    
                }else if([taskDHolder.str_taskStatus isEqualToString:@"d"]){
                    
                    [arr_deletedTaskList addObject:taskDHolder];
                }
            }
        }
    }
}
    NSLog(@"%ld",(long)segControl_task.selectedSegmentIndex);
    
    [HUD hide];
    [self btnSegControl_taskDidClicked:nil];
   
}
- (void)playerItemDidReachEnd:(NSNotification *)notification {
  
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),^ {
        
        self.navigationController.navigationBarHidden = NO;
        tabBarMCACtr.tabBar.hidden = NO;
        [view removeFromSuperview];
    });
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segue_taskDetail"]) {
        
        MCATaskDetailViewController *taskDetailViewCtr = (MCATaskDetailViewController*)[segue destinationViewController];
        
        taskDetailViewCtr.taskDetailDHolder = (MCATaskDetailDHolder*)sender;
    }
}

@end

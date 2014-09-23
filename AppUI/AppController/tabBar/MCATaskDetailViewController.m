//
//  MCATaskDetailViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 12/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCATaskDetailViewController.h"

@interface MCATaskDetailViewController ()

@end

@implementation MCATaskDetailViewController
@synthesize taskDetailDHolder;

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
    
    HUD = [AryaHUD new];
    [self.view addSubview:HUD];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteTaskDetailSuccess:) name:NOTIFICATION_DELETE_TASK_DETAIL_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(completeTaskDetailSuccess:) name:NOTIFICATION_COMPLETE_TASK_DETAIL_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteOrCompleteTaskDetailFailed:) name:NOTIFICATION_DELETE_COMPLETE_TASK_DETAIL_FAILED object:nil];
   
    
    //code for navigation bar
    if ([taskDetailDHolder.str_taskStatus isEqualToString:@"o"] && ![[NSUserDefaults standardUserDefaults]integerForKey:KEY_STUDENT_COUNT] > 0)
    {
        UIImage* img_delete = [UIImage imageNamed:@"delete.png"];
        CGRect img_deleteFrame = CGRectMake(0, 0, img_delete.size.width, img_delete.size.height);
        UIButton *btn_delete = [[UIButton alloc] initWithFrame:img_deleteFrame];
        [btn_delete setBackgroundImage:img_delete forState:UIControlStateNormal];
        [btn_delete addTarget:self
                    action:@selector(btnBar_deleteDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        [btn_delete setShowsTouchWhenHighlighted:YES];
        
        UIImage* img_edit = [UIImage imageNamed:@"edit.png"];
        CGRect img_editFrame = CGRectMake(0, 0, img_edit.size.width, img_edit.size.height);
        UIButton *btn_edit = [[UIButton alloc] initWithFrame:img_editFrame];
        [btn_edit setBackgroundImage:img_edit forState:UIControlStateNormal];
        [btn_edit addTarget:self
                      action:@selector(btnBar_editDidClicked:)
            forControlEvents:UIControlEventTouchUpInside];
        [btn_edit setShowsTouchWhenHighlighted:YES];
        
        UIBarButtonItem *btnBar_delete =[[UIBarButtonItem alloc] initWithCustomView:btn_delete];
        UIBarButtonItem *btnBar_edit =[[UIBarButtonItem alloc] initWithCustomView:btn_edit];
        
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_delete,btnBar_edit, nil]];
    }
    
    btn_complete.layer.cornerRadius = 3.0f;
    tbl_taskDetail.scrollEnabled = NO;
    tv_taskDetail.editable = NO;
    [tv_taskDetail setContentInset:UIEdgeInsetsMake(-5, 0, 5,0)];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self getLanguageStrings:nil];
}
#pragma mark - LANGUAGE_SUPPORT

-(void)getLanguageStrings:(id)sender{
    
//    self.navigationItem.title = [NSString languageSelectedStringForKey:@"task_detail"];
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE]isEqualToString:ENGLISH_LANG]) {
        
          tv_taskDetail.text = taskDetailDHolder.str_taskDetailEng;
    }else{
        
        tv_taskDetail.text = taskDetailDHolder.str_taskDetailSp;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IB_ACTION

-(void)btnBar_deleteDidClicked:(id)sender{
    
    MCAAlertView *alertView = [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"delete_msg"]
                                                     title:[NSString languageSelectedStringForKey:@"delete"]
                                                  delegate:self
                                                     btnOk:[NSString languageSelectedStringForKey:@"conform"]
                                                 btnCancel:[NSString languageSelectedStringForKey:@"cancel"]];
     alertView.tag = 1;
}
-(void)btnBar_editDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_editTask" sender:taskDetailDHolder];
}
-(IBAction)btnCompleteDidClicked:(id)sender{
    
    MCAAlertView *alertView = [MCAGlobalFunction showAlert:@"Do you want to complete the task?"
                                                     title:[NSString languageSelectedStringForKey:@"msg"]
                                                  delegate:self
                                                     btnOk:[NSString languageSelectedStringForKey:@"conform"]
                                                 btnCancel:[NSString languageSelectedStringForKey:@"cancel"]];
    
    alertView.tag = 2;
    
}
-(void)alertView:(MCAAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    MCAAlertView *mcaAlert = (MCAAlertView*)alertView;
    
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {          
            NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc]init];
            [dateFormatterTime setDateFormat:@"yyyy-MM-dd 00:00:00"];
            NSString *str_dateTime = [dateFormatterTime stringFromDate:[NSDate date]];
            
            taskDetailDHolder.str_taskStatus = @"d";
            
            NSMutableDictionary *info=[NSMutableDictionary new];
            [info setValue:str_dateTime forKey:@"updated_at"];
            [info setValue:@"d" forKey:@"task_status"];
            [info setValue:taskDetailDHolder.str_taskId forKey:@"task_id"];
            
            [info setValue:@"task_status" forKey:@"cmd"];

            NSString *str_jsonDeletetask = [NSString getJsonObject:info];
            
            [HUD showForTabBar];
            [self.view bringSubviewToFront:HUD];
            [self requestDeleteOrCompleteTask:str_jsonDeletetask];

        }
    }
}

#pragma mark -  UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return 72;
 
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    CustomTableViewCell *cell  = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:                                                 cellIdentifier forIndexPath:indexPath];
    NSMutableArray *leftUtilityButtons;
  
    if([taskDetailDHolder.str_taskStatus isEqualToString:@"o"] && ![[NSUserDefaults standardUserDefaults]integerForKey:KEY_STUDENT_COUNT] > 0){
       
         leftUtilityButtons  = [NSMutableArray new];
    }
    
        if ([taskDetailDHolder.str_taskPriority isEqualToString:@"h"]) {
            
            [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:252.0/255.0 green:109.0/255.0 blue:36.0/255.0  alpha:1.0]icon:[UIImage imageNamed:@"taskSelect.png"]];
            cell.lbl_taskPriority.text = [NSString languageSelectedStringForKey:@"higher"];
            cell.lbl_taskPriority.textColor = [UIColor colorWithRed:252.0/255.0 green:109.0/255.0 blue:36.0/255.0 alpha:1.0];
            cell.lbl_taskColor.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:109.0/255.0 blue:36.0/255.0  alpha:1.0];
            
        }else{
            
            [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:39.0/255.0 green:166.0/255.0 blue:213.0/255.0 alpha:1.0]icon:[UIImage imageNamed:@"taskSelect.png"]];
            cell.lbl_taskPriority.text = [NSString languageSelectedStringForKey:@"regular"];
            cell.lbl_taskPriority.textColor = [UIColor colorWithRed:39.0/255.0 green:166.0/255.0 blue:213.0/255.0 alpha:1.0];
            cell.lbl_taskColor.backgroundColor = [UIColor colorWithRed:39.0/255.0 green:166.0/255.0 blue:213.0/255.0 alpha:1.0];
        }
    
    cell.leftUtilityButtons = leftUtilityButtons;
    
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] isEqualToString:ENGLISH_LANG]) {
         cell.lbl_taskName.text =  taskDetailDHolder.str_taskNameEng;
    }else{
         cell.lbl_taskName.text =  taskDetailDHolder.str_taskNameSp;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    [dateFormatter1 setDateFormat:@"yyyy/MMM/dd"];
    NSDate *date_Temp =[dateFormatter dateFromString:taskDetailDHolder.str_taskStartDate];
    NSString *str_date = [dateFormatter1 stringFromDate:date_Temp];
    cell.lbl_taskStartDate.text = str_date;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
    
}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {            
            NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc]init];
            [dateFormatterTime setDateFormat:@"yyyy-MM-dd 00:00:00"];
            NSString *str_dateTime = [dateFormatterTime stringFromDate:[NSDate date]];
            
            taskDetailDHolder.str_taskStatus = @"c";
            
            NSMutableDictionary *info=[NSMutableDictionary new];
            [info setValue:str_dateTime forKey:@"updated_at"];
            [info setValue:@"c" forKey:@"task_status"];
            [info setValue:taskDetailDHolder.str_taskId forKey:@"task_id"];
            
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

#pragma mark - API CALLING

-(void)requestDeleteOrCompleteTask:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForDeleteOrCompleteTask:info :@"taskDetail"];
    }else{
        [HUD hide];
        [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"noInternetMsg"]];
    }
}
# pragma mark - NS_NOTIFICATION SELECTOR
-(void)deleteTaskDetailSuccess:(NSNotification*)notification
{
    [HUD hide];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)completeTaskDetailSuccess:(NSNotification*)notification{
    
    [HUD hide];
        
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message"
                                                   message:notification.object delegate:nil
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
            view_animationBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
        }else{
            view_animationBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        }
        
        view_animationBg.backgroundColor = [UIColor whiteColor];
        playerLayer.frame = view_animationBg.bounds;
        // Add it to your view's sublayers
        [view_animationBg.layer addSublayer:playerLayer];
        [self.view addSubview:view_animationBg];
        
        [player play];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[player currentItem]];
        
        tabBarMCACtr.tabBar.hidden = YES;
        self.navigationController.navigationBarHidden = YES;
    });
}
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),^ {
        
        self.navigationController.navigationBarHidden = NO;
        tabBarMCACtr.tabBar.hidden = NO;
        [view_animationBg removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    });
}
-(void)deleteOrCompleteTaskDetailFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segue_editTask"]) {
        
        MCAAddTaskViewController *editTaskViewCtr = (MCAAddTaskViewController*)[segue destinationViewController];
        editTaskViewCtr.taskEditDHolder = (MCATaskDetailDHolder*)sender;
        editTaskViewCtr.delegate = self;
    }
}
-(void)editTaskDetail:(MCATaskDetailDHolder *)taskDHolder{
    
    taskDetailDHolder = taskDHolder;
    tv_taskDetail.text = taskDetailDHolder.str_taskDetailEng;
    [tbl_taskDetail reloadData];
    
}
@end

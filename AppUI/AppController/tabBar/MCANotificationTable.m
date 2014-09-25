//
//  MCANotificationTable.m
//  MobileCollegeAdmin
//
//  Created by aditi on 24/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCANotificationTable.h"

@implementation MCANotificationTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
       [[NSBundle mainBundle] loadNibNamed:@"MCANotificationTable" owner:self options:nil];
        
        self.layer.borderWidth = 0.5f;
        
        [btn_cancel setTitle:[NSString languageSelectedStringForKey:@"cancel"] forState:UIControlStateNormal];
        [btn_reminder setTitle:[NSString languageSelectedStringForKey:@"tomorrow"] forState:UIControlStateNormal];
        
       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
       [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
       NSString * str_todayDate  = [dateFormatter stringFromDate:[NSDate date]];
       arr_updateNotifyList = [NSMutableArray new];
        
       arr_notifyTaskList = [[MCADBIntraction databaseInteractionManager]retrieveTodayTask:str_todayDate];
        
       tbl_notification = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 290, 264)];
       tbl_notification.delegate = self;
       tbl_notification.dataSource = self;
       [tbl_notification reloadData];
       
        tbl_notification.tableFooterView = [UIView new];
        
       [self addSubview:self.myView];
       [self.myView addSubview:tbl_notification];
        
       HUD = [AryaHUD new];
       [self addSubview:HUD];
        
    }
    
    return self;
}


#pragma mark - UITABLEVIEW DELEGATE AND DATA SOURCE

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
     return 36;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
     return 38;
   
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    // 1. The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,36)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1];
    
    // 3. Add an image
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(0, 0,tableView.frame.size.width, 36);
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.text = [NSString languageSelectedStringForKey:@"notification"];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:headerLabel];
    
    // 5. Finally return
    return headerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return arr_notifyTaskList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil)
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    
    
    MCATaskDetailDHolder *taskDHolder = (MCATaskDetailDHolder*)[arr_notifyTaskList objectAtIndex:indexPath.row];
    UILabel *lbl_taskName = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 240, 38)];
    
//    lbl_taskName.backgroundColor = [UIColor redColor];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] isEqualToString:ENGLISH_LANG]) {
         lbl_taskName.text = taskDHolder.str_taskNameEng;
    }else{
         lbl_taskName.text = taskDHolder.str_taskNameSp;
    }
    
    lbl_taskName.font = [UIFont systemFontOfSize:14.0f];
    lbl_taskName.adjustsFontSizeToFitWidth = YES;
    lbl_taskName.minimumScaleFactor = 7.0f;
    
    MCACustomButton *btn_selectTask = [MCACustomButton buttonWithType:UIButtonTypeCustom];
    btn_selectTask.frame = CGRectMake(240, 0, 38, 38);
    
    [btn_selectTask setImage:[UIImage imageNamed:@"blue_uncheckMark.png"]
                         forState:UIControlStateNormal];
    
    [btn_selectTask addTarget:self
                        action:@selector(btn_selectTaskDidClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    btn_selectTask.index = indexPath.row;
    btn_selectTask.tag = 1;
    [cell addSubview:btn_selectTask];
    [cell addSubview:lbl_taskName];
    tbl_notification.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    MCACustomButton *btn_temp = (MCACustomButton*)
//    
//    if (btn_temp.tag == 1) {
//        
//        [btn_temp setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
//        [arr_updateNotifyList addObject:[arr_notifyTaskList objectAtIndex:indexPath.row]];
//        btn_temp.tag = 2;
//        
//    }else{
//        
//        [btn_temp setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
//        [arr_updateNotifyList removeObject:[arr_notifyTaskList objectAtIndex:indexPath.row]];
//        btn_temp.tag = 1;
//    }

}
#pragma mark - IB_ACTION

-(IBAction)btnCancelDidClicked:(id)sender{
    
    [self removeFromSuperview];
    [self.delegate reminderView:nil];
}

-(IBAction)btnRemindDidClicked:(id)sender{
    
    NSMutableArray *arr_Temp = [NSMutableArray new];
    
    for (int i = 0; i <arr_updateNotifyList.count; i++) {
        
        MCATaskDetailDHolder *taskDHolder = (MCATaskDetailDHolder*)[arr_updateNotifyList objectAtIndex:i];
        NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd 00:00:00"];
        NSString *str_dateTmrw = [format stringFromDate:tomorrow];
        
        taskDHolder.str_taskSnoozeDate = str_dateTmrw;
        [arr_Temp addObject:taskDHolder];
    }
    
    if (arr_Temp.count > 0) {
        [[MCADBIntraction databaseInteractionManager]updateTaskSnoozeDate:arr_Temp];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString languageSelectedStringForKey:@"msg"]
                                                       message:[NSString languageSelectedStringForKey:@"reminder"]
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil, nil];
        
        [alert show];
        
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(),^ {
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            [self removeFromSuperview];
            [self.delegate reminderView:nil];
        });
    }
}
-(IBAction)btn_selectTaskDidClicked:(id)sender{
    
    MCACustomButton *btn_temp = (MCACustomButton*)sender;
    
    if (btn_temp.tag == 1) {
        
        [btn_temp setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
        [arr_updateNotifyList addObject:[arr_notifyTaskList objectAtIndex:btn_temp.index]];
        btn_temp.tag = 2;
        
    }else{
        
       [btn_temp setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
       [arr_updateNotifyList removeObject:[arr_notifyTaskList objectAtIndex:btn_temp.index]];
       btn_temp.tag = 1;
    }
}


@end

//
//  MCATaskViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 05/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"
#import "SWTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AVFoundation/AVFoundation.h"
#import <QuartzCore/QuartzCore.h>

#import "MCANotificationTable.h"

#import "ViewController.h"


@interface MCATaskViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate,ReminderListDelegate>{
    
    IBOutlet UISegmentedControl *segControl_task;
   
    IBOutlet UITableView *tbl_taskCurrent;
    IBOutlet UITableView *tbl_taskCompleted;
    IBOutlet UITableView *tbl_taskDeleted;
             UITableView *tbl_gradeList;
             UITableView *tbl_studentList;
                  UIView *view_transBg;
                  UIView *view;
    
    NSMutableDictionary *dict_taskList;
    
    NSMutableArray *arr_taskList;
    NSMutableArray *arr_taskDeletedList;
    NSMutableArray *arr_currentTaskList;
    NSMutableArray *arr_completedTaskList;
    NSMutableArray *arr_deletedTaskList;
    
    NSMutableArray *arr_deletedTaskDetail;
    NSMutableArray *arr_completedTaskDetail;
    NSMutableArray *arr_studentList;
           NSArray *arr_gradeList;
    
    UIView *view_notification ;
    UITableView *tbl_notification;
    
   
    AryaHUD *HUD;
}
-(IBAction)btnSegControl_taskDidClicked:(id)sender;

@property AVPlayer *videoPlayer;
@end

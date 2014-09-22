//
//  MCAAddTaskViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 09/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCATaskDetailDHolder.h"

@protocol TaskDetailEditDelegate <NSObject>
-(void)editTaskDetail:(MCATaskDetailDHolder*)taskDHolder;
@end

@interface MCAAddTaskViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UITextField *tx_taskName;
    IBOutlet UITextField *tx_chooseDate;
    IBOutlet UITextField *tx_priority;
    IBOutlet UITextView  *tv_description;
    
    IBOutlet UILabel *lbl_taskName;
    IBOutlet UILabel *lbl_startDate;
    IBOutlet UILabel *lbl_priority;
    IBOutlet UILabel *lbl_description;
    
    UIActionSheet *sheet_datePicker;
    UITableView   *tbl_priority;
    UIDatePicker  *datePicker;
    NSString      *str_dateSelected;
    NSString      *className;
    UIView        *view_transBg;
    
    UIBarButtonItem *btnBar_done;
    UIBarButtonItem *btnBar_cancel;
    
    NSMutableArray  *arr_priority;
    NSString*json_TaskString;
    AryaHUD *HUD;
}

@property(nonatomic,strong)MCATaskDetailDHolder *taskEditDHolder;
-(IBAction)selectPriorityDidClicked:(id)sender;
-(IBAction)chooseDateDidClicked:(id)sender;
-(IBAction)btnBarDoneDidClicked:(id)sender;

@property(nonatomic,assign)id<TaskDetailEditDelegate> delegate;
@end

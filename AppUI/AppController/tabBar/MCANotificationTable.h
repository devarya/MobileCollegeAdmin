//
//  MCANotificationTable.h
//  MobileCollegeAdmin
//
//  Created by aditi on 24/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReminderListDelegate <NSObject>
-(void)reminderView:(id)sender;

@end

@interface MCANotificationTable : UIView<UITableViewDelegate,UITableViewDataSource>{
    
   IBOutlet UITableView *tbl_notification;
   IBOutlet UIButton *btn_cancel;
   IBOutlet UIButton *btn_reminder;
    
   NSMutableArray *arr_notifyTaskList;
   NSMutableArray *arr_updateNotifyList;
    
   AryaHUD *HUD;
}
@property(nonatomic,strong)IBOutlet UIView *myView;
@property(nonatomic,assign)id<ReminderListDelegate>delegate;
-(IBAction)btnCancelDidClicked:(id)sender;
-(IBAction)btnRemindDidClicked:(id)sender;
@end

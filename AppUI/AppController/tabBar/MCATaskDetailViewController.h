//
//  MCATaskDetailViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 12/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "CustomTableViewCell.h"
#import "MCATaskDetailDHolder.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AVFoundation/AVFoundation.h"
#import "MCAAddTaskViewController.h"


@interface MCATaskDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate,TaskDetailEditDelegate>{
    
    IBOutlet UITableView *tbl_taskDetail;
    
    IBOutlet UIButton *btn_complete;
    IBOutlet UITextView *tv_taskDetail;
                 UIView *view_animationBg;
    
    AryaHUD *HUD;
    
}
-(IBAction)btnCompleteDidClicked:(id)sender;
@property AVPlayer *videoPlayer;
@property(nonatomic,strong)MCATaskDetailDHolder *taskDetailDHolder;

@end

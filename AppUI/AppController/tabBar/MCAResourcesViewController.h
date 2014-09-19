//
//  MCAResourcesViewController.h
//  MobileCollegeAdmin
//
//  Created by rashmi on 9/12/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCAResourcesDetailViewController.h"

@interface MCAResourcesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tbl_resources;
    NSMutableArray *arr_resources;
    AryaHUD *HUD;
}

@property(nonatomic,strong)MCAResourcesCatDHolder *reCatDHolder;

@end

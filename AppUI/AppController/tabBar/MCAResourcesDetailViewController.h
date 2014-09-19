//
//  MCAResourcesDetailViewController.h
//  MobileCollegeAdmin
//
//  Created by rashmi on 9/12/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCAResourceCell.h"

@interface MCAResourcesDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView* tbl_url;
    NSMutableArray *arr_url;
}

@property (strong, nonatomic)MCAResourceCell *detailCell;
@property(nonatomic, strong)MCAResourcesDHolder* reDHolder;
@property (strong, nonatomic)NSMutableArray *arr_resources;


@end

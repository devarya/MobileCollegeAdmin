//
//  MCAResourcesBookController.h
//  MobileCollegeAdmin
//
//  Created by Dongjie Zhang on 9/16/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCAResourcesBookDHolder.h"

@interface MCAResourcesBookController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tbl_book;
    NSMutableArray *arr_book;
    AryaHUD *HUD;
}



@end

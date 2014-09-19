//
//  MCAResourcesCategoryViewController.h
//  MobileCollegeAdmin
//
//  Created by rashmi on 9/12/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCAResourcesCategoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UITableView *tbl_resourcesCategory;
    
    NSMutableArray *arr_resourcesCategory;

    AryaHUD *HUD;
}
@end

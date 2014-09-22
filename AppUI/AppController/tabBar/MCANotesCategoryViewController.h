//
//  MCANotesCategoryViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 29/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCANotesCategoryViewController :UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UITableView *tbl_notesCategory;
    NSMutableArray *arr_notesCategory;
    AryaHUD *HUD;
}
@end
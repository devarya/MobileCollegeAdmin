//
//  MCAResourcesBookController.m
//  MobileCollegeAdmin
//
//  Created by Dongjie Zhang on 9/16/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAResourcesBookController.h"

@interface MCAResourcesBookController ()

@end

@implementation MCAResourcesBookController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    HUD = [AryaHUD new];
    [self.view addSubview:HUD];
    
    arr_book = [NSMutableArray new];
    
    self.navigationItem.title = @"Resources";
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resourceBookFailed:) name:NOTIFICATION_RESOURCE_BOOK_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resourceBookSuccess:) name:NOTIFICATION_RESOURCE_BOOK_SUCCESS object:nil];
    
    [self getResourcesBook];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getResourcesBook{
    
    NSMutableDictionary * info = [NSMutableDictionary new];
    
    [info setValue:@"get_book_for_parent" forKey:@"cmd"];
    [info setValue:@"en_us" forKey:@"language_code"];
    
    NSString *str_jsonNotes = [NSString getJsonObject:info];
    [HUD showForTabBar];
    [self.view bringSubviewToFront:HUD];
    [self requestResourceBook:str_jsonNotes];
    
}
#pragma mark - API CALLING

-(void)requestResourceBook:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        
        [[MCARestIntraction sharedManager] requestForResourcesBook:info];
        
    }else{
        
        [HUD hide];
    }
}

#pragma mark - NSNOTIFICATION SELECTOR

-(void)resourceBookSuccess:(NSNotification*)notification{
    
    [HUD hide];
    arr_book = notification.object;
    [tbl_book reloadData];
    //[self writeToFile:nil];
    
}
-(void)resourceBookFailed:(NSNotification*)notification{
    
    [HUD hide];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 42;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr_book.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCAResourcesBookDHolder *reDHolder = (MCAResourcesBookDHolder*)[arr_book objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"resourcesBookCell";
    UITableViewCell  *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    UILabel *lbl_catName = (UILabel *)[cell.contentView viewWithTag:2];
    lbl_catName.text = reDHolder.str_book_name;
    
    UIImageView *img=(UIImageView *)[cell.contentView viewWithTag:1];
    [img removeFromSuperview];
    img = nil;
    img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 26, 26)];
    img.tag = 1;
    [cell.contentView addSubview:img];
    UIImage *img_web = [UIImage imageNamed:@"web.png"];
    [img setImage:img_web];
  
    tbl_book.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MCAResourcesBookDHolder *reDHolder = (MCAResourcesBookDHolder*)[arr_book objectAtIndex:indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reDHolder.str_url]];
}
@end

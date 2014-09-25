//
//  MCANotesCategoryViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 29/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCANotesCategoryViewController.h"
#import "MCANotesViewController.h"

@interface MCANotesCategoryViewController ()

@end

@implementation MCANotesCategoryViewController

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
    // Do any additional setup after loading the view.
    
    //Arya HUD
    HUD=[AryaHUD new];
    [self.view addSubview:HUD];
    
    arr_notesCategory = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notesCategoryFailed:) name:NOTIFICATION_NOTES_CATEGORY_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notesCategorySuccess:) name:NOTIFICATION_NOTES_CATEGORY_SUCCESS object:nil];
    
    UIImage* img_export = [UIImage imageNamed:@"export.png"];
    CGRect img_exportFrame = CGRectMake(0, 0, img_export.size.width, img_export.size.height);
    UIButton *btn_export = [[UIButton alloc] initWithFrame:img_exportFrame];
    [btn_export setBackgroundImage:img_export forState:UIControlStateNormal];
    [btn_export addTarget:self
                    action:@selector(btnExportDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [btn_export setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *btnBar_export =[[UIBarButtonItem alloc] initWithCustomView:btn_export];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_export,nil]];
    
    [self getNotesCategory:nil];
    
    [MCALocalStoredFolder createRootDir];
    [MCALocalStoredFolder createSubRootDir:@"Notes"];
    
    tbl_notesCategory.tableFooterView = [UIView new];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self getLanguageStrings:nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getNotesCategory:(id)sender{
    
    NSMutableDictionary * info = [NSMutableDictionary new];
    
    [info setValue:@"get_note_category" forKey:@"cmd"];
    [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] forKey:@"language_code"];
    
    NSString *str_jsonCategory = [NSString getJsonObject:info];
    [HUD showForTabBar];
    [self.view bringSubviewToFront:HUD];
    [self requestNotesCategory:str_jsonCategory];
    
}
#pragma mark - LANGUAGE_SUPPORT

-(void)getLanguageStrings:(id)sender{
    
    self.navigationItem.title = [NSString languageSelectedStringForKey:@"tab_notes"];
}
#pragma mark - IB_ACTION

-(void)btnExportDidClicked:(id)sender{
 
    [self performSegueWithIdentifier:@"segue_dropboxList" sender:nil];
}

#pragma mark -  UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 42;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arr_notesCategory.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"notesCell";
    UITableViewCell  *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
    MCANotesCatDHolder *notesDHolder = (MCANotesCatDHolder*)[arr_notesCategory objectAtIndex:indexPath.row];
    
    UILabel *lbl_catName = (UILabel *)[cell.contentView viewWithTag:2];
    lbl_catName.text = notesDHolder.str_notesCatName;
    
    UIImageView *img_cat=(UIImageView *)[cell.contentView viewWithTag:1];
    [img_cat removeFromSuperview];
    img_cat = nil;
    img_cat = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 26, 26)];
    img_cat.tag = 1;
    [cell.contentView addSubview:img_cat];
    
    [img_cat setImageWithUrl:[NSURL URLWithString:notesDHolder.str_notesCatImage]
               andPlaceHoder:[UIImage imageNamed:PLACEHOLDER_IMAGE]
                  andNoImage:[UIImage imageNamed:NO_IMAGE]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MCANotesCatDHolder *notesDHolder = (MCANotesCatDHolder*)[arr_notesCategory objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"segue_notes" sender:notesDHolder];
   
}
#pragma mark - API CALLING

-(void)requestNotesCategory:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        
        [[MCARestIntraction sharedManager]requestForNotesCategory:info];
        
    }else{
        
        [HUD hide];
        arr_notesCategory = [[MCADBIntraction databaseInteractionManager]retrieveNotesCatList:nil];
        [tbl_notesCategory reloadData];
    }
}

#pragma mark - NSNOTIFICATION SELECTOR

-(void)notesCategorySuccess:(NSNotification*)notification{
    
    [HUD hide];
    arr_notesCategory = notification.object;
    
    [[MCADBIntraction databaseInteractionManager]deleteNotesCatList:nil];
    [[MCADBIntraction databaseInteractionManager]insertNotesCatList:arr_notesCategory];
    [tbl_notesCategory reloadData];
}
-(void)notesCategoryFailed:(NSNotification*)notification{
    
    [HUD hide];
}

#pragma mark - OTHER_METHOD

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segue_notes"]) {
        
        MCANotesViewController *noteViewCtr = (MCANotesViewController*)[segue destinationViewController];
        noteViewCtr.notesCatDHolder = (MCANotesCatDHolder*)sender;
    }
}

@end

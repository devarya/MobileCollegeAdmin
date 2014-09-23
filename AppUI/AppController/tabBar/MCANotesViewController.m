//
//  MCANotesViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 28/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCANotesViewController.h"
#import "MCANotesDetailViewController.h"

@interface MCANotesViewController ()

@end

@implementation MCANotesViewController
@synthesize notesCatDHolder;
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
    
    arr_notes = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notesFailed:) name:NOTIFICATION_NOTES_FAILED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notesSuccess:) name:NOTIFICATION_NOTES_SUCCESS object:nil];
    
    self.navigationItem.title = notesCatDHolder.str_notesCatName;
    
    UIImage* img_add = [UIImage imageNamed:@"add.png"];
    CGRect img_addFrame = CGRectMake(0, 0, img_add.size.width, img_add.size.height);
    UIButton *btn_add = [[UIButton alloc] initWithFrame:img_addFrame];
    [btn_add setBackgroundImage:img_add forState:UIControlStateNormal];
    [btn_add addTarget:self
                action:@selector(btnBar_addDidClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [btn_add setShowsTouchWhenHighlighted:YES];
    
    UIImage* img_refresh = [UIImage imageNamed:@"refresh.png"];
    CGRect img_gradeFrame = CGRectMake(0, 0, img_refresh.size.width, img_refresh.size.height);
    UIButton *btn_refresh = [[UIButton alloc] initWithFrame:img_gradeFrame];
    [btn_refresh setBackgroundImage:img_refresh forState:UIControlStateNormal];
    [btn_refresh addTarget:self
                    action:@selector(btnBar_refreshDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [btn_refresh setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *btnBar_add =[[UIBarButtonItem alloc] initWithCustomView:btn_add];
    UIBarButtonItem *btnBar_refresh =[[UIBarButtonItem alloc] initWithCustomView:btn_refresh];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_add, btnBar_refresh, nil]];
    
    [self readDirectory:nil];
    if (arr_dirContents.count > 0) {
      
        [tbl_notes reloadData];
        
    }else{
        
        [self getNotes:notesCatDHolder.str_notesCatId];
    }
    
    [MCALocalStoredFolder createCategoryDir:notesCatDHolder.str_notesCatName];
    tbl_notes.tableFooterView = [[UIView alloc] init];
  
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self readDirectory:nil];
    [tbl_notes reloadData];
}
-(void)getNotes:(id)sender{
        
    NSMutableDictionary * info = [NSMutableDictionary new];
    
    [info setValue:@"get_notes" forKey:@"cmd"];
    [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] forKey:@"language_code"];
    [info setValue:sender forKey:@"notes_cat_id"];
    
    NSString *str_jsonNotes = [NSString getJsonObject:info];
    [HUD showForTabBar];
    [self.view bringSubviewToFront:HUD];
    [self requestNotes:str_jsonNotes];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IB_ACTION

-(void)btnBar_addDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_addNotes" sender:nil];
}
-(void)btnBar_refreshDidClicked:(id)sender{
    
    [self getNotes:notesCatDHolder.str_notesCatId];
}
#pragma mark -  UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 42;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return arr_dirContents.count;
   
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
    
    cell.textLabel.text = [arr_dirContents objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.7f;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    tbl_notes.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MCANotesDHolder *notesDHolder ;
    notesDHolder = [MCANotesDHolder new];
    notesDHolder.str_notesName = [arr_dirContents objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segue_notesDetail" sender:notesDHolder];
    
}
#pragma mark - API CALLING

-(void)requestNotes:(NSString*)info{
        
    if ([MCAGlobalFunction isConnectedToInternet]) {
        
        [[MCARestIntraction sharedManager]requestForNotes:info];
        
    }else{
        
        [HUD hide];
    }
}

#pragma mark - NSNOTIFICATION SELECTOR

-(void)notesSuccess:(NSNotification*)notification{
    
    [HUD hide];
    arr_notes = notification.object;
    
    [self writeToFile:nil];
    
}
-(void)notesFailed:(NSNotification*)notification{
    
    [HUD hide];
}
#pragma mark - OTHER_METHOD

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segue_notesDetail"]) {
        
        MCANotesDetailViewController *noteDetailViewCtr = (MCANotesDetailViewController*)[segue destinationViewController];
        noteDetailViewCtr.notesDHolder = (MCANotesDHolder*)sender;
    }
}
#pragma mark - DOCUMENT_DIRECTORY_METHOD

-(void)writeToFile:(id)sender{
    
    [HUD showForTabBar];
    
    for (int i = 0; i < arr_notes.count; i++)
    {
        MCANotesDHolder *notesDHolder = (MCANotesDHolder*)[arr_notes objectAtIndex:i];
        
        [MCALocalStoredFolder createSubCategoryDir:notesDHolder.str_notesName];
        
        NSString *documentsDirectory = [NSString stringWithFormat:@"%@/%@",[MCALocalStoredFolder getCategoryDir],notesDHolder.str_notesName];
        
        //make a file name to write the data to using the documents directory:
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",notesDHolder.str_notesName]];
        //create content - four lines of text
        NSString *content = notesDHolder.str_notesDesc;
        
        for (int i = 0; i < notesDHolder.arr_notesImage.count; i++) {
            
            UIImageView *img =[UIImageView new];
            img.image = [UIImage imageWithData:
                         [NSData dataWithContentsOfURL:
                          [NSURL URLWithString: [notesDHolder.arr_notesImage objectAtIndex:i]]]];
            
            NSString *imageName = [[notesDHolder.arr_notesImage objectAtIndex:i] lastPathComponent];
            NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
            NSData *imageData = UIImagePNGRepresentation(img.image);
            [imageData writeToFile:imagePath
                        atomically:NO];
        }
        
        //save content to the documents directory
        [content writeToFile:filePath
                  atomically:NO
                    encoding:NSStringEncodingConversionAllowLossy
                       error:nil];
        [HUD hide];
    }
    
    [self readDirectory:nil];
    [tbl_notes reloadData];
}
-(void)readDirectory:(NSString *)fileName
{ 
    NSString *documentsDirectory = [MCALocalStoredFolder getSubRootDir];
    NSString *filePath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",notesCatDHolder.str_notesCatName]];
    NSError * error;
    arr_dirContents =  [[NSFileManager defaultManager]
                                    contentsOfDirectoryAtPath:filePath error:&error];
    
}
@end

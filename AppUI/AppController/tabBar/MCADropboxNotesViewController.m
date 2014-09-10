
//
//  MCADropboxNotesViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 08/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCADropboxNotesViewController.h"
#import "MCADropBoxNotesListViewController.h"

@interface MCADropboxNotesViewController ()

@end

@implementation MCADropboxNotesViewController
@synthesize str_catName;

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
    
    HUD = [AryaHUD new];
    [self.view addSubview:HUD];
    
    arrtest = [NSMutableArray new];
    k = 0;
    
    arr_selectedNotesList = [NSMutableArray  new];
    
    [self readDirectory:nil];
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    if (![[DBSession sharedSession] isLinked]) {
        
        [btn_dropBox setTitle:@"Login To Dropbox" forState:UIControlStateNormal];
    }else{
        [btn_dropBox setTitle:@"Export" forState:UIControlStateNormal];
    }
    
   btn_dropBox.layer.cornerRadius = 12.0f;
   tbl_notesList.tableFooterView = [[UIView alloc] init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IB_ACTION

-(void)btnSelectDidClicked:(id)sender{
    
    MCACustomButton *btn_temp = (MCACustomButton*)sender;
    
    // NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:btn_temp.index];
    if (btn_temp.tag == 1) {
        
        [btn_temp setBackgroundImage:[UIImage imageNamed:@"blueCheckmark.png"]
                            forState:UIControlStateNormal];
        [arr_selectedNotesList addObject:[arr_notesList objectAtIndex:btn_temp.index]];
        btn_temp.tag = 2;
        
    }else{
        
        [btn_temp setBackgroundImage:[UIImage imageNamed:@""]
                            forState:UIControlStateNormal];
        [arr_selectedNotesList removeObject:[arr_notesList objectAtIndex:btn_temp.index]];
        btn_temp.tag = 1;
        
    }
}
-(IBAction)btnDropboxDidClicked:(id)sender{
    
    if (![[DBSession sharedSession] isLinked]) {
        
        [[DBSession sharedSession] linkFromController:self];
    }else
    {
        [HUD showForTabBar];
        if(arr_selectedNotesList.count > 0){
            
            if ([MCAGlobalFunction isConnectedToInternet]) {
                [self readToFile:nil];
            }else{
                [HUD hide];
                [MCAGlobalFunction showAlert:NET_NOT_AVAIALABLE];
            }
        }else{
            
            [HUD hide];
            [MCAGlobalFunction showAlert:@"Select a file to upload"];
        }
    }
}

#pragma mark -  UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 42;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arr_notesList.count;
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
    
    UILabel *lbl_notes = (UILabel*)[cell.contentView viewWithTag:2];
    lbl_notes.text = [arr_notesList objectAtIndex:indexPath.row];
    
    MCACustomButton *btn_select = (MCACustomButton*)[cell.contentView viewWithTag:1];
    btn_select.layer.cornerRadius = 2.0f;
    btn_select.layer.borderWidth = 0.5f;
    [btn_select setBackgroundImage:[UIImage imageNamed:@""]
                          forState:UIControlStateNormal];
    [btn_select addTarget:self
                   action:@selector(btnSelectDidClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    btn_select.index = indexPath.row;
    btn_select.tag = 1;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    //    cell.textLabel.text = [arr_catList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.7f;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str_tempPath = [NSString stringWithFormat:@"%@/%@",str_catName,[arr_notesList objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:@"segue_notesFile" sender:str_tempPath];
    
}

#pragma mark - DROPBOX_DELEGATE

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    
    k = ++k;
    
    if (k == arrtest.count) {
        
        [HUD hide];
        [tbl_notesList reloadData];
        arr_selectedNotesList = [NSMutableArray new];
        k = 0;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message"
                                                       message:@"File uploaded to dropbox successfully." delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil, nil];
        
        [alert show];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(),^ {
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            
        });

    }
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    
    NSLog(@"File upload failed with error: %@", error);
    [HUD hide];
    k = ++k;
}
#pragma mark - DOCUMENT_DIRECTORY_METHOD

-(void)readDirectory:(NSString *)fileName
{
    NSString *documentsDirectory = [MCALocalStoredFolder getSubRootDir];
    NSString *subDocDirectory = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",str_catName]];
    NSError * error;
    arr_notesList =  [[NSFileManager defaultManager]
                contentsOfDirectoryAtPath:subDocDirectory error:&error];
    [tbl_notesList reloadData];
    
}
-(void)readToFile:(id)sender{
    
    for (int i = 0 ; i <arr_selectedNotesList.count; i++)
    {
        NSError * error;
        NSString *documentsDirectory = [MCALocalStoredFolder getSubRootDir];
        NSString *subDocDirectory = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",str_catName]];
        NSString *filePath = [subDocDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",[arr_selectedNotesList objectAtIndex:i]]];
        NSArray *files=  [[NSFileManager defaultManager]
                                   contentsOfDirectoryAtPath:filePath error:&error];
        
        NSString *destDir = [NSString stringWithFormat:@"/%@/%@",@"Notes",[arr_selectedNotesList objectAtIndex:i]];
        
        [arrtest addObjectsFromArray:files];
//        [arrtest addObject:[arr_selectedNotesList objectAtIndex:i]];
        
        for (int j = 0; j< files.count; j++)
            {
                NSString *fileName = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@",[files objectAtIndex:j]]];
//                NSData *retrieveData = [NSData dataWithContentsOfFile:fileName];
//                
//                NSString *str_Temp = [[NSString alloc]initWithData:retrieveData encoding:NSUTF8StringEncoding];
//                if (str_Temp) {
//                    
//                    [self.restClient uploadFile:[files objectAtIndex:k] toPath:destDir withParentRev:nil fromPath:fileName];
//                }
//                
//                UIImage *img_Temp = [UIImage imageWithData:retrieveData];
//                if (img_Temp) {
                
                     [self.restClient uploadFile:[files objectAtIndex:j] toPath:destDir withParentRev:nil fromPath:fileName];
//                }
            }
      }
}
#pragma mark - OTHER_METHOD

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segue_notesFile"]) {
        
        MCADropBoxNotesListViewController *noteListViewCtr = (MCADropBoxNotesListViewController*)[segue destinationViewController];
        noteListViewCtr.str_noteFilePath = sender;
        
    }
}
@end

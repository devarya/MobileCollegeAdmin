//
//  MCAUserProfileViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 11/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAUserProfileViewController.h"

@interface MCAUserProfileViewController ()

@end

@implementation MCAUserProfileViewController
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
    
    HUD=[AryaHUD new];
    [self.view addSubview:HUD];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UserProfileEditSuccess:) name:NOTIFICATION_USER_PROFILE_EDIT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UserProfileEditFailed:) name:NOTIFICATION_USER_PROFILE_EDIT_FAILED object:nil];
    
    view_parent.hidden = YES;
    view_stud.hidden = YES;
        
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"])
    {
        view_parent.hidden = NO;
        view_parent.frame = CGRectMake(view_parent.frame.origin.x, 0, view_parent.frame.size.width, view_parent.frame.size.height);
        
        tx_pname.text = [[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_NAME];
        tx_pemail.text = [[NSUserDefaults standardUserDefaults]valueForKey:KEY_SIGNIN_ID];
        tx_pzipcode.text = [[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ZIPCODE];
        
    }else{
     
        view_stud.hidden = NO;
        view_stud.frame = CGRectMake(view_stud.frame.origin.x, 0, view_stud.frame.size.width, view_stud.frame.size.height);
        
        arr_SelectPersonList = [[NSArray alloc]initWithObjects:@"Me",@"My Parents",@"My Brother/Sister",@"My Grandparents",@"No idea", nil];

        tx_sname.text = [[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_NAME];
        tx_semail.text = [[NSUserDefaults standardUserDefaults]valueForKey:KEY_SIGNIN_ID];
        tx_szipcode.text = [[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ZIPCODE];
        tx_sfirstPerson.text = [[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_FAMILY];
        tx_sgrade.text = [[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_GRADE];
        tx_sgrade.text = [tx_sgrade.text stringByAppendingString:@"th"];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tx_pemail resignFirstResponder];
    [tx_pname resignFirstResponder];
    [tx_pzipcode resignFirstResponder];
    
    [tx_semail resignFirstResponder];
    [tx_sname resignFirstResponder];
    [tx_szipcode resignFirstResponder];
    
    [tbl_SelectPerson removeFromSuperview];
    [view_Bg removeFromSuperview];
    [self keyboardDisappeared];
    self.view.alpha = 1.0f;
   
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self keyboardDisappeared];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == tx_szipcode) {
         [self keyboardAppeared];
    }
   
    return  YES;
}
-(void) keyboardAppeared
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    
    if (IS_IPHONE_5) {
        self.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    }else{
        self.view.frame = CGRectMake(0,-90, self.view.frame.size.width, self.view.frame.size.height);
        
    }
    
    [UIView commitAnimations];
}
-(void) keyboardDisappeared
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    if ([[UIScreen mainScreen] bounds].size.height==568)
    {
        self.view.frame =CGRectMake(0, 64,  self.view.frame.size.width, self.view.frame.size.height);
        //this is iphone 5
    } else
    {
        self.view.frame =CGRectMake(0, 64,  self.view.frame.size.width, self.view.frame.size.height);
        // this is iphone 4
    }
    [UIView commitAnimations];
}

#pragma mark - IB_ACTION

-(IBAction)btnSelectPersonDidCliked:(id)sender{
        
    if (IS_IPHONE_5) {
        view_Bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        view_Bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    view_Bg.backgroundColor = [UIColor blackColor];
    view_Bg.layer.opacity = 0.6f;
    [self.view addSubview:view_Bg];
    tbl_SelectPerson = [[UITableView alloc]initWithFrame:CGRectMake(8, 84, 302, 210)];
    tbl_SelectPerson.layer.borderWidth = 0.5f;
    [self.view addSubview:tbl_SelectPerson];
    tbl_SelectPerson.delegate = self;
    tbl_SelectPerson.dataSource = self;
    [tbl_SelectPerson reloadData];
    
}

-(IBAction)btnDoneDidClicked:(id)sender{
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"])
    {
        if (![tx_pname.text isEqualToString:@""])
        {
            NSMutableDictionary *info = [NSMutableDictionary new];
            if (tx_pzipcode.text.length != 0)
            {
                if (tx_pzipcode.text.length == 5)
                {
                    [info setValue:tx_pzipcode.text forKey:@"zipcode"];
                    
                }else{
                    [MCAGlobalFunction showAlert:ZIP_CODE_MSG];
                    return;
                }
            }else{
                [info setValue:@"" forKey:@"zipcode"];
                
            }
            
            [info setValue:tx_pname.text forKey:@"user_name"];
            [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_FAMILY] forKey:@"family"];
            [info setValue:[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_GRADE] forKey:@"grade"];
            [info setValue:tx_pzipcode.text forKey:@"zipcode"];
            [info setValue:@"edit_profile" forKey:@"cmd"];
            NSString *str_jsonProfileEdit = [NSString getJsonObject:info];
            
            [HUD showForTabBar];
            [self requestUserProfileEdit:str_jsonProfileEdit];
            
        }else{
            
            [MCAGlobalFunction showAlert:INVALID_USERNAME];
        }
    }else
    {
        if (![tx_sname.text isEqualToString:@""])
        {
            NSMutableDictionary *info = [NSMutableDictionary new];
            if (tx_szipcode.text.length != 0)
            {
                if (tx_szipcode.text.length == 5)
                {
                    [info setValue:tx_szipcode.text forKey:@"zipcode"];
                    
                }else{
                    [MCAGlobalFunction showAlert:ZIP_CODE_MSG];
                    return;
                }
            }else{
                [info setValue:@"" forKey:@"zipcode"];
                
            }
            
            [info setValue:tx_sname.text forKey:@"user_name"];
            [info setValue:tx_sfirstPerson.text forKey:@"family"];
            [info setValue:tx_sgrade.text forKey:@"grade"];
            [info setValue:tx_szipcode.text forKey:@"zipcode"];
            [info setValue:@"edit_profile" forKey:@"cmd"];
            NSString *str_jsonProfileEdit = [NSString getJsonObject:info];
            
            [HUD showForTabBar];
            [self requestUserProfileEdit:str_jsonProfileEdit];
            
        }else{
            
            [MCAGlobalFunction showAlert:INVALID_USERNAME];
        }
    }
}
#pragma mark - UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 34;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 36;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tbl_SelectPerson.frame.size.width,38)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1];
    
    // 3. Add an image
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(0, 0, tbl_SelectPerson.frame.size.width, 38);
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.text = @"Select Person";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:headerLabel];
    
    // 5. Finally return
    return headerView;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_SelectPersonList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = [arr_SelectPersonList objectAtIndex:indexPath.row];
    tbl_SelectPerson.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tx_sfirstPerson.text = [arr_SelectPersonList objectAtIndex:indexPath.row];
    [view_Bg removeFromSuperview];
    [tbl_SelectPerson removeFromSuperview];
    self.view.alpha = 1.0f;
    
}

#pragma mark - API CALLING

-(void)requestUserProfileEdit:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForUserProfileEdit:info];
    }else{
        [HUD hide];
        [MCAGlobalFunction showAlert:NET_NOT_AVAIALABLE];
    }
}

#pragma mark - NSNOTIFICATION SELECTOR

-(void)UserProfileEditSuccess:(NSNotification*)notification{
    
    [HUD hide];
    [tx_pname resignFirstResponder];
    [tx_pzipcode resignFirstResponder];
    [tx_sname resignFirstResponder];
    [tx_szipcode resignFirstResponder];
    
    MCALoginDHolder *loginDHolder = notification.object;
    [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_userName forKey:KEY_USER_NAME];
    [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_zipCode forKey:KEY_USER_ZIPCODE];
    [[NSUserDefaults standardUserDefaults]setValue:loginDHolder.str_family forKey:KEY_USER_FAMILY];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
     UIAlertView *alert   = [[UIAlertView alloc]initWithTitle:@"Message"
                                            message:@"Profile updated successfully."
                                           delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:nil, nil];
    [alert show];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),^ {
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    });

}
-(void)UserProfileEditFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}

@end

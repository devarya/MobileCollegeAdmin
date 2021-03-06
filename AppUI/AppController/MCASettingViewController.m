
//
//  MCASettingViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 11/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCASettingViewController.h"

@interface MCASettingViewController ()

@end

@implementation MCASettingViewController{
    
    BOOL isTaskAlertPush;
    BOOL isTaskAlertEmail;
    BOOL isPriorityHigh;
    BOOL isPriorityRegular;
}

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
    
    arr_studParList = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestSettingSuccess:) name:NOTIFICATION_SETTING_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestSettingFailed:) name:NOTIFICATION_SETTING_FAILED object:nil];
    
    /*Task Alert */
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_NOTIFY_BY_PUSH] isEqualToString:@"1"]) {
       [btn_taskAlertPush setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
        isTaskAlertPush = YES;
        
    }else{
        [btn_taskAlertPush setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
        isTaskAlertPush = NO;
    }
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_NOTIFY_BY_EMAIL] isEqualToString:@"1"]) {
        [btn_taskAlertEmail setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
        isTaskAlertEmail = YES;
        
    }else{
        [btn_taskAlertEmail setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
        isTaskAlertEmail = NO;
    }
    
    
    /*Priority Alert*/
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_PRIORITY_HIGH] isEqualToString:@"1"]) {
        [btn_priorityAlertHigh setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
        isPriorityHigh = YES;
        
    }else{
        [btn_priorityAlertHigh setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
        isPriorityHigh = NO;
    }
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_PRIORITY_REGULAR] isEqualToString:@"1"]) {
        [btn_priorityAlertRegular setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
        isPriorityRegular = YES;
        
    }else{
        [btn_priorityAlertRegular setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
        isPriorityRegular = NO;
    }
    
    btn_add.layer.borderWidth = 0.5f;
    btn_add.layer.borderColor=[UIColor colorWithRed:32.0/255.0 green:36.0/255.0 blue:48.0/255.0 alpha:1].CGColor;
    btn_add.layer.cornerRadius = 3.0f;
    
    btn_viewStudParent.layer.borderWidth = 0.5f;
    btn_viewStudParent.layer.borderColor=[UIColor colorWithRed:32.0/255.0 green:36.0/255.0 blue:48.0/255.0 alpha:1].CGColor;
    btn_viewStudParent.layer.cornerRadius = 3.0f;
    
    tbl_studParList.hidden = YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [view_Bg removeFromSuperview];
    [tbl_langList removeFromSuperview];
    tbl_studParList.hidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self getLanguageStrings:nil];
}

#pragma mark - LANGUAGE_SUPPORT

-(void)getLanguageStrings:(id)sender{
    
    self.navigationItem.title = [NSString languageSelectedStringForKey:@"setting"];
    lbl_lang.text =[NSString languageSelectedStringForKey:@"tx_language"];
    lbl_profile.text =[NSString languageSelectedStringForKey:@"profile"];
    lbl_taskAlert.text =[NSString languageSelectedStringForKey:@"notification"];
    lbl_priorityAlert.text =[NSString languageSelectedStringForKey:@"priority_alert"];
    lbl_changePwd.text =[NSString languageSelectedStringForKey:@"change_pass"];
 
    lbl_priorityDesc.text = [NSString languageSelectedStringForKey:@"priority_descr"];
    push.text = [NSString languageSelectedStringForKey:@"chk_push"];
    email.text =[NSString languageSelectedStringForKey:@"chk_email"];
    high.text =[NSString languageSelectedStringForKey:@"high"];
    regular.text =[NSString languageSelectedStringForKey:@"regular"];
    
    [btn_add setTitle:[NSString languageSelectedStringForKey:@"add"] forState:UIControlStateNormal];
    
    arr_langList = [NSMutableArray arrayWithObjects:[NSString languageSelectedStringForKey:@"english"],
                    [NSString languageSelectedStringForKey:@"spanish"], nil];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"]) {
        
        [btn_viewStudParent setTitle:[NSString languageSelectedStringForKey:@"viewST"]
                            forState:UIControlStateNormal];
        lbl_parStud.text =[NSString languageSelectedStringForKey:@"add_student"];
        
    }else{
        
        [btn_viewStudParent setTitle:[NSString languageSelectedStringForKey:@"my_parent"]
                            forState:UIControlStateNormal];
        lbl_parStud.text = [NSString languageSelectedStringForKey:@"addParent"];
        arr_studParList = [[MCADBIntraction databaseInteractionManager]retrieveStudList:nil];
        
        if (arr_studParList.count >0) {
            btn_viewStudParent.frame = CGRectMake(114, 281, 194, 30);
            btn_add.hidden = YES;
        }
    }
}
#pragma mark - IB_ACTION

-(IBAction)btnSelectLangDidClicked:(id)sender{
    
    if (IS_IPHONE_5) {
        view_Bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        view_Bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    view_Bg.backgroundColor = [UIColor blackColor];
    view_Bg.layer.opacity = 0.6f;
    [self.view addSubview:view_Bg];
    
    tbl_langList = [UITableView new];
    tbl_langList.delegate = self;
    tbl_langList.dataSource = self;
    tbl_langList.layer.borderWidth = 0.5f;
    tbl_langList.scrollEnabled = NO;
    tbl_langList.frame = CGRectMake(10, 100, 300,118);
    [tbl_langList reloadData];
    [self.view addSubview:tbl_langList];
    [self.view bringSubviewToFront:tbl_langList];
}

-(IBAction)btnChangePwdDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_changePwd" sender:nil];
    
}
-(IBAction)btnUserProfileDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_userProfile" sender:nil];
    
}
-(IBAction)btnAddStudParDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_add" sender:nil];
}

-(IBAction)btnTaskAlertPushDidCliked:(id)sender{
    
    if (isTaskAlertPush) {
        
        [btn_taskAlertPush setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
        isTaskAlertPush = NO;
        
    }else{
        
        [btn_taskAlertPush setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
        isTaskAlertPush = YES;
    }
    
    btn_taskAlertPush.tag = 1;
    btn_taskAlertEmail.tag = 0;
    btn_priorityAlertHigh.tag = 0;
    btn_priorityAlertRegular.tag = 0;
    
    [self setNotificationSetting:nil];
}
-(IBAction)btnTaskAlertEmailDidCliked:(id)sender{
    
    if (isTaskAlertEmail) {
        
        [btn_taskAlertEmail setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
        isTaskAlertEmail = NO;
        
    }else{
        
        [btn_taskAlertEmail setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
        isTaskAlertEmail = YES;
    }
    
    btn_taskAlertPush.tag = 0;
    btn_taskAlertEmail.tag = 1;
    btn_priorityAlertHigh.tag = 0;
    btn_priorityAlertRegular.tag = 0;
    
    [self setNotificationSetting:nil];
}

-(IBAction)btnPriorityAlertHighDidClicked:(id)sender{
    
    if (isPriorityHigh) {
        
        if(isPriorityRegular){
         
            [btn_priorityAlertHigh setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
            isPriorityHigh = NO;
            
        }else{
            
              [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"priorityMessage"]];
              return;
        }
        
    }else{
        
        if (isPriorityRegular) {
            
            [btn_priorityAlertHigh setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
            isPriorityHigh = YES;
            
        }else{
            
            [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"priorityMessage"]];
            return;
        }
    }
    
    btn_taskAlertPush.tag = 0;
    btn_taskAlertEmail.tag = 0;
    btn_priorityAlertHigh.tag = 1;
    btn_priorityAlertRegular.tag = 0;
    
     [self setNotificationSetting:nil];
}
-(IBAction)btnPriorityAlertRegularDidClicked:(id)sender{
    
    if (isPriorityRegular) {
        
        if (isPriorityHigh) {
            [btn_priorityAlertRegular setImage:[UIImage imageNamed:@"blue_uncheckMark.png"] forState:UIControlStateNormal];
            isPriorityRegular = NO;

        }else{
            [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"priorityMessage"]];
            return;
        }
    }else{
        if (isPriorityHigh) {
            
            [btn_priorityAlertRegular setImage:[UIImage imageNamed:@"blue_checkMark.png"] forState:UIControlStateNormal];
            isPriorityRegular = YES;
        }else{
            [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"priorityMessage"]];
            return;
        }
    }
    
    btn_taskAlertPush.tag = 0;
    btn_taskAlertEmail.tag = 0;
    btn_priorityAlertHigh.tag = 0;
    btn_priorityAlertRegular.tag = 1;
    
     [self setNotificationSetting:nil];
}

-(IBAction)btnViewStudParentDidClicked:(id)sender{
    
    arr_studParList = [[MCADBIntraction databaseInteractionManager]retrieveStudList:nil];
    
    if (arr_studParList.count > 0) {
           
        if (IS_IPHONE_5) {
            view_Bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
        }else{
            view_Bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        }
        
        view_Bg.backgroundColor = [UIColor blackColor];
        view_Bg.layer.opacity = 0.6f;
        [self.view addSubview:view_Bg];
  
        tbl_studParList.layer.borderWidth = 0.5f;
        tbl_studParList.layer.cornerRadius = 1.0f;
        
        if (arr_studParList.count > 4) {
            
            tbl_studParList.frame = CGRectMake(10, 100, 300,198);
        }else{
            tbl_studParList.frame = CGRectMake(10, 100, 300, arr_studParList.count*40+38);
        }
        
        tbl_studParList.hidden = NO;
        
        [tbl_studParList reloadData];
        [self.view bringSubviewToFront:tbl_studParList];
        
    }else{
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"]){
            
            [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"no_student_connected"]];
            
        }else{
            
            [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"no_parent_connected"]];
        }
    }
}
-(void)setNotificationSetting:(id)sender{
    
    NSMutableDictionary *info = [NSMutableDictionary new];
    
    [info setValue:@"" forKey:@"notify_by_email"];
    [info setValue:@"" forKey:@"notify_by_push"];
    [info setValue:@"" forKey:@"priority_high"];
    [info setValue:@"" forKey:@"priority_regular"];
    
    if (btn_taskAlertPush.tag == 1) {
        
        if (isTaskAlertPush) {
            [info setValue:@"1" forKey:@"notify_by_push"];
        }else{
            [info setValue:@"0" forKey:@"notify_by_push"];
        }
        
    }else if (btn_taskAlertEmail.tag == 1){
        
        if (isTaskAlertEmail) {
            [info setValue:@"1" forKey:@"notify_by_email"];
        }else{
            [info setValue:@"0" forKey:@"notify_by_email"];
        }
        
    }else if (btn_priorityAlertHigh.tag == 1){
        
        if (isPriorityHigh) {
            [info setValue:@"1" forKey:@"priority_high"];
        }else{
            [info setValue:@"0" forKey:@"priority_high"];
        }
        
    }else if (btn_priorityAlertRegular.tag == 1){
        
        if (isPriorityRegular) {
            [info setValue:@"1" forKey:@"priority_regular"];
        }else{
            [info setValue:@"0" forKey:@"priority_regular"];
        }
    }
    
    [info setValue:@"notification_setting" forKey:@"cmd"];
    NSString *str_jsonNotificationSetting = [NSString getJsonObject:info];
    [HUD showForTabBar];
    [self requestNotificationSetting:str_jsonNotificationSetting];
    
}
#pragma mark - UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 38;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     // 1. The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,40)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1];
    
    // 3. Add an image
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(0,0,300,40);
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    
    if (tableView == tbl_studParList) {
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"]){
            
             headerLabel.text = [NSString languageSelectedStringForKey:@"connected_st_list"];
            
        }else{
            
             headerLabel.text = @"Parent";
        }
        
    }else{
        
         headerLabel.text = [NSString languageSelectedStringForKey:@"select_language"];
    }
   
    headerLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:headerLabel];
    
    // 5. Finally return
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tbl_studParList) {
         return arr_studParList.count;
    }else{
        return arr_langList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tbl_studParList) {
        
        NSString *cellIdentifier =@"studParCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:cellIdentifier];
        
        
        MCASignUpDHolder *studParentDHolder = (MCASignUpDHolder*)[arr_studParList objectAtIndex:indexPath.row];
        
        UILabel *lbl_name = (UILabel*)[cell.contentView viewWithTag:1];
        UILabel *lbl_email = (UILabel*)[cell.contentView viewWithTag:2];
        
        lbl_name.text = studParentDHolder.str_userName;
        lbl_email.text = studParentDHolder.str_signinId;
        lbl_email.font = [UIFont systemFontOfSize:14.0f];
        lbl_name.font = [UIFont systemFontOfSize:14.0f];
        
        lbl_email.textAlignment = NSTextAlignmentRight;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tbl_studParList.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
        return cell;

    }else{
        
        NSString *cellIdentifier =@"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:cellIdentifier];
    
        cell.textLabel.text = [arr_langList objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        tbl_langList.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
        
        MCACustomButton *btn_selectLang= [MCACustomButton buttonWithType:UIButtonTypeCustom];
        btn_selectLang.frame = CGRectMake( 252, 0, 40, 40);
        btn_selectLang.index = indexPath.row;
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] isEqualToString:ENGLISH_LANG]) {
            
            if (indexPath.row == 0) {
             
                [btn_selectLang setImage:[UIImage imageNamed:@"blue_checkMark.png"]
                                          forState:UIControlStateNormal];
            }else{
                [btn_selectLang setImage:[UIImage imageNamed:@"blue_uncheckMark.png"]
                                          forState:UIControlStateNormal];
            }
         }else{
              if (indexPath.row == 0) {
                  
                  [btn_selectLang setImage:[UIImage imageNamed:@"blue_uncheckMark.png"]
                                            forState:UIControlStateNormal];
              }else{
                  [btn_selectLang setImage:[UIImage imageNamed:@"blue_checkMark.png"]
                                            forState:UIControlStateNormal];
              }
        }
        [cell.contentView addSubview:btn_selectLang];
        return cell;        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == tbl_langList) {
        
        [view_Bg removeFromSuperview];
        [tbl_langList removeFromSuperview];
        
        if (indexPath.row == 0) {
            
            [[NSUserDefaults standardUserDefaults]setValue:ENGLISH_LANG forKey:KEY_LANGUAGE_CODE];
            tx_lang.text = [NSString languageSelectedStringForKey:@"english"];
            
        }else{
            [[NSUserDefaults standardUserDefaults]setValue:SPANISH_LANG forKey:KEY_LANGUAGE_CODE];
            tx_lang.text = [NSString languageSelectedStringForKey:@"spanish"];
        }
        
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[MCAGlobalData sharedManager]getTabBarTitle:nil];
    }
    
    [self getLanguageStrings:nil];
}

#pragma mark - API CALLING

-(void)requestNotificationSetting:(NSString*)info{
    
    if ([MCAGlobalFunction isConnectedToInternet]) {
        [[MCARestIntraction sharedManager]requestForNotificationSetting:info];
    }else{
        [HUD hide];
        [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"noInternetMsg"]];
    }
}
#pragma mark - NSNOTIFICATION SELECTOR

-(void)requestSettingSuccess:(NSNotification*)notification{
    
    [HUD hide];
    [[NSUserDefaults standardUserDefaults]setValue:[notification.object valueForKey:@"notify_by_email"] forKey:KEY_NOTIFY_BY_EMAIL];
    [[NSUserDefaults standardUserDefaults]setValue:[notification.object valueForKey:@"notify_by_push"] forKey:KEY_NOTIFY_BY_PUSH];
    [[NSUserDefaults standardUserDefaults]setValue:[notification.object valueForKey:@"priority_high"] forKey:KEY_PRIORITY_HIGH];
    [[NSUserDefaults standardUserDefaults]setValue:[notification.object valueForKey:@"priority_regular"] forKey:KEY_PRIORITY_REGULAR];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIAlertView *alert   = [[UIAlertView alloc]initWithTitle:[NSString languageSelectedStringForKey:@"msg"]
                                                 message:[NSString languageSelectedStringForKey:@"setting_updated"]
                                                 delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil, nil];
    [alert show];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),^ {
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
      
    });
}
-(void)requestSettingFailed:(NSNotification*)notification{
    
    [HUD hide];
    [MCAGlobalFunction showAlert:notification.object];
}

@end

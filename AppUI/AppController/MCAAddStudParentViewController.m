//
//  MCAAddStudParentViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 16/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAAddStudParentViewController.h"

@interface MCAAddStudParentViewController ()

@end

@implementation MCAAddStudParentViewController

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
    
    view_parent.hidden = YES;
    view_stud.hidden = YES;
    
    arr_GradeList = [[NSArray alloc]initWithObjects:@"12th",@"11th",@"10th", nil];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"]) {
        
        view_parent.hidden = NO;
        view_parent.frame = CGRectMake(view_parent.frame.origin.x, 0, view_parent.frame.size.width, view_parent.frame.size.height);
        self.navigationItem.title = @"Add Student";
            
    }else{
        
        view_stud.hidden = NO;
        view_stud.frame = CGRectMake(view_stud.frame.origin.x, 0, view_stud.frame.size.width, view_stud.frame.size.height);
       self.navigationItem.title = @"Add Parent";
    }
    
    btn_addParent.layer.cornerRadius = 3.0f;
    btn_addParent.layer.masksToBounds = YES;
    
    btn_addStudent.layer.cornerRadius = 3.0f;
    btn_addStudent.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignTextField:nil];
    [view_Bg removeFromSuperview];
    [tbl_StudGradeList removeFromSuperview];
}
-(void)resignTextField:(id)sender{
    
    [tx_parEmail resignFirstResponder];
    [tx_parName resignFirstResponder];
    [tx_studEmail resignFirstResponder];
    [tx_studGrade resignFirstResponder];
    [tx_studName resignFirstResponder];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - IB_ACTION

-(IBAction)btnGradeDidClicked:(id)sender{
    
    if (IS_IPHONE_5) {
        view_Bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    }else{
        view_Bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    }
    
    view_Bg.backgroundColor = [UIColor blackColor];
    view_Bg.layer.opacity = 0.6f;
    [self.view addSubview:view_Bg];
    tbl_StudGradeList = [[UITableView alloc]initWithFrame:CGRectMake(10, 102, 300, 110)];
 
    tbl_StudGradeList.layer.borderWidth = 0.5f;
    tbl_StudGradeList.layer.cornerRadius = 3.0f;
    [self.view addSubview:tbl_StudGradeList];
    [self.view bringSubviewToFront:tbl_StudGradeList];
    
    //    tbl_StudGradeList.backgroundColor = [UIColor redColor];
    tbl_StudGradeList.delegate = self;
    tbl_StudGradeList.dataSource = self;
    [tbl_StudGradeList reloadData];
    
}

#pragma mark - UITABLEVIEW DELEGATE AND DATASOURCE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 26;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 28;
   
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,30)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithRed:39.0/255 green:166.0/255 blue:213.0/255 alpha:1];
    
    // 3. Add an image
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(12,2,298,22);
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14];
    headerLabel.text = @"Select Grade";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:headerLabel];
    
    // 5. Finally return
    return headerView;
 }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       return arr_GradeList.count;
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    cell = [[UITableViewCell alloc]
        initWithStyle:UITableViewCellStyleDefault
        reuseIdentifier:cellIdentifier];

    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.textLabel.text = [arr_GradeList objectAtIndex:indexPath.row];
    tbl_StudGradeList.separatorInset=UIEdgeInsetsMake(0.0, 0 + 1.0, 0.0, 0.0);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tx_studGrade.text = [arr_GradeList objectAtIndex:indexPath.row];
    [view_Bg removeFromSuperview];
    [tbl_StudGradeList removeFromSuperview];
}
@end

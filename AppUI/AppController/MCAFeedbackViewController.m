//
//  MCAFeedbackViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 25/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAFeedbackViewController.h"

@interface MCAFeedbackViewController ()

@end

@implementation MCAFeedbackViewController

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
   
}
-(void)viewWillAppear:(BOOL)animated{
     [self getLanguageStrings:nil];
}

#pragma mark - LANGUAGE_SUPPORT

-(void)getLanguageStrings:(id)sender{
    
    self.navigationItem.title = [NSString languageSelectedStringForKey:@"feedback"];
    lbl_rate.text = [NSString languageSelectedStringForKey:@"rate"];
    lbl_support.text = [NSString languageSelectedStringForKey:@"support"];
    lbl_upgrade.text = [NSString languageSelectedStringForKey:@"upgrade"];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MCATermUseViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 10/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCATermUseViewController.h"

@interface MCATermUseViewController ()

@end

@implementation MCATermUseViewController

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
    
    [self setNeedsStatusBarAppearanceUpdate];
  
    web_view.delegate = self;
    
  if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] isEqualToString:ENGLISH_LANG]){
      
      [web_view loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"terms_en" ofType:@"html"]isDirectory:NO]]];

  }else{
      
      [web_view loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"terms_es" ofType:@"html"]isDirectory:NO]]];

   }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IB_ACTION

-(IBAction)btnBackDidClicked:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

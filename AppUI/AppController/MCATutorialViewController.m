//
//  MCATutorialViewController.m
//  ESafeMove
//
//  Created by vishnu on 16/12/13.
//  Copyright (c) 2013 Aryavrat. All rights reserved.
//

#import "MCATutorialViewController.h"

@interface MCATutorialViewController ()

@end

@implementation MCATutorialViewController

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

    btnPrevious.hidden = YES;
    [scrollView setContentSize:CGSizeMake(320*5,30)];
    for (int i=0; i<5; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*320, scrollView.bounds.origin.y, 320, scrollView.bounds.size.height)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"tutorial%d.png",i]];
        [scrollView addSubview:imageView];
    }
    preContentOffSet = scrollView.contentOffset.x;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView1{
    
    NSInteger tempContentOffSetX = scrollView.contentOffset.x;

    if (preContentOffSet>tempContentOffSetX) {
        
        btnNext.hidden = NO;
        if (tempContentOffSetX>=0) {
            
            if (tempContentOffSetX==0) {
                btnPrevious.hidden = YES;
            }
            
            if (tempContentOffSetX%320==0) {
                
                preContentOffSet = scrollView.contentOffset.x;
                pageControl.currentPage = scrollView.contentOffset.x/320;
            }
        }
        
    }else if(preContentOffSet<tempContentOffSetX){
        
        btnPrevious.hidden = NO;
        if (tempContentOffSetX<=320*4) {
            
            if (tempContentOffSetX==320*4) {
                btnNext.hidden = YES;
            }
            
            if (tempContentOffSetX%320==0) {
                
                preContentOffSet = scrollView.contentOffset.x;
                pageControl.currentPage = scrollView.contentOffset.x/320;
            }
        }
    }
}

#pragma mark IB_ACTION

-(IBAction)btnPrevious:(id)sender{
    
    NSInteger tempContentOffSetX = scrollView.contentOffset.x;
    if (tempContentOffSetX>=320) {

        [scrollView setContentOffset:CGPointMake(tempContentOffSetX-320, scrollView.bounds.origin.y) animated:YES];
    }
}

-(IBAction)btnNext:(id)sender{
    
    NSInteger tempContentOffSetX = scrollView.contentOffset.x;
    if (tempContentOffSetX+320<=320*4 ) {
        
        [scrollView setContentOffset:CGPointMake(tempContentOffSetX+320, scrollView.bounds.origin.y) animated:YES];
    }
    
}

-(IBAction)btnBackDidClicked:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

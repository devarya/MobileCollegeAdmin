//
//  MCANotesDetailViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 29/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCANotesDetailViewController.h"


@interface MCANotesDetailViewController ()

@end

@implementation MCANotesDetailViewController
@synthesize notesDHolder;
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
    
    arr_scrollImages = [NSMutableArray new];
    
    [HUD showForTabBar];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self readToFile:nil];
    });
    
    tv_noteDesc.layer.borderWidth = 0.5f;
    tv_noteDesc.layer.cornerRadius = 3.0f;
    tv_noteDesc.editable = NO;
    
    //navigation Bar Button
    
    UIImage* img_delete = [UIImage imageNamed:@"delete.png"];
    CGRect img_deleteFrame = CGRectMake(0, 0, img_delete.size.width, img_delete.size.height);
    UIButton *btn_delete = [[UIButton alloc] initWithFrame:img_deleteFrame];
    [btn_delete setBackgroundImage:img_delete forState:UIControlStateNormal];
    [btn_delete addTarget:self
                   action:@selector(btnBar_deleteDidClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [btn_delete setShowsTouchWhenHighlighted:YES];
    
    UIImage* img_edit = [UIImage imageNamed:@"edit.png"];
    CGRect img_editFrame = CGRectMake(0, 0, img_edit.size.width, img_edit.size.height);
    UIButton *btn_edit = [[UIButton alloc] initWithFrame:img_editFrame];
    [btn_edit setBackgroundImage:img_edit forState:UIControlStateNormal];
    [btn_edit addTarget:self
                 action:@selector(btnBar_editDidClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [btn_edit setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *btnBar_delete =[[UIBarButtonItem alloc] initWithCustomView:btn_delete];
    UIBarButtonItem *btnBar_edit =[[UIBarButtonItem alloc] initWithCustomView:btn_edit];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnBar_delete,btnBar_edit, nil]];
    
//    [MCALocalStoredFolder createSubCategoryDir:notesDHolder.str_notesName];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self getLanguageStrings:nil];
}
#pragma mark - LANGUAGE_SUPPORT

-(void)getLanguageStrings:(id)sender{
    
    self.navigationItem.title = [NSString languageSelectedStringForKey:@"ndetail"];
    
}
#pragma mark - IB_ACTION

-(void)btnBar_editDidClicked:(id)sender{
    
    [self performSegueWithIdentifier:@"segue_editNotes" sender:notesDHolder];
}
-(void)btnBar_deleteDidClicked:(id)sender{
    
    MCAAlertView *alertView = [MCAGlobalFunction
                               showAlert:[NSString languageSelectedStringForKey:@"do_you_want_delete_msg"]
                                   title:[NSString languageSelectedStringForKey:@"delete"]
                                   delegate:self
                                   btnOk:[NSString languageSelectedStringForKey:@"conform"]
                                   btnCancel:[NSString languageSelectedStringForKey:@"cancel"]];
    
    alertView.tag = 1;
}
-(void)alertView:(MCAAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *documentsDirectory = [MCALocalStoredFolder getCategoryDir];
        NSString *filePath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",notesDHolder.str_notesName]];
        
        [MCALocalStoredFolder deleteSubCategory:filePath];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)btn_removeScrollVDidClicked:(id)sender{
    
    UIButton *btn_temp = (UIButton*)sender;
    [btn_temp removeFromSuperview];
    [scrollV_images removeFromSuperview];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}
-(void)editNoteDetail:(id)sender{
    
    notesDHolder.str_notesName = sender;
    [self readToFile:nil];
}

#pragma mark - UISCROLLVIEW_METHOD

//-(void)getImageScrollView:(id)sender{
//    
//    [HUD showForTabBar];
//    scrollV_noteImages.delegate = self;
//    scrollV_noteImages.scrollEnabled = YES;
//    int scrollheight = 60;
//    scrollV_noteImages.contentSize = CGSizeMake(300,scrollheight);
//    
//    int yOffset = 0;
//    int xOffset = 0;
//    
//    for(int index=0; index < [notesDHolder.arr_notesImage count]; index++)
//    {
//        UIImageView *img = [[UIImageView alloc] init];
//        img.bounds = CGRectMake(10, 10, 68, 68);
//        img.frame = CGRectMake(xOffset, yOffset+5, 68, 68);
//        
//        [img setImageWithUrl:[NSURL URLWithString:[notesDHolder.arr_notesImage objectAtIndex:index]]
//               andPlaceHoder:[UIImage imageNamed:PLACEHOLDER_IMAGE]
//                  andNoImage:[UIImage imageNamed:NO_IMAGE]];
//        
//        [arr_scrollImages insertObject:img atIndex:index];
//        scrollV_noteImages.contentSize = CGSizeMake(300 ,110+yOffset);
//        [scrollV_noteImages addSubview:[arr_scrollImages objectAtIndex:index]];
//        
//        xOffset += 78;
//        if (xOffset>300)
//        {
//            xOffset = 0;
//            yOffset += 78;
//        }
//    }
//}
-(void)getDirImageScrollView:(id)sender{
  
    scrollV_noteImages.delegate = self;
    scrollV_noteImages.scrollEnabled = YES;
    int scrollheight = 60;
    scrollV_noteImages.contentSize = CGSizeMake(300,scrollheight);
    
    int yOffset = 0;
    int xOffset = 0;
    
    for(int index=0; index < [notesDHolder.arr_notesImage count]; index++)
    {
        MCACustomImageV *imgV = [[MCACustomImageV alloc] init];
        imgV.bounds = CGRectMake(10, 10, 68, 68);
        imgV.frame = CGRectMake(xOffset, yOffset+5, 68, 68);
        imgV.image = [notesDHolder.arr_notesImage objectAtIndex:index];
        
        [arr_scrollImages insertObject:imgV atIndex:index];
        scrollV_noteImages.contentSize = CGSizeMake(300 ,110+yOffset);
        [scrollV_noteImages addSubview:[arr_scrollImages objectAtIndex:index]];
        
        imgV.userInteractionEnabled = YES;
        imgV.imageIndex=index;
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(scrollViewImageDidClicked:)];
        tapped.numberOfTapsRequired = 1;
        [imgV addGestureRecognizer:tapped];
        
        xOffset += 78;
        if (xOffset>300)
        {
            xOffset = 0;
            yOffset += 78;
        }
    }
}
-(void)scrollViewImageDidClicked:(UITapGestureRecognizer*)sender{
    
    MCACustomImageV *imgV_temp = (MCACustomImageV*)sender.view;
    
    UIButton *btn_removeScrollV = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_removeScrollV.frame = CGRectMake(292, -2, 30, 30);
    [btn_removeScrollV setBackgroundImage:[UIImage imageNamed:@"delete4.png"]
                                 forState:UIControlStateNormal];
    [btn_removeScrollV addTarget:self
                          action:@selector(btn_removeScrollVDidClicked:)
                forControlEvents:UIControlEventTouchUpInside];
    
    if(IS_IPHONE_5){
         scrollV_images = [[UIScrollView alloc]initWithFrame:CGRectMake(5, 5, 310, 445)];
         [scrollV_images setContentSize:CGSizeMake(320*notesDHolder.arr_notesImage.count,440)];
    }else{
         scrollV_images = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x , self.view.bounds.origin.y+4, self.view.bounds.size.width, 358)];
        
         [scrollV_images setContentSize:CGSizeMake(320*notesDHolder.arr_notesImage.count,352)];
    }
    
    scrollV_images.backgroundColor = [UIColor whiteColor];
    scrollV_images.layer.shadowOffset = CGSizeMake(5.0f,5.0f);
    scrollV_images.layer.shadowRadius = 5.0f;
    scrollV_images.layer.shadowColor = [UIColor blackColor].CGColor;
    scrollV_images.layer.shadowOpacity = 1.0f;
    scrollV_images.layer.masksToBounds = NO;
    scrollV_images.layer.borderColor = [UIColor grayColor].CGColor;
    scrollV_images.layer.borderWidth = 1.0f;

    
    [self.view addSubview:btn_removeScrollV];
    [self.view addSubview:scrollV_images];
    [self.view bringSubviewToFront:btn_removeScrollV];
    
    for (int i=0; i<notesDHolder.arr_notesImage.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i*320), scrollV_images.bounds.origin.y+ 4, 320, scrollV_images.bounds.size.height - 8)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [notesDHolder.arr_notesImage objectAtIndex:i];
        [scrollV_images addSubview:imageView];
        
    }
    
    [scrollV_images setContentOffset:CGPointMake(imgV_temp.imageIndex *320, scrollV_images.bounds.origin.y) animated:NO];
    
    preContentOffSet = scrollV_images.contentOffset.x;
    
    UISwipeGestureRecognizer *gesture;
    gesture=[[UISwipeGestureRecognizer alloc]
             initWithTarget:self
             action:@selector(rightSlide:)];
    [gesture setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [scrollV_images addGestureRecognizer:gesture];
    
    gesture=[[UISwipeGestureRecognizer alloc]
             initWithTarget:self
             action:@selector(leftSlide:)];
    [gesture setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [scrollV_images addGestureRecognizer:gesture];
    
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
}
-(IBAction)leftSlide:(UISwipeGestureRecognizer*)sender{
    
    NSInteger tempContentOffSetX = scrollV_images.contentOffset.x;
    if (tempContentOffSetX >= 320) {
        
        [scrollV_images setContentOffset:CGPointMake(tempContentOffSetX - 320, scrollV_images.bounds.origin.y) animated:YES];
    }
}

-(IBAction)rightSlide:(UISwipeGestureRecognizer*)sender{
    
    NSInteger tempContentOffSetX = scrollV_images.contentOffset.x;
    if (tempContentOffSetX + 320<= 320*notesDHolder.arr_notesImage.count - 1) {
        
        [scrollV_images setContentOffset:CGPointMake(tempContentOffSetX + 320, scrollV_images.bounds.origin.y) animated:YES];
    }
}
#pragma mark - DOCUMENT_DIRECTORY_METHOD

-(void)readToFile:(id)sender{
     
    NSString *documentsDirectory = [MCALocalStoredFolder getCategoryDir];
    NSString *filePath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",notesDHolder.str_notesName]];
    NSError * error;
    NSArray* files = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:filePath error:&error];
     
     notesDHolder.arr_notesImage = [NSMutableArray new];
     
     for (int i = 0; i < files.count; i++)
     {
         NSString *fileName = [filePath stringByAppendingString:[NSString stringWithFormat:@"/%@",[files objectAtIndex:i]]];
         NSData *retrieveData = [NSData dataWithContentsOfFile:fileName];
         
         NSString *str_Temp = [[NSString alloc]initWithData:retrieveData encoding:NSUTF8StringEncoding];
         if (str_Temp) {
             
             notesDHolder.str_notesDesc = str_Temp;
         }
         
         UIImage *img_Temp = [UIImage imageWithData:retrieveData];
         if (img_Temp) {
             
             [notesDHolder.arr_notesImage addObject:img_Temp];
         }
     }
    
    lbl_noteName.text = notesDHolder.str_notesName;
    tv_noteDesc.text = notesDHolder.str_notesDesc;
    [self getDirImageScrollView:nil];
     
    [HUD hide];
}

#pragma mark - OTHER_METHOD
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segue_editNotes"]) {
        
        MCAAddEditNotesViewController *addEditViewCtr = (MCAAddEditNotesViewController*)[segue destinationViewController];
        addEditViewCtr.delegate = self;
        addEditViewCtr.notesDHolder = (MCANotesDHolder*)sender;
    }
}

@end

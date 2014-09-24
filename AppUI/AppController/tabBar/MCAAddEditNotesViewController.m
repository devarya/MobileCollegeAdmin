//
//  MCAAddNotesViewController.m
//  MobileCollegeAdmin
//
//  Created by aditi on 03/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAAddEditNotesViewController.h"

@interface MCAAddEditNotesViewController ()

@end

@implementation MCAAddEditNotesViewController
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
    hud = [AryaHUD new];
    [self.view addSubview:hud];
    
    arr_scrollImages = [NSMutableArray  new];
    
    btn_camera.layer.cornerRadius = 12.0f;
    btn_camera.layer.masksToBounds = YES;
    
    tv_description.layer.borderWidth = 0.5f;
    tv_description.layer.cornerRadius = 3.0f;
    tv_description.layer.masksToBounds = YES;
    
    tv_description.text = [NSString languageSelectedStringForKey:@"etDescText"];
    tv_description.textColor = [UIColor lightGrayColor];
    
    NSUInteger numberOfViewControllersOnStack = [self.navigationController.viewControllers count];
    UIViewController *parentViewController = self.navigationController.viewControllers[numberOfViewControllersOnStack - 2];
    Class parentVCClass = [parentViewController class];
    className = NSStringFromClass(parentVCClass);
    
    if ([className isEqualToString:@"MCANotesViewController"]) {
         self.navigationItem.title = [NSString languageSelectedStringForKey:@"note"];
         notesDHolder = [MCANotesDHolder new];
         notesDHolder.arr_notesImage = [NSMutableArray new];
        
    }else{
        
        self.navigationItem.title = [NSString languageSelectedStringForKey:@"note"];
        tx_noteTitle.text = notesDHolder.str_notesName;
        tv_description.text = notesDHolder.str_notesDesc;
        tv_description.textColor = [UIColor blackColor];
        [self getImageScrollView:nil];
        
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [tx_noteTitle resignFirstResponder];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self getLanguageStrings:nil];
}
#pragma mark - LANGUAGE_SUPPORT

-(void)getLanguageStrings:(id)sender{
    
    lbl_title.text = [NSString languageSelectedStringForKey:@"title"];
    lbl_description.text = [NSString languageSelectedStringForKey:@"description"];
    lbl_images.text = [NSString languageSelectedStringForKey:@"image"];
    
    tx_noteTitle.placeholder = [NSString languageSelectedStringForKey:@"etTText"];
    
    [btn_camera setTitle:[NSString languageSelectedStringForKey:@"camera"] forState:UIControlStateNormal];
}
#pragma mark - UI_TEXTFIELD/UI_TEXTVIEW DELEGATE

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([[textView text] isEqualToString:[NSString languageSelectedStringForKey:@"etDescText"]]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
   return  YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([[textView text] length] == 0) {
        textView.text = [NSString languageSelectedStringForKey:@"etDescText"];
        textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [tv_description resignFirstResponder];
        //        [self keyboardDisappeared];
    }
    return YES;
}

#pragma mark - IB_ACTION

-(IBAction)btnCameraDidClicked:(id)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options"
                                                       delegate:self
                                               cancelButtonTitle:[NSString languageSelectedStringForKey:@"cancel"]
                                               destructiveButtonTitle:nil
                                              otherButtonTitles:[NSString languageSelectedStringForKey:@"capture"],
                                  [NSString languageSelectedStringForKey:@"From_Gallery"], nil];
    
    [actionSheet showInView:self.view];
}
-(IBAction)btnDoneDidClicked:(id)sender{
    
//    [self.view addSubview:HUD];
    [hud showForTabBar];
    [self.view bringSubviewToFront:hud];

    if (!tx_noteTitle.text.length == 0 && !tv_description.text.length == 0 && ![tv_description.text isEqualToString:[NSString languageSelectedStringForKey:@"etDescText"]])
    {
            [tv_description resignFirstResponder];
            [tx_noteTitle resignFirstResponder];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self addEditNote:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    
                    [self processCompleted:nil];
                });
            });
      }else{
       
        [hud hide];
        [MCAGlobalFunction showAlert:[NSString languageSelectedStringForKey:@"title_description_blank"]];
    }
}
-(void)addEditNote:(id)sender{
    
    NSString *docDir= [MCALocalStoredFolder getCategoryDir];
    NSString *deleteFilePath = [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@",notesDHolder.str_notesName]];
    
    [MCALocalStoredFolder deleteSubCategory:deleteFilePath];
    
    tx_noteTitle.text = [tx_noteTitle.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //get the documents directory:
    [MCALocalStoredFolder createSubCategoryDir:tx_noteTitle.text];
    
    NSString *documentsDirectory =
    [NSString stringWithFormat:@"%@/%@",[MCALocalStoredFolder getCategoryDir],tx_noteTitle.text];
    
    //make a file name to write the data to using the documents directory:
     NSString *filePath =
    [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",tx_noteTitle.text]];
    
    //create content - four lines of text
    NSString *content = tv_description.text;
    
    for (int i = 0; i < notesDHolder.arr_notesImage.count; i++) {
        
    UIImage *image = [notesDHolder.arr_notesImage objectAtIndex:i];
    NSString *imagePath =
   [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.png",tx_noteTitle.text,i]];
        
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:imagePath
                    atomically:NO];
        
    }
    
    //save content to the documents directory
    [content writeToFile:filePath
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];
    //            [self.delegate addEditNoteDetail:nil];
    
   
}
-(void)processCompleted:(id)sender{
    
    [hud hide];
    UIAlertView *alert;
    
    if ([className isEqualToString:@"MCANotesViewController"]) {
        
        alert   = [[UIAlertView alloc]initWithTitle:[NSString languageSelectedStringForKey:@"msg"]
                                            message:[NSString languageSelectedStringForKey:@"note_added_msg"]
                                           delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:nil, nil];
        
    }else{
        
        alert  = [[UIAlertView alloc]initWithTitle:[NSString languageSelectedStringForKey:@"msg"]
                                           message:[NSString languageSelectedStringForKey:@"note_edited_msg"]
                                          delegate:nil
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil, nil];
        
       [self.delegate editNoteDetail:tx_noteTitle.text];
        
    }
    
    [alert show];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(),^ {
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    });

}
-(void)btn_deleteDidClicked:(id)sender{
    
    MCACustomButton *btn_temp = (MCACustomButton*)sender;
    [notesDHolder.arr_notesImage removeObjectAtIndex:btn_temp.index];
    [self getImageScrollView:nil];
    
}
#pragma mark - SCROLLVIEW_DELEGATE

-(void)getImageScrollView:(id)sender{
    
    for(UIView *subview in [scrollV_noteImages subviews])
    {
        [subview removeFromSuperview];
    }
    
    scrollV_noteImages.delegate = self;
    scrollV_noteImages.scrollEnabled = YES;
    int scrollheight = 60;
    scrollV_noteImages.contentSize = CGSizeMake(300,scrollheight);
    
    int yOffset = 0;
    int xOffset = 0;
    
    for(int index=0; index < [notesDHolder.arr_notesImage count]; index++)
    {
        UIImageView *img = [[UIImageView alloc] init];
        MCACustomButton *btn_delete = [MCACustomButton buttonWithType:UIButtonTypeCustom];
        [btn_delete setBackgroundImage:[UIImage imageNamed:@"delete5.png"] forState:UIControlStateNormal];
        btn_delete.frame = CGRectMake(54, 2, 32, 32);
        img.bounds = CGRectMake(10, 10, 68, 68);
        img.frame = CGRectMake(xOffset, yOffset+5, 68, 68);
        img.image = [notesDHolder.arr_notesImage objectAtIndex:index];
        
        [img addSubview:btn_delete];
        [btn_delete addTarget:self
                       action:@selector(btn_deleteDidClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        btn_delete.index = index;
        img.userInteractionEnabled = YES;
        
        [arr_scrollImages insertObject:img atIndex:index];
        scrollV_noteImages.contentSize = CGSizeMake(300 ,110+yOffset);
        [scrollV_noteImages addSubview:[arr_scrollImages objectAtIndex:index]];
        
        xOffset += 78;
        if (xOffset>300)
        {
            xOffset = 0;
            yOffset += 78;
        }
    }
}

#pragma mark - CAMERA_DELEGATE

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        
        [self capturePhoto:nil];
      
    }else if(buttonIndex == 1){
     
        [self useExistingPhoto:nil];
    }
}
-(void)useExistingPhoto:(id)sender{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"Photo album is not an available source on your device.", nil)
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.delegate = self;
    imgPicker.allowsEditing = NO;
    [self presentViewController:imgPicker animated:YES completion:nil];
    
}
-(void)capturePhoto:(id)sender{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        
    [self presentViewController:picker animated:YES completion:NULL];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        // an image was taken/selected:
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [notesDHolder.arr_notesImage addObject:image];
//        [arr_notesImages addObject:image];
    }
    [self getImageScrollView:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - OTHER_METHOD

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

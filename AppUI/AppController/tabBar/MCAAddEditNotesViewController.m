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
    HUD = [AryaHUD new];
    [self.view addSubview:HUD];
    
    arr_scrollImages = [NSMutableArray  new];
    
    btn_camera.layer.cornerRadius = 8.0f;
    btn_camera.layer.masksToBounds = YES;
    
    tv_description.text = @"Description:";
    tv_description.textColor = [UIColor lightGrayColor];
    
    NSUInteger numberOfViewControllersOnStack = [self.navigationController.viewControllers count];
    UIViewController *parentViewController = self.navigationController.viewControllers[numberOfViewControllersOnStack - 2];
    Class parentVCClass = [parentViewController class];
    className = NSStringFromClass(parentVCClass);
    
    if ([className isEqualToString:@"MCANotesViewController"]) {
         self.navigationItem.title = @"Add Note";
         notesDHolder = [MCANotesDHolder new];
         notesDHolder.arr_notesImage = [NSMutableArray new];
        
    }else{
        
        self.navigationItem.title = @"Edit Note";
        tx_noteTitle.text = notesDHolder.str_notesName;
        tv_description.text = notesDHolder.str_notesDesc;
        [self getImageScrollView:nil];
        
    }

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [tx_noteTitle resignFirstResponder];
    
}
#pragma mark - UITEXT_FIELD/UITEXT_VIEW DELEGATE

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([[textView text] isEqualToString:@"Description:"]) {
        textView.text = @"";
        textView.textColor = [UIColor grayColor];
    }
   return  YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([[textView text] length] == 0) {
        textView.text = @"Description:";
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
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Use Camera", @"Use Existing Photos", nil];
    
    [actionSheet showInView:self.view];
}
-(IBAction)btnDoneDidClicked:(id)sender{
    
    [self.view addSubview:HUD];
    [HUD showForTabBar];
    
    [self addEditNote:nil];
   
}
-(void)addEditNote:(id)sender{
    
    if (!tx_noteTitle.text.length == 0)
    {
        if (!tv_description.text.length == 0 && ![tv_description.text isEqualToString:@"Description:"])
        {
            NSString *docDir= [MCALocalStoredFolder getCategoryDir];
            NSString *deleteFilePath = [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@",notesDHolder.str_notesName]];
            
            [MCALocalStoredFolder deleteSubCategory:deleteFilePath];
            
            //get the documents directory:
            [MCALocalStoredFolder createSubCategoryDir:tx_noteTitle.text];
            
            NSString *documentsDirectory = [NSString stringWithFormat:@"%@/%@",[MCALocalStoredFolder getCategoryDir],tx_noteTitle.text];
            
            //make a file name to write the data to using the documents directory:
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",                                                                         tx_noteTitle.text]];
            //create content - four lines of text
            NSString *content = tv_description.text;
            
            for (int i = 0; i < notesDHolder.arr_notesImage.count; i++) {
                
                UIImage *image = [notesDHolder.arr_notesImage objectAtIndex:i];
                NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.png",tx_noteTitle.text,i]];
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
            if (![className  isEqualToString:@"MCANotesViewController"]) {
               
                [self.delegate editNoteDetail:tx_noteTitle.text];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{

            [MCAGlobalFunction showAlert:@"Please enter Note Description."];
        }
    }else{

        [MCAGlobalFunction showAlert:@"Please enter Note Title."];
    }
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

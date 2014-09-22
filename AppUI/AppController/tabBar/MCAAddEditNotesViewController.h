//
//  MCAAddNotesViewController.h
//  MobileCollegeAdmin
//
//  Created by aditi on 03/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h> 

@protocol AddEditNoteDelegate <NSObject>
-(void)editNoteDetail:(id)sender;

@end

@interface MCAAddEditNotesViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>{
    
    IBOutlet UIScrollView *scrollV_noteImages;
    
    IBOutlet UILabel *lbl_title;
    IBOutlet UILabel *lbl_description;
    IBOutlet UILabel *lbl_images;
    
    IBOutlet UITextField *tx_noteTitle;
    IBOutlet UITextView *tv_description;
    IBOutlet UIButton *btn_camera;

    NSMutableArray *arr_scrollImages;
    NSString *className;
    AryaHUD *hud;
}
-(IBAction)btnDoneDidClicked:(id)sender;
-(IBAction)btnCameraDidClicked:(id)sender;
@property(nonatomic,strong)MCANotesDHolder *notesDHolder;
@property(nonatomic,assign)id<AddEditNoteDelegate> delegate;
@end

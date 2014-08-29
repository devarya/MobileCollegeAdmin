//
//  MCARestIntraction.h
//  MobileCollegeAdmin
//
//  Created by aditi on 23/07/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "MCALoginDHolder.h"
#import "MCANotesDHolder.h"
#import "MCASignUpDHolder.h"
#import "MCANotesCatDHolder.h"
#import "ASIFormDataRequest.h"
#import "MCATaskDetailDHolder.h"


@class MCARestIntraction;
MCARestIntraction *restIntraction;

@interface MCARestIntraction : NSObject{
    
    NSURL *urlLogin;
    
}
+(id)sharedManager;
-(void)requestForLogin:(NSString*)info;
-(void)requestForForgotPwd:(NSString*)info;
-(void)requestForAddStudent:(NSString*)info;
-(void)requestForParentSignUp:(NSString*)info;
-(void)requestForStudentSignUp:(NSString*)info;
-(void)requestForTaskList:(NSString *)info;
-(void)requestForConfirmationApi:(NSString*)info;
-(void)requestForDeleteOrCompleteTask:(NSString*)info :(NSString*)controller;
-(void)requestForAddTask:(NSString*)info;
-(void)requestForNotesCategory:(NSString*)info;
-(void)requestForNotes:(NSString*)info;


@end

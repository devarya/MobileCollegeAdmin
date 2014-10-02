                                                                                   //
//  MCARestIntraction.m
//  MobileCollegeAdmin
//
//  Created by aditi on 23/07/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCARestIntraction.h"

@implementation MCARestIntraction

+(id)sharedManager{
  
    if (!restIntraction) {
        
        restIntraction = [MCARestIntraction new];
        
    }
    return  restIntraction;
    
}
#pragma mark - LOGIN

-(void)requestForLogin:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestLoginFail:)];
    [request setDidFinishSelector:@selector(requestLoginSuccess:)];
    [request startAsynchronous];
    
}
-(void)requestLoginFail:(ASIFormDataRequest*)request{
        
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestLoginSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
    NSMutableArray *arr_studList = [NSMutableArray new];
    
    if ([status_code isEqualToString:@"S1002"]){
        
        MCALoginDHolder *loginDHolder = [MCALoginDHolder new];
        loginDHolder.str_userId = [responseDict valueForKey:@"user_id"];
        loginDHolder.str_signinId = [responseDict valueForKey:@"signin_id"];
        loginDHolder.str_grade = [responseDict valueForKey:@"grade"];
        loginDHolder.str_userType = [responseDict valueForKey:@"user_type"];
        loginDHolder.str_userToken = [responseDict valueForKey:@"user_token"];
        loginDHolder.str_userIsApproved = [responseDict valueForKey:@"user_is_approved"];
        loginDHolder.str_userName = [responseDict valueForKey:@"user_name"];
        loginDHolder.str_zipCode = [responseDict valueForKey:@"zipcode"];
        loginDHolder.str_notifyByPush = [responseDict valueForKey:@"notify_by_push"];
        loginDHolder.str_notifyByMail = [responseDict valueForKey:@"notify_by_email"];
        loginDHolder.str_priorityRegular = [responseDict valueForKey:@"priority_regular"];
        loginDHolder.str_priorityHigh = [responseDict valueForKey:@"priority_high"];
        loginDHolder.str_family = [responseDict valueForKey:@"family"];
      
        loginDHolder.arr_StudentData = [responseDict valueForKey:@"student"];
        loginDHolder.arr_parentData = [responseDict valueForKey:@"parent"];
        
        for (int i = 0; i < loginDHolder.arr_StudentData.count; i++)
        {
            MCASignUpDHolder *studDHolder = [MCASignUpDHolder new];
            studDHolder.str_userId = [[loginDHolder.arr_StudentData valueForKey:@"user_id"]objectAtIndex:i];
            studDHolder.str_userType = [[loginDHolder.arr_StudentData valueForKey:@"user_type"]objectAtIndex:i];
            studDHolder.str_userName = [[loginDHolder.arr_StudentData valueForKey:@"user_name"]objectAtIndex:i];
            studDHolder.str_signinId = [[loginDHolder.arr_StudentData valueForKey:@"signin_id"]objectAtIndex:i];
            studDHolder.str_lang = [[loginDHolder.arr_StudentData valueForKey:@"language"]objectAtIndex:i];
            studDHolder.str_zipCode = [[loginDHolder.arr_StudentData valueForKey:@"zipcode"]objectAtIndex:i];
            studDHolder.str_grade = [[loginDHolder.arr_StudentData valueForKey:@"grade"]objectAtIndex:i];
            studDHolder.str_family = [[loginDHolder.arr_StudentData valueForKey:@"family"]objectAtIndex:i];
            studDHolder.str_notifyByPush = [[loginDHolder.arr_StudentData valueForKey:@"notify_by_push"]objectAtIndex:i];
            studDHolder.str_notifyByMail = [[loginDHolder.arr_StudentData valueForKey:@"notify_by_email"]objectAtIndex:i];
            
//            [[NSUserDefaults standardUserDefaults]setValue:studDHolder.str_lang forKey:KEY_LANGUAGE_CODE];
//            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [arr_studList addObject:studDHolder];
        
        }
        
        for (int i = 0; i < loginDHolder.arr_parentData.count; i++)
        {
            MCASignUpDHolder *studDHolder = [MCASignUpDHolder new];
            studDHolder.str_userId = [[loginDHolder.arr_parentData valueForKey:@"user_id"]objectAtIndex:i];
            studDHolder.str_userType = [[loginDHolder.arr_parentData valueForKey:@"user_type"]objectAtIndex:i];
            studDHolder.str_userName = [[loginDHolder.arr_parentData valueForKey:@"user_name"]objectAtIndex:i];
            studDHolder.str_signinId = [[loginDHolder.arr_parentData valueForKey:@"signin_id"]objectAtIndex:i];
            studDHolder.str_lang = [[loginDHolder.arr_parentData valueForKey:@"language"]objectAtIndex:i];
            studDHolder.str_zipCode = [[loginDHolder.arr_parentData valueForKey:@"zipcode"]objectAtIndex:i];
            studDHolder.str_grade = [[loginDHolder.arr_parentData valueForKey:@"grade"]objectAtIndex:i];
            studDHolder.str_family = [[loginDHolder.arr_parentData valueForKey:@"family"]objectAtIndex:i];
            studDHolder.str_notifyByPush = [[loginDHolder.arr_parentData valueForKey:@"notify_by_push"]objectAtIndex:i];
            studDHolder.str_notifyByMail = [[loginDHolder.arr_parentData valueForKey:@"notify_by_email"]objectAtIndex:i];
            
//            [[NSUserDefaults standardUserDefaults]setValue:studDHolder.str_lang forKey:KEY_LANGUAGE_CODE];
//            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [arr_studList addObject:studDHolder];
            
        }

    
        [[MCADBIntraction databaseInteractionManager]insertStudList:arr_studList];
        
        arr_loginData = [NSMutableArray new];
        [arr_loginData addObject:loginDHolder];
             
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:loginDHolder];
                       });
    }else{
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGIN_FAILED object:errMsg];
                       });
       }
}

#pragma mark - FORGOT_PWD
-(void)requestForForgotPwd:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestForgotPwdFail:)];
    [request setDidFinishSelector:@selector(requestForgotPwdSuccess:)];
    [request startAsynchronous];
}
-(void)requestForgotPwdFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_FORGOT_PWD_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestForgotPwdSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
          
    if ([status_code isEqualToString:@"S1007"]) {
        NSString *msg_success = [results objectForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_FORGOT_PWD_SUCCESS object:msg_success];
                         
                       });
    }else{
        
        NSString *msg_fail = [responseDict objectForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                             [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_FORGOT_PWD_FAILED object:msg_fail];
                       });
    }
}


#pragma mark - USER_EXIST

-(void)requestForUserExist:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestUserExistFail:)];
    [request setDidFinishSelector:@selector(requestUserExistSuccess:)];
    [request startAsynchronous];
    
}
-(void)requestUserExistFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_EXIST_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestUserExistSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
//    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"E1024"]) {
        
        NSString *errMsg = [results objectForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_EXIST_FAILED object:errMsg];
                       });
        
       
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_EXIST_SUCCESS object:nil];
                       });
      
      }
}
#pragma mark - PARENT_SIGN_UP

-(void)requestForParentSignUp:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestParentSignUpFail:)];
    [request setDidFinishSelector:@selector(requestParentSignUpSuccess:)];
    [request startAsynchronous];
}
-(void)requestParentSignUpFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_PARENT_SIGNUP_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestParentSignUpSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
    NSMutableArray *arr_studList = [NSMutableArray new];
    
    if ([status_code isEqualToString:@"S1019"]){
        
        MCASignUpDHolder *signUpDHolder = [MCASignUpDHolder new];
        
        signUpDHolder.str_appToken = [responseDict valueForKey:@"app_token"];
        signUpDHolder.str_appVer = [responseDict valueForKey:@"app_ver"];
        signUpDHolder.str_hasChild = [responseDict valueForKey:@"has_child"];
        signUpDHolder.str_lang = [responseDict valueForKey:@"language"];
        signUpDHolder.str_notifyByMail = [responseDict valueForKey:@"notify_by_email"];
        signUpDHolder.str_notifyByPush = [responseDict valueForKey:@"notify_by_push"];
        signUpDHolder.str_signinId = [responseDict valueForKey:@"signin_id"];
        signUpDHolder.str_sourceApp = [responseDict valueForKey:@"source_app"];
        signUpDHolder.arr_StudentData = [responseDict valueForKey:@"student"];
        signUpDHolder.str_userId = [responseDict valueForKey:@"user_id"];
        signUpDHolder.str_userIsApproved = [responseDict valueForKey:@"user_is_approved"];
        signUpDHolder.str_userToken = [responseDict valueForKey:@"user_token"];
        signUpDHolder.str_userType = [responseDict valueForKey:@"user_type"];
        signUpDHolder.str_userName = [responseDict valueForKey:@"user_name"];
        signUpDHolder.str_zipCode = [responseDict valueForKey:@"zipcode"];
        signUpDHolder.str_priorityRegular = [responseDict valueForKey:@"priority_regular"];
        signUpDHolder.str_priorityHigh = [responseDict valueForKey:@"priority_high"];
        
        for (int i = 0; i < signUpDHolder.arr_StudentData.count; i++)
        {
            MCASignUpDHolder *studDHolder = [MCASignUpDHolder new];
            studDHolder.str_userId = [[signUpDHolder.arr_StudentData valueForKey:@"user_id"]objectAtIndex:i];
            studDHolder.str_userType = [[signUpDHolder.arr_StudentData valueForKey:@"user_type"]objectAtIndex:i];
            studDHolder.str_userName = [[signUpDHolder.arr_StudentData valueForKey:@"user_name"]objectAtIndex:i];
            studDHolder.str_signinId = [[signUpDHolder.arr_StudentData valueForKey:@"signin_id"]objectAtIndex:i];
            studDHolder.str_lang = [[signUpDHolder.arr_StudentData valueForKey:@"language"]objectAtIndex:i];
            studDHolder.str_zipCode = [[signUpDHolder.arr_StudentData valueForKey:@"zipcode"]objectAtIndex:i];
            studDHolder.str_grade = [[signUpDHolder.arr_StudentData valueForKey:@"grade"]objectAtIndex:i];
            studDHolder.str_family = [[signUpDHolder.arr_StudentData valueForKey:@"family"]objectAtIndex:i];
            studDHolder.str_notifyByPush = [[signUpDHolder.arr_StudentData valueForKey:@"notify_by_push"]objectAtIndex:i];
            studDHolder.str_notifyByMail = [[signUpDHolder.arr_StudentData valueForKey:@"notify_by_email"]objectAtIndex:i];
            
            [arr_studList addObject:studDHolder];
            
        }
        
        [[MCADBIntraction databaseInteractionManager]insertStudList:arr_studList];
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_PARENT_SIGNUP_SUCCESS object:signUpDHolder];
                       });
    }else{
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_PARENT_SIGNUP_FAILED object:errMsg];
                       });
    }
}
#pragma mark - STUDENT_SIGN_UP

-(void)requestForStudentSignUp:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestStudSignUpFail:)];
    [request setDidFinishSelector:@selector(requestStudSignUpSuccess:)];
    [request startAsynchronous];
}
-(void)requestStudSignUpFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_STUD_SIGNUP_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestStudSignUpSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"S1028"]){
        
        MCASignUpDHolder *signUpDHolder = [MCASignUpDHolder new];
        
        signUpDHolder.str_family = [responseDict valueForKey:@"family"];
        signUpDHolder.str_grade = [responseDict valueForKey:@"grade"];
        signUpDHolder.str_lang = [responseDict valueForKey:@"language"];
        signUpDHolder.str_notifyByMail = [responseDict valueForKey:@"notify_by_email"];
        signUpDHolder.str_notifyByPush = [responseDict valueForKey:@"notify_by_push"];
        signUpDHolder.str_signinId = [responseDict valueForKey:@"signin_id"];
        signUpDHolder.str_sourceApp = [responseDict valueForKey:@"source_app"];
        signUpDHolder.str_userId = [responseDict valueForKey:@"user_id"];
        signUpDHolder.str_userToken = [responseDict valueForKey:@"user_token"];
        signUpDHolder.str_userType = [responseDict valueForKey:@"user_type"];
        signUpDHolder.str_userName = [responseDict valueForKey:@"user_name"];
        signUpDHolder.str_zipCode = [responseDict valueForKey:@"zipcode"];
        signUpDHolder.str_priorityRegular = [responseDict valueForKey:@"priority_regular"];
        signUpDHolder.str_priorityHigh = [responseDict valueForKey:@"priority_high"];
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_STUD_SIGNUP_SUCCESS object:signUpDHolder];
                       });
    }else{
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_STUD_SIGNUP_FAILED object:errMsg];
                       });
    }
}

#pragma mark - TASK_LIST
-(void)requestForTaskList:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestTaskListFail:)];
    [request setDidFinishSelector:@selector(requestTaskListSuccess:)];
    [request startAsynchronous];
}
-(void)requestTaskListFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TASK_LIST_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestTaskListSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
   
//    NSString *expression=@"/\"deleted_task\":\\[.*\\]/";
    
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSMutableArray *arr_taskDetail = (NSMutableArray*)[responseDict objectForKey:@"alldata"];
    NSMutableArray *arr_taskDeleted = (NSMutableArray*)[responseDict objectForKey:@"deleted_task"];
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"S1001"]){
        
        NSMutableDictionary *dict_task = [NSMutableDictionary new];
        NSMutableArray *arr_taskDetailList = [NSMutableArray new];
        NSMutableArray *arr_taskDeletedList = [NSMutableArray new];
        
        for (int i = 0;i < arr_taskDetail.count;i++) {
           
            MCATaskDetailDHolder *taskDHolder = [MCATaskDetailDHolder new];
            
            taskDHolder.str_createdAt = [[arr_taskDetail valueForKey:@"created_at"]objectAtIndex:i];
            taskDHolder.str_createdBy = [[arr_taskDetail valueForKey:@"created_by"]objectAtIndex:i];
            taskDHolder.str_grade = [[arr_taskDetail valueForKey:@"grade"]objectAtIndex:i];
            taskDHolder.str_status = [[arr_taskDetail valueForKey:@"status"]objectAtIndex:i];
            taskDHolder.str_taskId = [[arr_taskDetail valueForKey:@"task_id"]objectAtIndex:i];
            taskDHolder.str_taskDetailEng = [[arr_taskDetail valueForKey:@"task_detail_eng"]objectAtIndex:i];
            taskDHolder.str_taskNameEng = [[arr_taskDetail valueForKey:@"task_name_eng"]objectAtIndex:i];
            
            taskDHolder.str_taskDetailSp= [[arr_taskDetail valueForKey:@"task_detail_spanish"]objectAtIndex:i];
            taskDHolder.str_taskNameSp = [[arr_taskDetail valueForKey:@"task_name_spanish"]objectAtIndex:i];
            
            taskDHolder.str_taskPriority = [[arr_taskDetail valueForKey:@"task_priority"]objectAtIndex:i];
            taskDHolder.str_taskStartDate = [[arr_taskDetail valueForKey:@"task_start_date"]objectAtIndex:i];
            taskDHolder.str_taskStatus = [[arr_taskDetail valueForKey:@"task_status"]objectAtIndex:i];
            taskDHolder.str_updatedAt = [[arr_taskDetail valueForKey:@"updated_at"]objectAtIndex:i];
            taskDHolder.str_userId = [[arr_taskDetail valueForKey:@"user_id"]objectAtIndex:i];
        
//            taskDHolder.str_nowDate = [responseDict valueForKey:@"now_date"];
            taskDHolder.str_network = @"1";
                        
            [arr_taskDetailList addObject:taskDHolder];
        }
        
        for (int i = 0; i < arr_taskDeleted.count; i++) {
            
            MCATaskDetailDHolder *taskDeletedDHolder = [MCATaskDetailDHolder new];
            
            taskDeletedDHolder.str_taskId = [[arr_taskDeleted valueForKey:@"task_id"]objectAtIndex:i];
            taskDeletedDHolder.str_userId = [[arr_taskDeleted valueForKey:@"user_id"]objectAtIndex:i];
            
            [arr_taskDeletedList addObject:taskDeletedDHolder];
        }
        
         NSString *str_nowDate = [responseDict valueForKey:@"now_date"];
        
        [[NSUserDefaults standardUserDefaults]setValue:str_nowDate forKey:KEY_NOW_DATE];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [dict_task setValue:arr_taskDetailList forKey:KEY_TASK_ALL_DATA];
        [dict_task setValue:arr_taskDeletedList forKey:KEY_TASK_DELETED_DATA];
        [dict_task setValue:arr_taskDeleted forKey:KEY_TASK_DELETED_ARRAY];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TASK_LIST_SUCCESS object:dict_task];
                       });
    }else{
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_TASK_LIST_FAILED object:errMsg];
                       });
    }
}

#pragma mark - DELETE/COMPLETE_TASK

-(void)requestForDeleteOrCompleteTask:(NSString *)info :(NSString*)controller{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:controller,@"controller", nil]];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestDeleteOrCompleteTaskFail:)];
    [request setDidFinishSelector:@selector(requestDeleteOrCompleteTaskSuccess:)];
    [request startAsynchronous];
    
}
-(void)requestDeleteOrCompleteTaskFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
               {
                   [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_DELETE_COMPLETE_TASK_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
               });
}
-(void)requestDeleteOrCompleteTaskSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSString *status_code = [results valueForKey:@"status_code"];
    NSString *str_viewCntr=[request.userInfo valueForKey:@"controller"];
    
     if ([status_code isEqualToString:@"S1023"]){
         
         NSString *msg_success = [results valueForKey:@"msg"];
         
         if ([str_viewCntr isEqualToString:@"task"]) {
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_DELETE_TASK_SUCCESS object:msg_success];
                            });
         }else{
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_DELETE_TASK_DETAIL_SUCCESS object:msg_success];
                            });
         }
     }else if ([status_code isEqualToString:@"S1027"]){
         
         NSString *msg_success = [results valueForKey:@"msg"];
         
         if ([str_viewCntr isEqualToString:@"task"]) {
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_COMPLETE_TASK_SUCCESS object:msg_success];
                            });
         }else{
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_COMPLETE_TASK_DETAIL_SUCCESS object:msg_success];
                            });
         }
     } else{
         
         NSString *errMsg = [results valueForKey:@"msg"];
         
         if ([str_viewCntr isEqualToString:@"task"]) {
             
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_DELETE_COMPLETE_TASK_FAILED object:errMsg];
                            });
         }else{
             dispatch_async(dispatch_get_main_queue(), ^
                            {
                                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_DELETE_COMPLETE_TASK_DETAIL_FAILED object:errMsg];
                            });
         }
     }
}

#pragma mark - ADD_TASK

-(void)requestForAddTask:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestAddTaskFail:)];
    [request setDidFinishSelector:@selector(requestAddTaskSuccess:)];
    [request startAsynchronous];
    
}
-(void)requestAddTaskFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADD_TASK_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestAddTaskSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
//    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"S1001"]) {
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADD_TASK_SUCCESS object:errMsg];
                       });
    }else{
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADD_TASK_FAILED object:errMsg];
                       });
    }
}

#pragma mark - CONFIRMATION API

-(void)requestForConfirmationApi:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestConfirmationApiFail:)];
    [request setDidFinishSelector:@selector(requestConfirmationApiSuccess:)];
    [request startAsynchronous];
}
-(void)requestConfirmationApiFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       
                   });
}
-(void)requestConfirmationApiSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"U1001"]) {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           
                       });
    }
}
#pragma mark - NOTES_CATEGORY

-(void)requestForNotesCategory:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestNotesCategoryFail:)];
    [request setDidFinishSelector:@selector(requestNotesCategorySuccess:)];
    [request startAsynchronous];
}
-(void)requestNotesCategoryFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NOTES_CATEGORY_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestNotesCategorySuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableArray *arr_notesCategory = (NSMutableArray*)[results objectForKey:@"data"];
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"S1001"])
    {
        NSMutableArray *arr_notesCategoryList = [NSMutableArray new];
        
        for (int i = 0; i < arr_notesCategory.count; i++) {
            
            MCANotesCatDHolder *notesCatDHolder = [MCANotesCatDHolder new];
            notesCatDHolder.str_notesCatId = [[arr_notesCategory valueForKey:@"notes_cat_id"]objectAtIndex:i];
            notesCatDHolder.str_notesCatImage = [[arr_notesCategory valueForKey:@"notes_cat_image"]objectAtIndex:i];
            notesCatDHolder.str_notesCatName = [[arr_notesCategory valueForKey:@"notes_category_name"]objectAtIndex:i];
            
            [arr_notesCategoryList addObject:notesCatDHolder];
        }
      
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NOTES_CATEGORY_SUCCESS object:arr_notesCategoryList];
                       });
    }
    else{
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NOTES_CATEGORY_FAILED object:errMsg];
                       });
    }
}

#pragma mark - NOTES_DETAIL

-(void)requestForNotes:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestNotesFail:)];
    [request setDidFinishSelector:@selector(requestNotesSuccess:)];
    [request startAsynchronous];
}
-(void)requestNotesFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NOTES_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestNotesSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    
    NSMutableArray *arr_notes = (NSMutableArray*)[responseDict objectForKey:@"data"];
    NSString *str_imgURL = (NSString*)[responseDict objectForKey:@"image_url"];
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"S1001"])
    {
        NSMutableArray *arr_notesList = [NSMutableArray new];
        
        for (int i = 0; i < arr_notes.count; i++)
        {
            MCANotesDHolder *notesDHolder = [MCANotesDHolder new];
            notesDHolder.arr_notesImage = [NSMutableArray new];
            
            notesDHolder.str_notesId = [[arr_notes valueForKey:@"notes_id"]objectAtIndex:i];
            notesDHolder.str_notesDesc = [[arr_notes valueForKey:@"notes_desc"]objectAtIndex:i];
            notesDHolder.str_notesName = [[arr_notes valueForKey:@"notes_name"]objectAtIndex:i];
            notesDHolder.str_notesImage = [[arr_notes valueForKey:@"notes_image"]objectAtIndex:i];
            notesDHolder.str_notesType = @"S";
            
            if (notesDHolder.str_notesImage.length > 0)
            {
                notesDHolder.str_notesImage = [notesDHolder.str_notesImage stringByReplacingOccurrencesOfString:@"[" withString:@""];
                notesDHolder.str_notesImage = [notesDHolder.str_notesImage stringByReplacingOccurrencesOfString:@"]" withString:@""];
                notesDHolder.str_notesImage = [notesDHolder.str_notesImage stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
                NSMutableArray *arr_nImagesTemp = [[notesDHolder.str_notesImage componentsSeparatedByString:@","] mutableCopy];
                
                for (int i = 0; i < arr_nImagesTemp.count; i++)
                {
                    NSString *str_nImagesTemp = [arr_nImagesTemp objectAtIndex:i];
                    str_nImagesTemp = [str_imgURL stringByAppendingString:str_nImagesTemp];
                    [notesDHolder.arr_notesImage addObject:str_nImagesTemp];
                }
            }
            
            [arr_notesList addObject:notesDHolder];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NOTES_SUCCESS object:arr_notesList];
                       });
    }
    else{
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_NOTES_FAILED object:errMsg];
                       });
    }
}
#pragma mark - RESOURCES_CATEGORY

-(void)requestForResourcesCategory:(NSString*)info{
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestResourceCategoryFail:)];
    [request setDidFinishSelector:@selector(requestResourceCategorySuccess:)];
    [request startAsynchronous];
    
}

-(void)requestResourceCategoryFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_RESOURCE_CATEGORY_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestResourceCategorySuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    //    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSMutableArray *arr_resourceCategory = (NSMutableArray*)[results objectForKey:@"data"];
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"S1001"])
    {
        NSMutableArray *arr_resourcesCategoryList = [NSMutableArray new];
        
        for (int i = 0; i < arr_resourceCategory.count; i++) {
            
            MCAResourcesCatDHolder *resourceDHolder = [MCAResourcesCatDHolder new];
            resourceDHolder.str_resourcesCatId = [[arr_resourceCategory valueForKey:@"resource_id"] objectAtIndex:i];
            resourceDHolder.str_resourcesCatName = [[arr_resourceCategory valueForKey:@"resource_name"] objectAtIndex:i];
            resourceDHolder.str_resourcesCatImage = [[arr_resourceCategory valueForKey:@"resource_cat_image"] objectAtIndex:i];
            [arr_resourcesCategoryList addObject:resourceDHolder];
        }
        if (![[[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_TYPE] isEqualToString:@"p"])
        {
            [arr_resourcesCategoryList removeObjectAtIndex:0];
        }
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_RESOURCE_CATEGORY_SUCCESS object:arr_resourcesCategoryList];
                       });
    }
    else{
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_RESOURCE_CATEGORY_FAILED object:errMsg];
                       });
    }
}

#pragma mark - RESOURCES_DETAIL

-(void)requestForResources:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestResourcesFail:)];
    [request setDidFinishSelector:@selector(requestResourcesSuccess:)];
    [request startAsynchronous];
}
-(void)requestResourcesFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_RESOURCE_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestResourcesSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    //NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    
    NSMutableArray *arr_resources = (NSMutableArray*)[results objectForKey:@"data"];
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"S1001"])
    {
        NSMutableArray *arr_resourcesList = [NSMutableArray new];
        
        for (int i = 0; i < arr_resources.count; i++)
        {
            MCAResourcesDHolder *reDHolder = [MCAResourcesDHolder new];
            
            reDHolder.str_resourcesDataId = [[arr_resources valueForKey:@"resource_data_id"] objectAtIndex:i];
            reDHolder.str_url = [[arr_resources valueForKey:@"resource_url"] objectAtIndex:i];
            reDHolder.str_book_name = [[arr_resources valueForKey:@"book_name"] objectAtIndex:i];
            [arr_resourcesList addObject:reDHolder];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_RESOURCE_SUCCESS object:arr_resourcesList];
                       });
    }
    else{
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_RESOURCE_FAILED object:errMsg];
                       });
    }
}

#pragma mark - RESOURCES_BOOK

-(void)requestForResourcesBook:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestResourcesBookFail:)];
    [request setDidFinishSelector:@selector(requestResourcesBookSuccess:)];
    [request startAsynchronous];
}
-(void)requestResourcesBookFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_RESOURCE_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestResourcesBookSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    //NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    
    NSMutableArray *arr_resourcesBook = (NSMutableArray*)[results objectForKey:@"data"];
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"S1001"])
    {
        NSMutableArray *arr_resourcesBookList = [NSMutableArray new];
        
        for (int i = 0; i < arr_resourcesBook.count; i++)
        {
            MCAResourcesBookDHolder *reDHolder = [MCAResourcesBookDHolder new];
            
            reDHolder.str_url = [[arr_resourcesBook valueForKey:@"book_url"] objectAtIndex:i];
            reDHolder.str_book_name = [[arr_resourcesBook valueForKey:@"book_name"] objectAtIndex:i];
            [arr_resourcesBookList addObject:reDHolder];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_RESOURCE_BOOK_SUCCESS object:arr_resourcesBookList];
                       });
    }
    else{
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_RESOURCE_BOOK_FAILED object:errMsg];
                       });
    }
}



#pragma mark - USER_PROFILE_EDIT

-(void)requestForUserProfileEdit:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestUserProfileEditFail:)];
    [request setDidFinishSelector:@selector(requestUserProfileEditSuccess:)];
    [request startAsynchronous];
    
}
-(void)requestUserProfileEditFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_PROFILE_EDIT_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestUserProfileEditSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"S1001"]) {
        
        MCALoginDHolder *loginDHolder = [MCALoginDHolder new];
        loginDHolder.str_userId = [responseDict valueForKey:@"user_id"];
        loginDHolder.str_userName = [responseDict valueForKey:@"user_name"];
        loginDHolder.str_zipCode = [responseDict valueForKey:@"zipcode"];
        loginDHolder.str_userToken = [responseDict valueForKey:@"user_token"];
        loginDHolder.str_appToken = [responseDict valueForKey:@"app_token"];
        loginDHolder.str_deviceId = [responseDict valueForKey:@"device_id"];
        loginDHolder.str_family = [responseDict valueForKey:@"family"];
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_PROFILE_EDIT_SUCCESS object:loginDHolder];
                       });
    }else{
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_USER_PROFILE_EDIT_FAILED object:errMsg];
                       });
    }
}
#pragma mark - CHANGE_PWD

-(void)requestForChangePwd:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestChangePwdFail:)];
    [request setDidFinishSelector:@selector(requestChangePwdSuccess:)];
    [request startAsynchronous];
    
}
-(void)requestChangePwdFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_CHANGE_PWD_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestChangePwdSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"S1008"]) {
        NSString *successMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_CHANGE_PWD_SUCCESS object:successMsg];
                       });
    }else{
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_CHANGE_PWD_FAILED object:errMsg];
                       });
    }
}
#pragma mark - NOTIFICATION_SETTING

-(void)requestForNotificationSetting:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    
    
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestNotificationSettingFail:)];
    [request setDidFinishSelector:@selector(requestNotificationSettingSuccess:)];
    [request startAsynchronous];
    
}
-(void)requestNotificationSettingFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SETTING_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestNotificationSettingSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
    
    if ([status_code isEqualToString:@"S1033"]) {
//        NSString *successMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SETTING_SUCCESS object:responseDict];
                       });
    }else{
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SETTING_FAILED object:errMsg];
                       });
    }
}

#pragma mark - ADD_STUDENT

-(void)requestForAddStudent:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestAddStudentFail:)];
    [request setDidFinishSelector:@selector(requestAddStudentSuccess:)];
    [request startAsynchronous];
    
}
-(void)requestAddStudentFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADD_STUDENT_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestAddStudentSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
    NSMutableArray *arr_studList = [NSMutableArray new];
    
    if ([status_code isEqualToString:@"S1030"]){
        
        MCALoginDHolder *loginDHolder = [MCALoginDHolder new];
        loginDHolder.str_userId = [responseDict valueForKey:@"user_id"];
        loginDHolder.str_signinId = [responseDict valueForKey:@"signin_id"];
        loginDHolder.str_grade = [responseDict valueForKey:@"grade"];
        loginDHolder.str_userType = [responseDict valueForKey:@"user_type"];
        loginDHolder.str_userToken = [responseDict valueForKey:@"user_token"];
        loginDHolder.str_userIsApproved = [responseDict valueForKey:@"user_is_approved"];
        loginDHolder.arr_StudentData = [responseDict valueForKey:@"student"];
        loginDHolder.str_userName = [responseDict valueForKey:@"user_name"];
        loginDHolder.str_zipCode = [responseDict valueForKey:@"zipcode"];
        loginDHolder.str_notifyByPush = [responseDict valueForKey:@"notify_by_push"];
        loginDHolder.str_notifyByMail = [responseDict valueForKey:@"notify_by_email"];
        loginDHolder.str_priorityRegular = [responseDict valueForKey:@"priority_regular"];
        loginDHolder.str_priorityHigh = [responseDict valueForKey:@"priority_high"];
        loginDHolder.str_family = [responseDict valueForKey:@"family"];
        
        for (int i = 0; i < loginDHolder.arr_StudentData.count; i++)
        {
            MCASignUpDHolder *studDHolder = [MCASignUpDHolder new];
            studDHolder.str_userId = [[loginDHolder.arr_StudentData valueForKey:@"user_id"]objectAtIndex:i];
            studDHolder.str_userType = [[loginDHolder.arr_StudentData valueForKey:@"user_type"]objectAtIndex:i];
            studDHolder.str_userName = [[loginDHolder.arr_StudentData valueForKey:@"user_name"]objectAtIndex:i];
            studDHolder.str_signinId = [[loginDHolder.arr_StudentData valueForKey:@"signin_id"]objectAtIndex:i];
            studDHolder.str_lang = [[loginDHolder.arr_StudentData valueForKey:@"language"]objectAtIndex:i];
            studDHolder.str_zipCode = [[loginDHolder.arr_StudentData valueForKey:@"zipcode"]objectAtIndex:i];
            studDHolder.str_grade = [[loginDHolder.arr_StudentData valueForKey:@"grade"]objectAtIndex:i];
            studDHolder.str_family = [[loginDHolder.arr_StudentData valueForKey:@"family"]objectAtIndex:i];
            studDHolder.str_notifyByPush = [[loginDHolder.arr_StudentData valueForKey:@"notify_by_push"]objectAtIndex:i];
            studDHolder.str_notifyByMail = [[loginDHolder.arr_StudentData valueForKey:@"notify_by_email"]objectAtIndex:i];
            studDHolder.str_priorityHigh = [loginDHolder.arr_StudentData valueForKey:@"priority_high"];
            studDHolder.str_priorityRegular = [loginDHolder.arr_StudentData valueForKey:@"priority_regular"];
            
//            [[NSUserDefaults standardUserDefaults]setValue:studDHolder.str_lang forKey:KEY_LANGUAGE_CODE];
//            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [arr_studList addObject:studDHolder];
            
        }
        
        [[MCADBIntraction databaseInteractionManager]insertStudList:arr_studList];
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADD_STUDENT_SUCCESS object:loginDHolder];
                       });
    }else{
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADD_STUDENT_FAILED object:errMsg];
                       });
    }
}


#pragma mark - ADD_PARENT

-(void)requestForAddParent:(NSString *)info{
    
    NSURL *url = [NSURL URLWithString:URL_MAIN];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    
    [request setPostValue:info forKey:@"data"];
    
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestAddParentFail:)];
    [request setDidFinishSelector:@selector(requestAddParentSuccess:)];
    [request startAsynchronous];
    
}
-(void)requestAddParentFail:(ASIFormDataRequest*)request{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADD_PARENT_FAILED object:[NSString languageSelectedStringForKey:@"server_not"]];
                   });
}
-(void)requestAddParentSuccess:(ASIFormDataRequest*)request{
    
    NSString *responseString = [request responseString];
    responseString = [[responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    SBJSON *parser=[[SBJSON alloc]init];
    
    NSDictionary *results = [parser objectWithString:responseString error:nil];
    NSMutableDictionary *responseDict = ((NSMutableDictionary *)[results objectForKey:@"data"]);
    NSString *status_code = [results valueForKey:@"status_code"];
    NSMutableArray *arr_parentList = [NSMutableArray new];
    
    if ([status_code isEqualToString:@"S1029"]) {
        
        MCALoginDHolder *loginDHolder = [MCALoginDHolder new];
        loginDHolder.str_userId = [responseDict valueForKey:@"user_id"];
        loginDHolder.str_signinId = [responseDict valueForKey:@"signin_id"];
        loginDHolder.str_grade = [responseDict valueForKey:@"grade"];
        loginDHolder.str_userType = [responseDict valueForKey:@"user_type"];
        loginDHolder.str_userToken = [responseDict valueForKey:@"user_token"];
        loginDHolder.str_userIsApproved = [responseDict valueForKey:@"user_is_approved"];
        loginDHolder.arr_StudentData = [responseDict valueForKey:@"parent"];
        loginDHolder.str_userName = [responseDict valueForKey:@"user_name"];
        loginDHolder.str_zipCode = [responseDict valueForKey:@"zipcode"];
        loginDHolder.str_notifyByPush = [responseDict valueForKey:@"notify_by_push"];
        loginDHolder.str_notifyByMail = [responseDict valueForKey:@"notify_by_email"];
        loginDHolder.str_priorityRegular = [responseDict valueForKey:@"priority_regular"];
        loginDHolder.str_priorityHigh = [responseDict valueForKey:@"priority_high"];
        loginDHolder.str_family = [responseDict valueForKey:@"family"];
        
        for (int i = 0; i < loginDHolder.arr_StudentData.count; i++)
        {
            MCASignUpDHolder *studDHolder = [MCASignUpDHolder new];
            studDHolder.str_userId = [[loginDHolder.arr_StudentData valueForKey:@"user_id"]objectAtIndex:i];
            studDHolder.str_userType = [[loginDHolder.arr_StudentData valueForKey:@"user_type"]objectAtIndex:i];
            studDHolder.str_userName = [[loginDHolder.arr_StudentData valueForKey:@"user_name"]objectAtIndex:i];
            studDHolder.str_signinId = [[loginDHolder.arr_StudentData valueForKey:@"signin_id"]objectAtIndex:i];
            studDHolder.str_lang = [[loginDHolder.arr_StudentData valueForKey:@"language"]objectAtIndex:i];
            studDHolder.str_zipCode = [[loginDHolder.arr_StudentData valueForKey:@"zipcode"]objectAtIndex:i];
            studDHolder.str_grade = [[loginDHolder.arr_StudentData valueForKey:@"grade"]objectAtIndex:i];
            studDHolder.str_family = [[loginDHolder.arr_StudentData valueForKey:@"family"]objectAtIndex:i];
            studDHolder.str_notifyByPush = [[loginDHolder.arr_StudentData valueForKey:@"notify_by_push"]objectAtIndex:i];
            studDHolder.str_notifyByMail = [[loginDHolder.arr_StudentData valueForKey:@"notify_by_email"]objectAtIndex:i];
            studDHolder.str_priorityHigh = [loginDHolder.arr_StudentData valueForKey:@"priority_high"];
            studDHolder.str_priorityRegular = [loginDHolder.arr_StudentData valueForKey:@"priority_regular"];
            
//            [[NSUserDefaults standardUserDefaults]setValue:studDHolder.str_lang forKey:KEY_LANGUAGE_CODE];
//            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [arr_parentList addObject:studDHolder];
            
        }
        
        [[MCADBIntraction databaseInteractionManager]insertStudList:arr_parentList];
        
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADD_PARENT_SUCCESS object:loginDHolder];
                       });
    }else{
        NSString *errMsg = [results valueForKey:@"msg"];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_ADD_PARENT_FAILED object:errMsg];
                       });
     }
}



@end

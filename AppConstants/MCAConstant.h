//
//  MCAConstants.h
//  MobileCollegeAdmin
//
//  Created by aditi on 01/07/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

//Condition
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568)

//Main URL
#define URL_MAIN @"http://122.176.45.15:8080/careerdefine/api/"

//Message
#define INVALID_PWD @"Please enter valid password."
#define EMAIL_MESSAGE @"Please enter valid email address."
#define INVALID_USERNAME @"Please enter valid username."
#define NET_NOT_AVAIALABLE @"Please connect to internet."
#define MANDATORY_MESSAGE @"All fields are mandatory." 
#define ACCEPT_TERM_MESSAGE @"Please accept Terms of Use."
#define INVALID_USERNAME_PWD @"Please enter valid username and password."
#define INVALID_EMAIL_PWD @"Please enter valid email address and password."

//keys
#define KEY_USER_ID @"user_id"
#define KEY_USER_TYPE @"user_type"
#define KEY_USER_TOKEN @"user_token"
#define KEY_SIGNIN_ID @"signin_id"
#define KEY_NOW_DATE @"now_date"
#define KEY_LANGUAGE_CODE @"language_code"
#define KEY_STUDENT_COUNT @"stud_count"
#define KEY_TASK_GRADE_INDEX @"taskGradeIndex"
#define KEY_TASK_STUD_INDEX @"taskStudIndex"
#define KEY_ANIMATION_FILE_RAND_NO @"animationRandNo"
#define KEY_TASK_ALL_DATA @"task_allData"
#define KEY_TASK_DELETED_DATA @"task_deleted"
#define KEY_TASK_DELETED_ARRAY @"task_deletedArray"
#define KEY_CAL_CURRENT_MONTH @"current_month"
#define KEY_CAL_CURRENT_YEAR @"current_year"
#define KEY_CAL_HEIGHT @"cal_height"



//Notification
#define NOTIFICATION_LOGIN_SUCCESS @"notificationLoginSuccess"
#define NOTIFICATION_LOGIN_FAILED @"notificationLoginFailed"

#define NOTIFICATION_ADD_STUDENT_SUCCESS @"notificationAddStudentSuccess"
#define NOTIFICATION_ADD_STUDENT_FAILED @"notificationAddStudentFailed"

#define NOTIFICATION_PARENT_SIGNUP_SUCCESS @"notificationParentSignUpSuccess"
#define NOTIFICATION_PARENT_SIGNUP_FAILED @"notificationParentSignUpFailed"

#define NOTIFICATION_STUD_SIGNUP_SUCCESS @"notificationStudSignUpSuccess"
#define NOTIFICATION_STUD_SIGNUP_FAILED @"notificationStudSignUpFailed"

#define NOTIFICATION_FORGOT_PWD_SUCCESS @"notificationForgotPwdSuccess"
#define NOTIFICATION_FORGOT_PWD_FAILED @"notificationForgotPwdFailed"

#define NOTIFICATION_TASK_LIST_SUCCESS @"notificationTaskListSuccess"
#define NOTIFICATION_TASK_LIST_FAILED @"notificationTaskListFailed"

#define NOTIFICATION_ADD_TASK_SUCCESS @"notificationAddTaskSuccess"
#define NOTIFICATION_ADD_TASK_FAILED @"notificationAddTaskFailed"

#define NOTIFICATION_DELETE_TASK_SUCCESS @"notificationDeleteTaskSuccess"
#define NOTIFICATION_COMPLETE_TASK_SUCCESS @"notificationCompleteTaskSuccess"
#define NOTIFICATION_DELETE_COMPLETE_TASK_FAILED @"notificationDeleteCompleteTaskFailed"

#define NOTIFICATION_DELETE_TASK_DETAIL_SUCCESS @"notificationDeleteTaskDetailSuccess"
#define NOTIFICATION_COMPLETE_TASK_DETAIL_SUCCESS @"notificationCompleteTaskDetailSuccess"
#define NOTIFICATION_DELETE_COMPLETE_TASK_DETAIL_FAILED @"notificationDeleteCompleteTaskDetailFailed"





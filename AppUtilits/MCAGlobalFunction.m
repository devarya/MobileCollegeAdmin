//
//  MCAGlobalFunction.m
//  MobileCollegeAdmin
//
//  Created by aditi on 01/07/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAGlobalFunction.h"

@implementation MCAGlobalFunction


+(void)showAlert:(NSString*)msg{
    
    [[[UIAlertView alloc]initWithTitle:[NSString languageSelectedStringForKey:@"msg"]
                               message:msg
                              delegate:self
                     cancelButtonTitle:@"Ok"
                     otherButtonTitles:nil]show];
}
+(void)showCustomizeAlert:(NSString *)msg{
    
    [[[UIAlertView alloc]initWithTitle:[NSString languageSelectedStringForKey:@"msg"]
                               message:msg
                              delegate:self
                     cancelButtonTitle:nil
                     otherButtonTitles:nil]show];
    
}
+(MCAAlertView*)showAlert:(NSString*)msg title:(NSString*)title delegate:(id)delegate btnOk:(NSString*)btnOk btnCancel:(NSString*)btnCancel{
    
    MCAAlertView *alertView = [[MCAAlertView alloc]initWithTitle:title
                                                         message:msg
                                                        delegate:delegate
                                               cancelButtonTitle:btnCancel
                                               otherButtonTitles:btnOk,nil];
    
    [alertView show];
    return alertView;
}
+(BOOL)isConnectedToInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}
+(BOOL)isConnectedToHost
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}
+(BOOL)isFileExists:(NSString*)name{
    
    NSFileManager *fileManager = [NSFileManager new];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,name];
    BOOL isExist = [fileManager fileExistsAtPath:filePath isDirectory:nil];
    return isExist;
}
@end

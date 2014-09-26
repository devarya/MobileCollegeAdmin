
//  MCAAppDelegate.m
//  MobileCollegeAdmin
//
//  Created by aditi on 01/07/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAAppDelegate.h"
#import "MCATaskViewController.h"
#import "MCALoginViewController.h"

@implementation MCAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UITextField *txtField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [txtField becomeFirstResponder];
    [self.window addSubview:txtField];
    [txtField removeFromSuperview];
    txtField = nil;
    
    UIImageView *launchView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    launchView.image = [UIImage imageNamed:@"Default2.png"];
    UIViewController *rootViewCtr = [[UIViewController alloc]init];
    rootViewCtr.view.frame = [UIScreen mainScreen].bounds;
    [rootViewCtr.view addSubview:launchView];
    self.window.rootViewController = rootViewCtr;
    [self performSelector:@selector(startMCA) withObject:nil afterDelay:3];
    
    hostReachable = [Reachability reachabilityWithHostName: @"www.google.com"] ;
    [hostReachable startNotifier];
    
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:@"u6x50gyin0tw1v5"
                            appSecret:@"uykukzi5pomlwov"
                            root:kDBRootAppFolder]; // either kDBRootAppFolder or kDBRootDropbox
    [DBSession setSharedSession:dbSession];
    
    return YES;
}
-(void)startMCA{
    
    NSString *userId = [[NSUserDefaults standardUserDefaults]valueForKey:KEY_USER_ID];
    
    if (userId) {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
        tabBarMCACtr = [storyBoard instantiateViewControllerWithIdentifier:@"tabBarMCA"];
        [[MCAGlobalData sharedManager]goToTabbarView:nil];
        self.window.rootViewController = tabBarMCACtr;

    }else{
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:[NSBundle mainBundle]];
        MCALoginViewController *loginViewController = (MCALoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"loginViewCtr"];
//        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:loginViewController];
//        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
       self.window.rootViewController = loginViewController;
  }
    
   
}
-(void)logout
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEY_USER_ID];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEY_USER_TOKEN];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEY_USER_TYPE];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEY_TASK_GRADE_INDEX];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEY_TASK_STUD_INDEX];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEY_STUDENT_COUNT];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEY_SIGNIN_ID];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEY_LANGUAGE_CODE];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KEY_NOW_DATE];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[DBSession sharedSession]unlinkAll];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main_Iphone" bundle:nil];
    MCALoginViewController *loginViewController = (MCALoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"loginViewCtr"];
   
    //    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:vc];
    
    self.window.rootViewController = loginViewController;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive) {
       
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOCAL_UINOTIFICATION_SUCCESS object:nil];
         [tabBarMCACtr setSelectedIndex:0];
      
    }
     application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString * str_todayDate  = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableArray *arr_taskPending = [[MCADBIntraction databaseInteractionManager]retrieveTodayTask : str_todayDate];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    /* Schedule the notification */
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar] ;
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:now];
    [components setHour:18];
    [components setMinute:42];
    
    if (arr_taskPending.count > 0) {
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_NOTIFY_BY_PUSH] isEqualToString:@"1"]) {
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [calendar dateFromComponents:components];
            localNotification.alertBody = [NSString stringWithFormat:@"%lu task pending !",(unsigned long)arr_taskPending.count];
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            localNotification.soundName = UILocalNotificationDefaultSoundName;
//            localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_DROPBOX_LOGIN_SUCCESS object:nil];
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

@end

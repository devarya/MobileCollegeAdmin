//
//  ViewController.m
//  GoogleCalendarPostDemo
//
//  Copyright (c) 2013 Gabriel Theodoropoulos. All rights reserved.
//

#import "MCAGoogleViewController.h"

@interface MCAGoogleViewController ()

// The string that contains the event description.
// Its value is set every time the event description gets edited and its
// value is displayed on the table view.
@property (nonatomic, strong) NSString *strEvent;

// The string that contains the date of the event.
// This is the value that is displayed on the table view.
@property (nonatomic, strong) NSString *strEventDate;

// This string is composed right before posting the event on the calendar.
// It's actually the quick-add string and contains the date data as well.
@property (nonatomic, strong) NSString *strEventTextToPost;

// The selected event date from the date picker.
@property (nonatomic, strong) NSDate *dtEvent;

// The textfield that is appeared on the table view for editing the event description.
@property (nonatomic, strong) UITextField *txtEvent;

// This array is one of the most important properties, as it contains
// all the calendars as NSDictionary objects.
@property (nonatomic, strong) NSMutableArray *arrGoogleCalendars;

// This dictionary contains the currently selected calendar.
// It's the one that appears on the table view when the calendar list
// is collapsed.
@property (nonatomic, strong) NSDictionary *dictCurrentCalendar;

// A GoogleOAuth object that handles everything regarding the Google.
@property (nonatomic, strong) GoogleOAuth *googleOAuth;

// This flag indicates whether the event description is being edited or not.
@property (nonatomic) BOOL isEditingEvent;

// It indicates whether the event is a full-day one.
@property (nonatomic) BOOL isFullDayEvent;

// It simply indicates whether the calendar list is expanded or not on the table view.
@property (nonatomic) BOOL isCalendarListExpanded;


-(void)setupEventTextfield;
-(NSString *)getStringFromDate:(NSDate *)date;
-(void)showOrHideActivityIndicatorView;

@end

@implementation MCAGoogleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIButton *btn_close= [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_close setBackgroundImage:[UIImage imageNamed:@"close_ic.png"] forState:UIControlStateNormal];
    btn_close.frame = CGRectMake(20 , 20, 30, 30);
    
    [self.view addSubview:btn_close];
    [btn_close addTarget:self
                  action:@selector(btn_closeDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    btn_close.backgroundColor = [UIColor redColor];
    
    // Pay attention so as to initialize it with the initWithFrame: method, not just init.
    _googleOAuth = [[GoogleOAuth alloc] initWithFrame:self.view.frame];
    // Set self as the delegate.
    [_googleOAuth setGOAuthDelegate:self];
    
    [self btn_temp:nil];
}
-(void)btn_closeDidClicked:(id)sender{
    
    [self.view removeFromSuperview];
    tabBarMCACtr.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)btn_temp:(id)sender{
    
    [_googleOAuth authorizeUserWithClienID:@"65437368332-nc388j25vl5me8ir7hscmleqtiomp9ti.apps.googleusercontent.com"
                           andClientSecret:@"wlqMSBTcd44Y-or7tbQY1eie"
                             andParentView:self.view
                                 andScopes:[NSArray arrayWithObject:@"https://www.googleapis.com/auth/calendar"]];
}
- (IBAction)revokeAccess:(id)sender {
    // Revoke the access token.
    [_googleOAuth revokeAccessToken];
    
    [self btn_temp:nil];
}


#pragma mark - GoogleOAuth class delegate method implementation

-(void)btnCancelDidClicked:(id)sender{
    
    [self.view removeFromSuperview];
    tabBarMCACtr.tabBar.hidden = NO;
}

-(void)authorizationWasSuccessful{
 
     [_googleOAuth callAPI:@"https://www.googleapis.com/calendar/v3/users/me/calendarList"
           withHttpMethod:httpMethod_GET
      postParameterNames:nil
      postParameterValues:nil];
}


-(void)responseFromServiceWasReceived:(NSString *)responseJSONAsString andResponseJSONAsData:(NSData *)responseJSONAsData{
    NSError *error;
    
    if ([responseJSONAsString rangeOfString:@"calendarList"].location != NSNotFound) {
      
        // Get the JSON data as a dictionary.
        NSDictionary *calendarInfoDict = [NSJSONSerialization JSONObjectWithData:responseJSONAsData options:NSJSONReadingMutableContainers error:&error];
        
        if (error) {
            // This is the case that an error occured during converting JSON data to dictionary.
            // Simply log the error description.
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            
            // Get the calendars info as an array.
            NSArray *calendarsInfo = [calendarInfoDict objectForKey:@"items"];
           
            if (_arrGoogleCalendars == nil) {
                _arrGoogleCalendars = [[NSMutableArray alloc] init];
            }
            
            // Make a loop and get the next data of each calendar.
            for (int i=0; i<[calendarsInfo count]; i++) {
                // Store each calendar in a temporary dictionary.
                NSDictionary *currentCalDict = [calendarsInfo objectAtIndex:i];
                                
                
                // Create an array which contains only the desired data.
                NSArray *values = [NSArray arrayWithObjects:[currentCalDict objectForKey:@"id"],
                                   [currentCalDict objectForKey:@"summary"],
                                   nil];
                // Create an array with keys regarding the values on the previous array.
                NSArray *keys = [NSArray arrayWithObjects:@"id", @"summary", nil];
                
                // Add key-value pairs in a dictionary and then add this dictionary into the arrGoogleCalendars array.
                [_arrGoogleCalendars addObject:
                 [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys]];
            }
            
            // Set the first calendar as the selected one.
           
            
            NSMutableArray *arr_syncTask = [[MCADBIntraction databaseInteractionManager]retrieveSyncTaskList:nil];
            
            
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setValue:@"2014-12-12" forKeyPath:@"date"];
            NSError* error;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
            NSString* str1=  [[NSString alloc] initWithData:jsonData
                                                         encoding:NSUTF8StringEncoding];
            str1 = [str1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            str1 = [str1 stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            
            
            NSMutableDictionary *dict1 = [NSMutableDictionary new];
            [dict1 setValue:@"2014-12-12" forKeyPath:@"date"];
            NSData* jsonData1 = [NSJSONSerialization dataWithJSONObject:dict1
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
            NSString* str2=  [[NSString alloc] initWithData:jsonData1
                                                   encoding:NSUTF8StringEncoding];
            str2 = [str2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            str2 = [str2 stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            
         
            NSMutableDictionary *dict2 = [NSMutableDictionary new];
            [dict2 setValue:str1 forKeyPath:@"end"];
            [dict2 setValue:str2 forKeyPath:@"start"];
            [dict2 setValue:@"ss2edwde" forKey:@"summary"];
            
            NSData* jsonData3 = [NSJSONSerialization dataWithJSONObject:dict2
                                                                options:NSJSONWritingPrettyPrinted
                                                                  error:&error];
            NSString* str3=  [[NSString alloc] initWithData:jsonData3
                                                   encoding:NSUTF8StringEncoding];
            str3 = [str3 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            str3 = [str3 stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            str3 = [str3 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            str3 = [str3 stringByReplacingOccurrencesOfString:@": \"\[" withString:@":["];
            str3 = [str3 stringByReplacingOccurrencesOfString:@"]\"" withString:@"]"];
            str3 = [str3 stringByReplacingOccurrencesOfString:@"\"\{" withString:@"{"];
            str3 = [str3 stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];
            
            _dictCurrentCalendar = [[NSDictionary alloc] initWithDictionary:[_arrGoogleCalendars objectAtIndex:0]];
            
            NSString *apiURLString = [NSString stringWithFormat:@"https://www.googleapis.com/calendar/v3/calendars/calendars/%@/events/%@", [_dictCurrentCalendar objectForKey:@"id"],str3];
            
            
            for (int i = 0; i < arr_syncTask.count; i++) {
                
                MCATaskDetailDHolder *taskDHolder = (MCATaskDetailDHolder*)[arr_syncTask objectAtIndex:i];
                
                [_googleOAuth callAPI:apiURLString
                       withHttpMethod:httpMethod_PUT
                   postParameterNames:[NSArray arrayWithObjects:@"calendarId",@"Request body", nil]
                  postParameterValues:[NSArray arrayWithObjects:[_dictCurrentCalendar objectForKey:@"id"],str3, nil]];
                              
            }
        }
    } else if ([responseJSONAsString rangeOfString:@"calendar#event"].location != NSNotFound){
      
        NSDictionary *eventInfoDict = [NSJSONSerialization JSONObjectWithData:responseJSONAsData options:NSJSONReadingMutableContainers error:&error];
        
        if (error) {
            // This is the case that an error occured during converting JSON data to dictionary.
            // Simply log the error description.
            NSLog(@"%@", [error localizedDescription]);
            return;
        }
        
        // data fields that Google returns.
        NSString *eventID = [eventInfoDict objectForKey:@"id"];
        NSString *created = [eventInfoDict objectForKey:@"created"];
        NSString *summary = [eventInfoDict objectForKey:@"summary"];
        
        // Build the alert message.
        NSString *alertMessage = [NSString stringWithFormat:@"ID: %@\n\nCreated:%@\n\nSummary:%@", eventID, created, summary];
        
        // Show the alert view.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString languageSelectedStringForKey:@"msg"]
                                                        message:alertMessage
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Ok", nil];
        [alert show];
    }
}
-(void)accessTokenWasRevoked{
    
    // Remove all calendars from the array.
    [_arrGoogleCalendars removeAllObjects];
    _arrGoogleCalendars = nil;
    
    // Disable the post and sign out bar button items.
    [_barItemPost setEnabled:NO];
    [_barItemRevokeAccess setEnabled:NO];
    
    // Reload the Google calendars section.
    [_tblPostData reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}


-(void)errorOccuredWithShortDescription:(NSString *)errorShortDescription andErrorDetails:(NSString *)errorDetails{
    // Just log the error messages.
    NSLog(@"%@", errorShortDescription);
    NSLog(@"%@", errorDetails);
}


-(void)errorInResponseWithBody:(NSString *)errorMessage{
    // Just log the error message.
    NSLog(@"%@", errorMessage);
}



@end

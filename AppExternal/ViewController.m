//
//  ViewController.m
//  GoogleCalendarPostDemo
//
//  Copyright (c) 2013 Gabriel Theodoropoulos. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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

@implementation ViewController

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
}


#pragma mark - GoogleOAuth class delegate method implementation

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
           
            _dictCurrentCalendar = [[NSDictionary alloc] initWithDictionary:[_arrGoogleCalendars objectAtIndex:0]];
            
            NSString *apiURLString = [NSString stringWithFormat:@"https://www.googleapis.com/calendar/v3/calendars/%@/events/quickAdd", [_dictCurrentCalendar objectForKey:@"id"]];
            
            [_googleOAuth callAPI:apiURLString
                   withHttpMethod:httpMethod_POST
               postParameterNames:[NSArray arrayWithObjects:@"calendarId",@"text", nil]
              postParameterValues:[NSArray arrayWithObjects:[_dictCurrentCalendar objectForKey:@"id"], @"test by aditi ", nil]];

    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New event"
                                                        message:alertMessage
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Great", nil];
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

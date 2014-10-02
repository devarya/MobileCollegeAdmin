//
//  MCAGlobalData.m
//  MobileCollegeAdmin
//
//  Created by aditi on 04/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCAGlobalData.h"

@implementation MCAGlobalData

+ (MCAGlobalData *)sharedManager
{
    static MCAGlobalData *theUtility;
    @synchronized(self) {
        if (!theUtility)
            theUtility = [[self alloc] init];
    }
    return theUtility;
}

-(void)goToTabbarView:(id)sender{
    
    if (sender) {
       
        tabBarMCACtr = (UITabBarController*)[sender destinationViewController];
    }
   
    tabBarMCACtr.tabBar.backgroundImage = [UIImage imageNamed:@"tabBgIphone.png"];
    
    tabBarMCACtr.tabBar.selectionIndicatorImage  = [UIImage imageNamed:@"blueBg.png"];
    
    [[tabBarMCACtr.tabBar.items objectAtIndex:0]
     setFinishedSelectedImage:[[UIImage imageNamed:@"taskSelect.png"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
     withFinishedUnselectedImage:[UIImage imageNamed:@"task.png"]];
    
    [[tabBarMCACtr.tabBar.items objectAtIndex:1]
     setFinishedSelectedImage:[[UIImage imageNamed:@"calendarSelect.png"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
     withFinishedUnselectedImage:[UIImage imageNamed:@"calendar.png"]];
    
    [[tabBarMCACtr.tabBar.items objectAtIndex:2]
     setFinishedSelectedImage:[[UIImage imageNamed:@"notesSelect.png"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
     withFinishedUnselectedImage:[UIImage imageNamed:@"notes.png"]];
    
    [[tabBarMCACtr.tabBar.items objectAtIndex:3]
     setFinishedSelectedImage:[[UIImage imageNamed:@"resourcesSelect.png"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
     withFinishedUnselectedImage:[UIImage imageNamed:@"resources.png"]];
    
    [[tabBarMCACtr.tabBar.items objectAtIndex:4]
     setFinishedSelectedImage:[[UIImage imageNamed:@"moreSelect.png"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
     withFinishedUnselectedImage:[UIImage imageNamed:@"more.png"]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:
    [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,
      nil] forState:UIControlStateNormal];
    
    tabBarMCACtr.delegate = self;
    
    if (!sender) {
        
        
    }
}
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    
//    if(tabBarMCACtr.selectedIndex == 0){
//        tabBarMCACtr.tabBar.selectionIndicatorImage  = [UIImage imageNamed:@"taskBg.png"];
//    }
//    else if(tabBarMCACtr.selectedIndex == 1){
//        tabBarMCACtr.tabBar.selectionIndicatorImage  = [UIImage imageNamed:@"calendarBg.png"];
//        
//    }else if (tabBarMCACtr.selectedIndex == 2){
//        tabBarMCACtr.tabBar.selectionIndicatorImage  = [UIImage imageNamed:@"notesBg.png"];
//        
//    }else if (tabBarMCACtr.selectedIndex == 3){
//        tabBarMCACtr.tabBar.selectionIndicatorImage  = [UIImage imageNamed:@"resourcesBg.png"];
//        
//    }else if (tabBarMCACtr.selectedIndex == 4){
//        tabBarMCACtr.tabBar.selectionIndicatorImage  = [UIImage imageNamed:@"moreBg.png"];
//        
//    }
//    
//}

-(void)getTabBarTitle:(id)sender{
    
 [[tabBarMCACtr.tabBar.items objectAtIndex:0]setTitle:[NSString languageSelectedStringForKey:@"tab_task"]];
 [[tabBarMCACtr.tabBar.items objectAtIndex:1]setTitle:[NSString languageSelectedStringForKey:@"tab_calendar"]];
 [[tabBarMCACtr.tabBar.items objectAtIndex:2]setTitle:[NSString languageSelectedStringForKey:@"tab_notes"]];
 [[tabBarMCACtr.tabBar.items objectAtIndex:3]setTitle:[NSString languageSelectedStringForKey:@"tab_resources"]];
 [[tabBarMCACtr.tabBar.items objectAtIndex:4]setTitle:[NSString languageSelectedStringForKey:@"tab_more"]];
    
}
@end

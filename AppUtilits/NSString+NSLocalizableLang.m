//
//  NSString+NSLocalizableLang.m
//  MobileCollegeAdmin
//
//  Created by aditi on 20/09/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "NSString+NSLocalizableLang.h"

@implementation NSString (NSLocalizableLang)

+(NSString*)languageSelectedStringForKey:(NSString*) key
{
    NSString *path;
    NSString* string_temp;
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] isEqualToString:ENGLISH_LANG]) {
        
        path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle* languageBundle = [NSBundle bundleWithPath:path];
        string_temp =[languageBundle localizedStringForKey:key value:@"" table:nil];
        
    }else if([[[NSUserDefaults standardUserDefaults]valueForKey:KEY_LANGUAGE_CODE] isEqualToString:SPANISH_LANG]){
        
        path = [[NSBundle mainBundle] pathForResource:@"es" ofType:@"lproj"];
        NSBundle* languageBundle = [NSBundle bundleWithPath:path];
        string_temp =[languageBundle localizedStringForKey:key value:@"" table:nil];
        
    }
	return string_temp;
}
@end

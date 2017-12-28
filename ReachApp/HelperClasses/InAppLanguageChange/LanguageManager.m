//
//  LanguageManager.m
//  ios_language_manager
//
//  Created by Maxim Bilan on 12/23/14.
//  Copyright (c) 2014 Maxim Bilan. All rights reserved.
//

#import "LanguageManager.h"
#import "NSBundle+Language.h"
//#import "MereUtility.h"
//#import "Defines.h"

//static NSString * const LanguageCodes[] = { @"en", @"ar", @"fr", @"ur-PK" };
static NSString * const LanguageCodes[] = { @"en", @"ar" };
//static NSString * const LanguageStrings[] = { @"English", @"Arabic", @"French", @"Urdu" };
static NSString * const LanguageStrings[] = { @"English", @"Arabic" };
static NSString * const LanguageSaveKey = @"currentLanguageKey";

@implementation LanguageManager

+ (void)setupCurrentLanguage
{
    // NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
    
    if (currentLanguage) {
        
        if (![[self currentSystemLanguage] isEqualToString:[self lastSystemLanguage]]) {
            
            NSString *currentSystemLanguage  = [self currentSystemLanguage];
            
            [[NSUserDefaults standardUserDefaults] setObject:currentSystemLanguage forKey:LanguageSaveKey];
            
            [[NSUserDefaults standardUserDefaults] setObject:currentSystemLanguage forKey:@"lastSystemLanguage"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            currentLanguage = currentSystemLanguage;
        }
        
    }
    else if (!currentLanguage) {
        NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        if (languages.count > 0) {
            currentLanguage = languages[0];
            [[NSUserDefaults standardUserDefaults] setObject:currentLanguage forKey:LanguageSaveKey];
            
            [[NSUserDefaults standardUserDefaults] setObject:currentLanguage forKey:@"lastSystemLanguage"];//add by waqas
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
#ifndef USE_ON_FLY_LOCALIZATION
    [[NSUserDefaults standardUserDefaults] setObject:@[currentLanguage] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
#else
    [NSBundle setLanguage:currentLanguage];
#endif
}


+(NSString *)lastSystemLanguage
{
    NSString *lastSysLan = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSystemLanguage"];
    return lastSysLan;
}


+(NSString *)currentSystemLanguage
{
     NSArray *lang = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    
    return lang.count > 0 ? lang[0]: nil;
}

+ (NSArray *)languageStrings
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        
        [array addObject:LanguageStrings[i]];
    }
    return [array copy];
}

+ (NSString *)currentLanguageString
{
    NSString *string = @"";
    NSString *currentCode = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
    
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        if ([currentCode isEqualToString:LanguageCodes[i]])
        {
            string = LanguageStrings[i];
            break;
        }
    }
    return string;
}

+ (NSString *)currentLanguageCode
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
}

/*+ (NSInteger)currentLanguageIndex
{
    NSInteger index = 0;
    NSString *currentCode = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
    
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        
        if ([currentCode isEqualToString:LanguageCodes[i]])
        {
            index = i;
            break;
        }
    }
    return index;
}*/

+ (NSInteger)currentLanguageIndex
{
    NSInteger index = 0;
    NSString *currentCode = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
    
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        
        if ([currentCode isEqualToString:LanguageCodes[i]] || [currentCode  isEqualToString:[NSString stringWithFormat:@"%@-PK",LanguageCodes[i]]])
        {
            index = i;
            break;
        }
    }
    return index;
}


+ (void)saveLanguageByIndex:(NSInteger)index
{
    if (index >= 0 && index < ELanguageCount) {
        NSString *code = LanguageCodes[index];
        [[NSUserDefaults standardUserDefaults] setObject:code forKey:LanguageSaveKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
#ifdef USE_ON_FLY_LOCALIZATION
        [NSBundle setLanguage:code];
#endif
    }
}

+ (BOOL)isCurrentLanguageRTL
{
	NSInteger currentLanguageIndex = [self currentLanguageIndex];
	return ([NSLocale characterDirectionForLanguage:LanguageCodes[currentLanguageIndex]] == NSLocaleLanguageDirectionRightToLeft);
}

@end

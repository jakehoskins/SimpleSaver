//
//  UserSettings.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 23/03/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "UserSettings.h"

static NSString * const productionTarget = @"SimpleSaver";
static NSString * const debugTarget = @"SimpleSaverDebug";

static NSString * const NS_UD_CLOUD_SYNC_ENABLED = @"NS_UD_CLOUD_SYNC_ENABLED";
static NSString * const NS_UD_DARK_SKIN_ENABLED = @"NS_UD_DARK_SKIN_ENABLED";

// Override these to check if we are on production target
static NSString * const NS_UD_RESET_FAKES_ON_LOAD = @"NS_UD_RESET_FAKES_ON_LOAD";
static NSString * const NS_UD_DEBUG_SHOULD_STUB_DATA = @"NS_UD_DEBUG_SHOULD_STUB_DATA";
static NSString * const NS_UD_DEBUG_NUM_STUBS = @"NS_UD_DEBUG_NUM_STUBS";
static NSString * const NS_UD_DEBUG_SHOULD_ADHERE_IAP = @"NS_UD_DEBUG_NUM_STUBSNS_UD_DEBUG_SHOULD_ADHERE_IAP";
static NSString * const NS_UD_DEBUG_SHOULD_SHOW_IAP = @"NS_UD_DEBUG_SHOULD_SHOW_IAP";

@interface UserSettings();


@end

@implementation UserSettings

+ (instancetype) getInstance
{
    static UserSettings *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

+(BOOL) isUsingDebugSettings
{
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"TargetName"] isEqualToString:debugTarget];
}

-(BOOL) shouldResetUserDefaultsOnLoad
{
    return ([self.class isUsingDebugSettings] && [[NSUserDefaults standardUserDefaults] boolForKey:NS_UD_RESET_FAKES_ON_LOAD]);
}

-(BOOL) shouldUseStubbs
{
    return ([self.class isUsingDebugSettings] && [[NSUserDefaults standardUserDefaults] boolForKey:NS_UD_DEBUG_SHOULD_STUB_DATA]);
}

-(BOOL) shouldShowIap
{
    return ([self.class isUsingDebugSettings] && [[NSUserDefaults standardUserDefaults] boolForKey:NS_UD_DEBUG_SHOULD_SHOW_IAP]);
}

-(BOOL) shouldAdhereToIap
{
    return ([self.class isUsingDebugSettings] && [[NSUserDefaults standardUserDefaults] boolForKey:NS_UD_DEBUG_SHOULD_ADHERE_IAP]);
}

-(NSInteger) numberOfStubs
{
    return ([self shouldUseStubbs]) ? [[NSUserDefaults standardUserDefaults] integerForKey:NS_UD_DEBUG_NUM_STUBS] : 0;
}

-(BOOL) shouldEableICloudSync
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:NS_UD_CLOUD_SYNC_ENABLED];
}

-(BOOL) darkSkinEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:NS_UD_DARK_SKIN_ENABLED];
}


@end

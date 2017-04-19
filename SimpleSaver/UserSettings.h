//
//  UserSettings.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 23/03/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const NS_UD_DEBUG_NUM_STUBS;

@interface UserSettings : NSObject

+(instancetype)getInstance;
+(BOOL) isUsingDebugSettings;

-(BOOL) shouldResetUserDefaultsOnLoad;
-(BOOL) shouldUseStubbs;
-(BOOL) shouldShowIap;
-(BOOL) shouldAdhereToIap;
-(NSInteger) numberOfStubs;
-(BOOL) shouldEableICloudSync;
-(BOOL) darkSkinEnabled;


@end

//
//  Constants.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 08/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject
// Generics
extern NSString * const BACKGROUND_IMAGE;
extern NSString * const NOTIFICATION_NEW_GOAL_SELECTED;
extern NSString * const NOTIFICATION_GOAL_UPDATE;
extern NSString * const SETTINGS_CONFIG_PATH;
extern NSString * const NAVIGATION_BAR_IMAGE;
extern NSString * const INSTA_BUG_KEY;

extern const double MAX_POPOVER_HEIGHT;
extern const double MAX_POPOVER_WIDTH;

+(NSArray *)getGoalIconURLSet;
+(NSString *)getDefaultGoalIcon;
+(void) writeToUnlimtedGoals:(BOOL) hasPaid;
+(void) writeToDarkTheme:(BOOL) hasPaid;
+(BOOL) hasPurchasedUnlimitedGoals;
+(BOOL) hasPurchasedDarkTheme;

@end

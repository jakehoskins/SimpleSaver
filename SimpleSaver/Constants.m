//
//  Constants.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 08/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "Constants.h"

NSString * const BACKGROUND_IMAGE = @"background";
NSString * const NOTIFICATION_NEW_GOAL_SELECTED = @"new_goal_selected";             // Tell our detail views to change goal context
NSString * const NOTIFICATION_GOAL_UPDATE = @"goal_updated";                        // If goal has been edited update master table
NSString * const IAP_UNLIMITED_GOALS_KEY = @"~Tu17b^m5J1U5r9O:Y8bDkE!2GvvFZ";       // For NSUserDefaults checking if purchased

@implementation Constants


+(NSArray *)getGoalIconURLSet
{
    NSArray * const goalIcons = @[@"car",@"cash", @"debt", @"education", @"holiday",@"item",@"restaurent", @"retirement", @"savings", @"stocks", @"transport", @"home", @"maintenance", @"party", @"birthday", @"christmas",@"family"];
    
    return goalIcons;
}

+(NSString *)getDefaultGoalIcon
{
    return @"savings";
}

+(void) writeToUnlimtedGoals:(BOOL) hasPaid
{
    [[NSUserDefaults standardUserDefaults] setBool:hasPaid forKey:IAP_UNLIMITED_GOALS_KEY];
}

+(BOOL) hasPurchasedUnlimitedGoals
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:IAP_UNLIMITED_GOALS_KEY] == nil) return SHOULD_FOLLOW_IAP_RULES;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IAP_UNLIMITED_GOALS_KEY]) return true;
    
    return SHOULD_FOLLOW_IAP_RULES;
}

@end

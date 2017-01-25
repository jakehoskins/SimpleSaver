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

@end

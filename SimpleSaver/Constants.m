//
//  Constants.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 08/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "Constants.h"

NSString * const BACKGROUND_IMAGE = @"background";

@implementation Constants


+(NSArray *)getGoalIconURLSet
{
    NSArray * const goalIcons = @[@"car", @"debt", @"education", @"holiday",@"item",@"restaurent", @"retirement", @"savings", @"stocks", @"transport"];
    
    return goalIcons;
}


@end

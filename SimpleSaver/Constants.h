//
//  Constants.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 08/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Constants : NSObject
extern NSString * const BACKGROUND_IMAGE;
extern NSString * const NOTIFICATION_NEW_GOAL_SELECTED;
extern NSString * const NOTIFICATION_GOAL_UPDATE;

+(NSArray *)getGoalIconURLSet;
@end

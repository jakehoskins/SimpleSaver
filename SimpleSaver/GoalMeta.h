//
//  GoalMeta.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 07/04/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Goal;

@interface GoalMeta : NSObject

-(instancetype) initWithGoal:(Goal *)goal;

-(NSNumber *) averageMonthlyNeededToReachTarget;
@end

//
//  GoalMeta.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 07/04/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "GoalMeta.h"
#import "Goal.h"

@interface GoalMeta ()
@property (nonatomic, strong) Goal *goal;
@end

@implementation GoalMeta

-(instancetype) initWithGoal:(Goal *)goal
{
    self = [super init];
    
    if (self)
    {
        self.goal = goal;
    }
    
    return self;
}

-(NSNumber *) averageMonthlyNeededToReachTarget
{
    if (!self.goal.hasDeadline || !self.goal.hasTarget || self.goal.isOverdue) return nil;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:[NSDate date] toDate:[self.goal getEndDate] options: 0];
    NSInteger months = ([components month] <= 0) ? 1 : [components month];
    
    return @([self.goal getSavingsTarget].floatValue / months);
}




@end

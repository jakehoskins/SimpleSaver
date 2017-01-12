//
//  ChartsBuilder.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 12/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "ChartsBuilder.h"
#import "Goal.h"

@implementation ChartsBuilder

+(MBCircularProgressBarView *) buildTotalContributedViewForGoal:(Goal *)goal
{
    MBCircularProgressBarView *circular = [[MBCircularProgressBarView alloc] init];
    
    circular.backgroundColor = [UIColor clearColor];
    circular.value = [goal completionPercentage].floatValue * 100;

    return circular;
}

@end

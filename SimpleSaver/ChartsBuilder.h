//
//  ChartsBuilder.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 12/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBCircularProgressBar/MBCircularProgressBarView.h>

@class Goal;

@interface ChartsBuilder : NSObject
+(MBCircularProgressBarView *) buildTotalContributedViewForGoal:(Goal *)goal;
@end

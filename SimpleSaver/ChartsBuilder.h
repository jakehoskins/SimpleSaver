//
//  ChartsBuilder.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 12/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBCircularProgressBar/MBCircularProgressBarView.h>
@import Charts;
@class Goal;

@interface ChartsBuilder : NSObject

typedef NS_ENUM(NSInteger, ChartType)
{
    ChartCircularContribution,
    ChartContributed,
    ChartBurndown
};

+(instancetype) sharedInstance;

-(UIView *) buildChart:(ChartType)chart forGoal:(Goal *)goal;

+(MBCircularProgressBarView *) buildTotalContributedViewForGoal:(Goal *)goal;

+(LineChartView *) lineChartForContributionsForGoal:(Goal *)goal;


@end

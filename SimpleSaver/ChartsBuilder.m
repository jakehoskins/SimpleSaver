//
//  ChartsBuilder.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 12/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "ChartsBuilder.h"

// Model
#import "Goal.h"
#import "GoalContribution.h"
#import "XAxisMonthFormatter.h"

// Unit
#import "Helpers.h"

// Views
#import "MBCircularProgressBarView.h"

@implementation ChartsBuilder

+(UIView *) buildChart:(ChartType)chart forGoal:(Goal *)goal
{
    switch (chart)
    {
        case ChartCircularContribution:
            return [ChartsBuilder buildTotalContributedViewForGoal:goal];
            break;
        case ChartContributed:
            return [ChartsBuilder lineChartForContributions:goal];
            break;
        default:
            return nil;
            break;
    }
}

+(MBCircularProgressBarView *) buildTotalContributedViewForGoal:(Goal *)goal
{
    MBCircularProgressBarView *circular = [[MBCircularProgressBarView alloc] init];
    
    circular.backgroundColor = [UIColor clearColor];
    circular.value = [goal completionPercentage].floatValue * 100;
    
    return circular;
}

+(LineChartView *) lineChartForContributions:(Goal *)goal
{
    
    LineChartView *chartView = [[LineChartView alloc] init];
    
    [ChartsBuilder setChartDataForContributionsChart:chartView forGoal:goal];
    chartView.scaleYEnabled = false;
    chartView.xAxis.valueFormatter = [[XAxisMonthFormatter alloc] init];
    [chartView setGridBackgroundColor:[UIColor blackColor]];
    chartView.descriptionText = @"Total Contributions";
    return chartView;
}

+ (void)setChartDataForContributionsChart:(LineChartView *)view forGoal:(Goal *)goal
{
    LineChartData *data;
    
    data = [ChartsBuilder generateLineDataForTotalContributionsWithGoal:goal];
    
    view.xAxis.axisMaximum = data.xMax;
    view.xAxis.axisMinimum = data.xMin;
    view.leftAxis.maxWidth = 50.f;
    
    view.leftAxis.drawGridLinesEnabled = NO;
    view.leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    view.rightAxis.enabled = false;
    
    view.data = data;
}

+(LineChartData *) generateLineDataForTotalContributionsWithGoal:(Goal *)goal
{
    LineChartData *lineChartData = [[LineChartData alloc] init];
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    for (GoalContribution *contribution in [goal getContributions])
    {
        NSLog(@"%f",[contribution amount].doubleValue);
        [entries addObject:[[ChartDataEntry alloc] initWithX:[contribution contributionDate].timeIntervalSince1970 y:[contribution amount].doubleValue]];
    }
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:entries label:@"Contributions"];
    
    set.circleRadius = 2;
    set.circleHoleRadius = 1;
    set.drawValuesEnabled = false;
    set.highlightColor = [UIColor clearColor];
    set.axisDependency = AxisDependencyLeft;
    
    [lineChartData addDataSet:set];
    return lineChartData;
}


@end

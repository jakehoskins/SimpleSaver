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
#import "ChartMarker.h"

// Util
#import "Helpers.h"
#import "Colours.h"
#import "Skin.h"

// Views
#import "MBCircularProgressBarView.h"

@interface ChartsBuilder()
@property (nonatomic, strong) id<IChartMarker> marker;
@end

@implementation ChartsBuilder

+ (id)sharedInstance{
    static ChartsBuilder *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id) init
{
    self = [super init];
    
    if (self)
    {
        ChartMarker *marker = [[ChartMarker alloc] init];
        
        self.marker = marker;
    }
    
    return self;
}

-(UIView *) buildChart:(ChartType)chart forGoal:(Goal *)goal
{
    switch (chart)
    {
        case ChartCircularContribution:
        {
            return [ChartsBuilder buildTotalContributedViewForGoal:goal];
            break;
            
        }
        case ChartContributed:
        {
            LineChartView *view = [ChartsBuilder lineChartForContributionsForGoal:goal];
            
            view.marker = self.marker;
            return view;
        }
            break;
        case ChartBurndown:
        {
            LineChartView *view = [ChartsBuilder lineChartForBurndown:goal];
            
            view.marker = self.marker;
            return view;
        }
        default:
        {
            return nil;
            break;
        }
    }
}

+(MBCircularProgressBarView *) buildTotalContributedViewForGoal:(Goal *)goal
{
    MBCircularProgressBarView *circular = [[MBCircularProgressBarView alloc] init];
    double completion = [goal completionPercentage].doubleValue * 100;
    circular.backgroundColor = [UIColor clearColor];
    circular.progressColor = [Skin defaultGreenColour];
    circular.progressStrokeColor = [Skin defaultGreenColour ];
    circular.emptyLineColor = [Skin defaultRedColour];
    circular.emptyLineStrokeColor = [Skin defaultRedColour];
    circular.fontColor = [Skin defaultTextColour];
    circular.value = (completion > 100.0f) ? 100.0f : completion;
    
    return circular;
}

+(LineChartView *) lineChartForContributionsForGoal:(Goal *)goal
{
    
    LineChartView *chartView = [[LineChartView alloc] init];
    
    [ChartsBuilder setChartDataForContributionsChart:chartView forGoal:goal];
    chartView.scaleYEnabled = false;
    chartView.xAxis.valueFormatter = [[XAxisMonthFormatter alloc] init];
    chartView.gridBackgroundColor = [UIColor blackColor];
    chartView.xAxis.labelTextColor = [Skin defaultTextColour];
    chartView.leftAxis.labelTextColor = [Skin defaultTextColour];
    chartView.descriptionTextColor = [Skin defaultTextColour];
    chartView.descriptionText = @"Total Contributions";
    
    chartView.marker = (id) self;
    
    return chartView;
}

+(LineChartView *) lineChartForBurndown:(Goal *)goal
{
    LineChartView *chartView = [[LineChartView alloc] init];
    
    [ChartsBuilder setChartDataForBurndownChart:chartView forGoal:goal];
    chartView.scaleYEnabled = false;
    chartView.xAxis.valueFormatter = [[XAxisMonthFormatter alloc] init];
    chartView.gridBackgroundColor = [UIColor blackColor];
    chartView.xAxis.labelTextColor = [Skin defaultTextColour];
    chartView.leftAxis.labelTextColor = [Skin defaultTextColour];
    chartView.descriptionTextColor = [Skin defaultTextColour];
    chartView.descriptionText = @"Contribution Burndown";

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
    view.rightAxis.enabled = false;
    view.data = data;
}

+(void)setChartDataForBurndownChart:(LineChartView *)view forGoal:(Goal *)goal
{
    LineChartData *data;
    
    data = [ChartsBuilder generateLineDataForBurndownWithGoal:goal];
    view.xAxis.axisMaximum = data.xMax;
    view.xAxis.axisMinimum = data.xMin;
    view.leftAxis.maxWidth = 50.f;
    view.leftAxis.drawGridLinesEnabled = NO;
    view.leftAxis.axisMinimum = 0.0;
    view.rightAxis.enabled = false;
    view.data = data;
    
}

+(LineChartData *) generateLineDataForTotalContributionsWithGoal:(Goal *)goal
{
    LineChartData *lineChartData = [[LineChartData alloc] init];
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    for (GoalContribution *contribution in [goal getContributions])
    {
        [entries addObject:[[ChartDataEntry alloc] initWithX:[contribution contributionDate].timeIntervalSince1970 y:[contribution amount].doubleValue]];
    }
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:entries label:@"Contributions"];
    NSArray *gradientColors = @[
                                (id)[Skin defaultGreenColour].CGColor,
                                (id)[Skin defaultGreenColour].CGColor
                                ];
    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
    
    set.circleColors = [NSArray arrayWithObjects:[UIColor cactusGreenColor], nil];
    set.circleHoleColor = [UIColor cactusGreenColor];
    set.circleRadius = 2;
    set.circleHoleRadius = 1;
    set.drawValuesEnabled = false;
    set.highlightColor = [UIColor clearColor];
    
    set.drawFilledEnabled = true;
    set.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
    set.fillAlpha = 1.f;
    set.axisDependency = AxisDependencyLeft;
    
    [lineChartData addDataSet:set];
    return lineChartData;
}

+(LineChartData *) generateLineDataForBurndownWithGoal:(Goal *)goal
{
    // Take each contribution from savings target and thats our data point
    LineChartData *lineChartData = [[LineChartData alloc] init];
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    double movingContributed = 0.0f;
    // Add a contribution for the initial setup so that we have data point as savings target
    if ([goal initialContribution] <= 0)
    {
        [entries addObject:[[ChartDataEntry alloc] initWithX:[goal getStartDate].timeIntervalSince1970 y:[goal getSavingsTarget].doubleValue]];
    }
    else
    {
        [entries addObject:[[ChartDataEntry alloc] initWithX:[goal getStartDate].timeIntervalSince1970 y:[goal initialContribution].doubleValue]];
    }
    
    for (GoalContribution *contribution in [goal getContributions])
    {
        movingContributed += [contribution amount].doubleValue;
        
        [entries addObject:[[ChartDataEntry alloc] initWithX:[contribution contributionDate].timeIntervalSince1970 y:[goal getSavingsTarget].doubleValue - movingContributed]];
        
    }
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:entries label:@"Contributions"];
    NSArray *gradientColors = @[
                                (id)[Skin defaultRedColour].CGColor,
                                (id)[Skin defaultRedColour].CGColor
                                ];
    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
    
    set.circleColors = [NSArray arrayWithObjects:[UIColor grapefruitColor], nil];
    set.circleHoleColor = [UIColor grapefruitColor];
    set.circleRadius = 2;
    set.circleHoleRadius = 1;
    set.drawValuesEnabled = false;
    set.highlightColor = [UIColor clearColor];
    set.circleRadius = 2;
    set.circleHoleRadius = 1;
    set.drawValuesEnabled = false;
    set.highlightColor = [UIColor clearColor];
    set.drawFilledEnabled = true;
    set.fillAlpha = 1.f;
    set.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
    
    [lineChartData addDataSet:set];
    
    return lineChartData;
}



@end

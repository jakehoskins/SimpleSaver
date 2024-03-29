//
//  XAxisMonthFormatter.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 14/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "XAxisMonthFormatter.h"

@import Charts;

@implementation XAxisMonthFormatter

-(NSString *)stringForValue1:(double)value axis:(ChartAxisBase *)axis
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:value];
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitMonth fromDate:date];
    
    return [[XAxisMonthFormatter months] objectAtIndex:[components month] - 1];
}

-(NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:value];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d"];
    
    return [formatter stringFromDate:date];
}


+(NSArray *) months
{
    return @[
             @"Jan", @"Feb", @"Mar",
             @"Apr", @"May", @"Jun",
             @"Jul", @"Aug", @"Sep",
             @"Oct", @"Nov", @"Dec"
             ];
}

@end

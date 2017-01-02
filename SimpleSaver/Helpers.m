//
//  Helpers.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 02/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

+(NSString *) formatTimeInterval:(NSDateComponents *) components {
    NSString *formattedTimeDelta = @"";
    
    long years = [components year];
    long months = [components month];
    long day = [components day];
    long hour = [components hour];
    long minute = [components minute];
    long seconds = [components second];
    
    if (years != 0) {
        formattedTimeDelta = [formattedTimeDelta stringByAppendingString: [NSString stringWithFormat:@"Years: %ld \n", years]];
    }
    
    if (months != 0) {
        formattedTimeDelta = [formattedTimeDelta stringByAppendingString: [NSString stringWithFormat:@"Months: %ld \n", months]];
    }
    
    if (day != 0) {
        formattedTimeDelta = [formattedTimeDelta stringByAppendingString: [NSString stringWithFormat:@"Days: %ld \n", day]];
    }
    
    if (hour != 0) {
        formattedTimeDelta = [formattedTimeDelta stringByAppendingString: [NSString stringWithFormat:@"Hours: %ld \n", hour]];
    }
    
    if (minute != 0) {
        formattedTimeDelta = [formattedTimeDelta stringByAppendingString: [NSString stringWithFormat:@"Minutes: %ld \n", minute]];
    }
    
    if (seconds != 0) {
        formattedTimeDelta = [formattedTimeDelta stringByAppendingString: [NSString stringWithFormat:@"Seconds: %ld \n", seconds]];
    }
    
    return formattedTimeDelta;
}

+(NSString *) formatCurrency:(NSString *)currency forAmount:(NSNumber *)amount
{
    NSNumberFormatter * formatter = [NSNumberFormatter new];
    NSString *formatted = [NSString stringWithFormat:@""];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits: 2];
    
    formatted = [formatted stringByAppendingString:[NSString stringWithFormat:@"%@%@", currency,[formatter stringFromNumber:amount]]];
    
    return formatted;
}

+(BOOL) containsOnlyNumericals:(NSString *) str {    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    
    return ([scanner scanFloat:NULL] && [scanner isAtEnd]);
}



@end

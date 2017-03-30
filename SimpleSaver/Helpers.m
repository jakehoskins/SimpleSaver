//
//  Helpers.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 02/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <stdlib.h>

// Never include UserSettings && Skin together
#import "Skin.h"
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

+(NSString *) formatAmount:(NSNumber *)amount
{
    NSNumberFormatter * formatter = [NSNumberFormatter new];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits: 2];
    
    return [formatter stringFromNumber:amount];;
}
+(NSString *) formatCurrentAmountWithZeroDecimal:(NSString *) currency forAmount:(NSNumber *)amount
{
    NSNumberFormatter * formatter = [NSNumberFormatter new];
    NSString *formatted = [NSString stringWithFormat:@""];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits: 2];
    [formatter setMinimumFractionDigits:1];
    
    formatted = [formatted stringByAppendingString:[NSString stringWithFormat:@"%@%@", currency,[formatter stringFromNumber:amount]]];
    
    return formatted;
}

+(NSString *) defaultCurrency
{
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setLocale:[NSLocale currentLocale]];
    [currencyFormatter setMaximumFractionDigits:2];
    [currencyFormatter setMinimumFractionDigits:2];
    [currencyFormatter setAlwaysShowsDecimalSeparator:YES];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSNumber *someAmount = [NSNumber numberWithFloat:5.00];
    NSString *currencyString = [currencyFormatter stringFromNumber:someAmount];
    
    return [currencyString substringToIndex:1];
}

+(BOOL) containsOnlyNumericals:(NSString *) str {    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    
    return ([scanner scanFloat:NULL] && [scanner isAtEnd]);
}

+(BOOL) isIpad
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
}

+ (NSNumber *)randomNumberBetween:(float)smallNumber and:(float)bigNumber
{
    float diff = bigNumber - smallNumber;
    return [NSNumber numberWithFloat:(((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber];
}

+(NSDate *)addDaysToDate:(NSDate *)date increaseBy:(NSInteger)days
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    dayComponent.day = days;
    return [theCalendar dateByAddingComponents:dayComponent toDate:date options:0];
}

+(UIImage *) goalIconForImage:(UIImage *)image
{
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, [Skin goalIconColour].CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    img = [UIImage imageWithCGImage:img.CGImage scale:1.0 orientation: UIImageOrientationDownMirrored];
    
    return img;
}


@end

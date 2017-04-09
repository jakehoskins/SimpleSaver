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
//    long minute = [components minute];
//    long seconds = [components second];
    
    if (years != 0) {
        formattedTimeDelta = [formattedTimeDelta stringByAppendingString: [NSString stringWithFormat:@"Years: %ld, ", years]];
    }
    
    if (months != 0) {
        formattedTimeDelta = [formattedTimeDelta stringByAppendingString: [NSString stringWithFormat:@"Months: %ld, ", months]];
    }
    
    if (day != 0) {
        formattedTimeDelta = [formattedTimeDelta stringByAppendingString: [NSString stringWithFormat:@"Days: %ld, ", day]];
    }
    
    if (hour != 0) {
        formattedTimeDelta = [formattedTimeDelta stringByAppendingString: [NSString stringWithFormat:@"Hours: %ld", hour]];
    }
    
//    if (minute != 0) {
//        formattedTimeDelta = [formattedTimeDelta stringByAppendingString: [NSString stringWithFormat:@"Minutes: %ld \n", minute]];
//    }
//    
//    if (seconds != 0) {
//        formattedTimeDelta = [formattedTimeDelta stringByAppendingString: [NSString stringWithFormat:@"Seconds: %ld \n", seconds]];
//    }
    
    return formattedTimeDelta;
}

+(NSString *) formatCurrency:(NSString *)currency forAmount:(NSNumber *)amount
{
    if (!amount || !currency) return @"";
    
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


// Not used but how it should be done for future reference
-(NSString *) suffixNumber:(NSNumber*)number
{
    if (!number)
        return @"";
    
    long long num = [number longLongValue];
    
    int s = ( (num < 0) ? -1 : (num > 0) ? 1 : 0 );
    NSString* sign = (s == -1 ? @"-" : @"" );
    
    num = llabs(num);
    
    if (num < 1000)
        return [NSString stringWithFormat:@"%@%lld",sign,num];
    
    int exp = (int) (log10l(num) / 3.f); //log10l(1000));
    
    NSArray* units = @[@"K",@"M",@"G",@"T",@"P",@"E"];
    
    return [NSString stringWithFormat:@"%@%.1f%@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}



@end

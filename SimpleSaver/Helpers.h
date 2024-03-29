//
//  Helpers.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 02/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helpers : NSObject
+(NSString *) formatTimeInterval:(NSDateComponents *) components;
+(NSString *) formatCurrency:(NSString *)currency forAmount:(NSNumber *)amount;
+(NSString *) formatCurrentAmountWithZeroDecimal:(NSString *) currency forAmount:(NSNumber *)amount;
+(NSString *) formatAmount:(NSNumber *)amount;
+(BOOL) containsOnlyNumericals:(NSString *) str;
+(BOOL) isIpad;
+ (NSNumber *)randomNumberBetween:(float)smallNumber and:(float)bigNumber;
+(NSDate *)addDaysToDate:(NSDate *)date increaseBy:(NSInteger)days;
+(NSString *) defaultCurrency;
+(UIImage *) goalIconForImage:(UIImage *)image;
-(NSString *) suffixNumber:(NSNumber*)number;
@end

//
//  Goal.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 01/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "Goal.h"
#import "GoalContribution.h"
NSString * const kName = @"name";
NSString * const kSavingsTarget = @"savingsTarget";
NSString * const kContributions = @"contributions";
NSString * const kStart = @"start";
NSString * const kEnd = @"end";

@interface Goal ()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *savingsTarget;
@property (nonatomic, strong) NSMutableArray<GoalContribution *> *contributions;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@end

@implementation Goal

-(id) initWithName:(NSString *)name savingsTarget:(NSNumber *)target forStartDate:(NSDate *)start andEndDate:(NSDate *)end
{
    self = [super init];
    
    if (self)
    {
        self.name = name;
        self.savingsTarget = target;
        self.startDate = start;
        self.endDate = end;
        self.contributions = [NSMutableArray array];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:kName];
    [aCoder encodeObject:self.savingsTarget forKey:kSavingsTarget];
    [aCoder encodeObject:self.contributions forKey:kContributions];
    [aCoder encodeObject:self.startDate forKey:kStart];
    [aCoder encodeObject:self.endDate forKey:kEnd];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:kName];
        self.savingsTarget = [aDecoder decodeObjectForKey:kSavingsTarget];
        self.contributions = [aDecoder decodeObjectForKey:kContributions];
        self.startDate = [aDecoder decodeObjectForKey:kStart];
        self.endDate = [aDecoder decodeObjectForKey:kEnd];
    }
    return self;
}

// @TODO: Need to fix issue where we cant have duplicate objectives
-(BOOL) isEqual:(id)object
{
    if ([object isKindOfClass:[Goal class]])
    {
        Goal *goal = (Goal *) object;
        
        if ([[self getName] isEqualToString: [goal getName]] &&
            [[self getContributions] isEqual:[goal getContributions]] &&
            [[self getStartDate] isEqual:[goal getStartDate]] &&
            [[self getEndDate] isEqual:[goal getEndDate]])
        {
            return true;
        }
    }
    
    return false;
}

-(NSString *) getName
{
    return self.name;
}
-(NSNumber *) getSavingsTarget
{
    return self.savingsTarget;
}
-(NSDate *) getStartDate
{
    return self.startDate;
}
-(NSDate *) getEndDate
{
    return self.endDate;
}

-(NSNumber *) totalContributed
{
    double total = 0;
    
    for (GoalContribution *contribution in self.contributions)
    {
        total += [contribution amount].doubleValue;
    }
    
    return @(total);
}


-(NSArray *) getContributions
{
    return self.contributions;
}
-(BOOL) hasDeadline
{
    return (self.endDate);
}

-(void) contribute:(GoalContribution *)contribution
{
    [self.contributions addObject:contribution];
}

-(NSNumber *) daysRemaining
{
    if (!self.endDate) return nil;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components: (NSCalendarUnitDay)fromDate:[NSDate date] toDate:self.endDate options:0];
    
    return @([components day]);
}

-(NSNumber *) totalDays
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components;
    
    if (!self.endDate)
    {
        components = [gregorianCalendar components: (NSCalendarUnitDay)fromDate:self.startDate toDate:self.endDate options:0];
    }
    else
    {
        components = [gregorianCalendar components: (NSCalendarUnitDay)fromDate:self.startDate toDate:[NSDate date] options:0];
    }
    
    return @([components day]);
}
-(NSNumber *) numberOfContributions
{
    return @([self.contributions count]);
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ Target: %.2f Contributed: %.2f Contributions: %li", self.name, self.getSavingsTarget.doubleValue, [self totalContributed].doubleValue ,[self.contributions count]];
}

@end

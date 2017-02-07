//
//  Goal.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 01/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "Goal.h"
#import "GoalContribution.h"
#import "Helpers.h"

NSString * const kGoalName = @"name";
NSString * const kSavingsTarget = @"savingsTarget";
NSString * const kCurrency = @"currency";
NSString * const kInitialContribution = @"initialContribution";
NSString * const kContributions = @"contributions";
NSString * const kStartDate = @"start";
NSString * const kDeadlineDate = @"end";
NSString * const kIconUrl = @"iconUrl";


@interface Goal ()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *savingsTarget;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSNumber *initialContribution;
@property (nonatomic, strong) NSMutableArray<GoalContribution *> *contributions;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@end

@implementation Goal


// DEPRECATE!
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
        self.currency = [Helpers defaultCurrency];
    }
    
    return self;
}


-(id) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        self.name = [dictionary objectForKey:kGoalName];
        self.iconUrl = [dictionary objectForKey:kIconUrl];
        self.savingsTarget = [dictionary objectForKey:kSavingsTarget];
        self.currency = [dictionary objectForKey:kCurrency];
        self.initialContribution = [dictionary objectForKey:kInitialContribution];
        self.contributions = [NSMutableArray array];
        self.startDate = [dictionary objectForKey:kStartDate];
        self.endDate = [dictionary objectForKey:kDeadlineDate];
    }
    
    return self;
}

-(NSDictionary *) dictionaryForGoal
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if (self.name)
    {
        [dictionary setObject:self.name forKey:kGoalName];
    }
    
    if (self.iconUrl)
    {
        [dictionary setObject:self.iconUrl forKey:kIconUrl];
    }
    
    if (self.savingsTarget)
    {
        [dictionary setObject:self.savingsTarget forKey:kSavingsTarget];
    }
    
    if (self.currency)
    {
        [dictionary setObject:self.currency forKey:kCurrency];
    }
    
    if(self.initialContribution)
    {
        [dictionary setObject:self.initialContribution forKey:kInitialContribution];
    }
    
    if (self.contributions)
    {
        [dictionary setObject:self.contributions forKey:kContributions];
    }
    
    if (self.startDate)
    {
        [dictionary setObject:self.startDate forKey:kStartDate];
    }
    
    if (self.endDate)
    {
        [dictionary setObject:self.endDate forKey:kDeadlineDate];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}
-(NSString *) currency
{
    return _currency;
}
/**
 @discussion ensure new keys are encoded
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:kGoalName];
    [aCoder encodeObject:self.savingsTarget forKey:kSavingsTarget];
    [aCoder encodeObject:self.contributions forKey:kContributions];
    [aCoder encodeObject:self.currency forKey:kCurrency];
    [aCoder encodeObject:self.initialContribution forKey:kInitialContribution];
    [aCoder encodeObject:self.startDate forKey:kStartDate];
    [aCoder encodeObject:self.endDate forKey:kDeadlineDate];
    [aCoder encodeObject:self.iconUrl forKey:kIconUrl];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:kGoalName];
        self.savingsTarget = [aDecoder decodeObjectForKey:kSavingsTarget];
        self.currency = [aDecoder decodeObjectForKey:kCurrency];
        self.initialContribution = [aDecoder decodeObjectForKey:kInitialContribution];
        self.contributions = [aDecoder decodeObjectForKey:kContributions];
        self.startDate = [aDecoder decodeObjectForKey:kStartDate];
        self.endDate = [aDecoder decodeObjectForKey:kDeadlineDate];
        self.iconUrl = [aDecoder decodeObjectForKey:kIconUrl];
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
            [[self getEndDate] isEqual:[goal getEndDate]] &&
            [[self getIconUrl] isEqual:[goal iconUrl]])
        {
            return true;
        }
    }
    
    return false;
}
-(void) setContributons:(NSArray<GoalContribution *> *)contributions
{
    if (!_contributions)
    {
        _contributions = [[NSMutableArray alloc] initWithCapacity:contributions.count];
    }
    
    for(GoalContribution *contribution in contributions)
    {
        [_contributions addObject:contribution];
    }
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

// Add caching
-(NSNumber *) totalContributed
{
    double total = self.initialContribution.doubleValue;
    
    for (GoalContribution *contribution in self.contributions)
    {
        total += [contribution amount].doubleValue;
    }
    
    return @(total);
}

+(NSNumber *) sumArray:(NSArray<NSNumber *> *)array
{
    double total = 0;
    
    for (NSNumber *item in array)
    {
        total += item.doubleValue;
    }
    
    return @(total);
}
-(NSNumber *) completionPercentage
{
    double totalContributed = [self totalContributed].doubleValue;
    
    if (totalContributed <= 0) return @(0);
    
    return @((totalContributed / self.savingsTarget.doubleValue));
}

-(NSNumber *) daysRemainingPercentage
{
    double daysPast = [self daysPast].doubleValue;
    double totalDays = [self totalDays].doubleValue;
    
    if (daysPast <= 0) return @(0);
    
    return @((daysPast / totalDays));
}

-(NSArray *) getContributions
{
    return self.contributions;
}
-(BOOL) hasDeadline
{
    return (self.endDate);
}

-(BOOL) hasTarget
{
    return (self.savingsTarget);
}

-(NSNumber *) initialContribution
{
    return self.initialContribution;
}

-(BOOL) isOverdue
{
    if ([self hasDeadline])
    {
        return ([[NSDate date] timeIntervalSinceDate:self.endDate] > 0);
    }
    
    return false;
}

-(void) contribute:(GoalContribution *)contribution
{
    [self.contributions addObject:contribution];
}

-(void) ammendContributionAtIndex:(NSInteger)index newContrbution:(GoalContribution *)newContribution
{
    [self.contributions replaceObjectAtIndex:index withObject:newContribution];
}
-(void) removeContributionAtIndex:(NSInteger)index
{
    [self.contributions removeObjectAtIndex:index];
}
-(void) setIconUrl:(NSString *)url;
{
    _iconUrl = url;
}

-(NSString *)getIconUrl;
{
    return self.iconUrl;
}

-(NSNumber *) daysPast
{
    if (!self.startDate) return nil;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components: (NSCalendarUnitDay)fromDate:[NSDate date] toDate:self.startDate options:0];
    
    return @([components day]);
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
    
    if (self.endDate)
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
    return [NSString stringWithFormat:@"%@ Target: %.2f Contributed: %.2f Contributions: %li", self.name, self.getSavingsTarget.doubleValue, [self totalContributed].doubleValue ,(unsigned long)[self.contributions count]];
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

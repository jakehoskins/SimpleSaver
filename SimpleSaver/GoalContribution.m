//
//  GoalContribution.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 01/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "GoalContribution.h"
NSString * const kAmount = @"amount";
NSString * const kContributionDate = @"contributionDate";
NSString * const kNotes = @"notes";

@interface GoalContribution()
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSDate *contributionDate;
@property (nonatomic, strong) NSString *notes;
@end

@implementation GoalContribution

-(id) initWithAmount:(NSNumber *)amount forDate:(NSDate *)date withNotes:(NSString *)notes
{
    self = [super init];
    
    if (self)
    {
        self.amount = amount;
        self.contributionDate = date;
        self.notes = notes;
    }
    
    return self;
}
-(BOOL) isEqual:(id)object
{
    if ([object isKindOfClass:[GoalContribution class]])
    {
        GoalContribution *contribution = (GoalContribution *) object;
        
        if ([[self amount] isEqual:[contribution amount]] &&
            [[self contributionDate] isEqual:[contribution contributionDate]] &&
            [[self notes] isEqual:[contribution notes]])
        {
            return true;
        }
    }
    
    return false;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.amount forKey:kAmount];
    [aCoder encodeObject:self.contributionDate forKey:kContributionDate];
    [aCoder encodeObject:self.notes forKey:kNotes];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.amount = [aDecoder decodeObjectForKey:kAmount];
        self.contributionDate = [aDecoder decodeObjectForKey:kContributionDate];
        self.notes = [aDecoder decodeObjectForKey:kNotes];
    }
    return self;
}

-(NSNumber *) amount
{
    return _amount;
}

-(NSString *) notes
{
    return _notes;
}

-(NSDate *) contributionDate
{
    return _contributionDate;
}
@end

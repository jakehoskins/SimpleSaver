//
//  Goal.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 01/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GoalContribution;

@interface Goal : NSObject

// Deprecating soon
-(id) initWithName:(NSString *)name savingsTarget:(NSNumber *)target forStartDate:(NSDate *)start andEndDate:(NSDate *)end;

// Move towards this approach
-(id) initWithDictionary:(NSDictionary *)dictionary;

// Getters
-(NSArray<GoalContribution *> *) getContributions;
-(NSString *) getName;
-(NSNumber *) getSavingsTarget;
-(NSDate *) getStartDate;
-(NSDate *) getEndDate;
-(NSString *)getIconUrl;
-(void) setIconUrl:(NSString *)url;

// Operations
-(void) contribute:(GoalContribution *)contribution;
-(NSNumber *) daysRemaining;
-(NSNumber *) daysPast;
-(NSNumber *) numberOfContributions;
-(NSNumber *) totalContributed;
-(NSNumber *) completionPercentage;
-(NSNumber *) daysRemainingPercentage;
-(BOOL) hasDeadline;

-(NSString *)description;

-(BOOL) isEqual:(id)object;

@property  (readwrite, nonatomic) NSString *iconUrl;
@end

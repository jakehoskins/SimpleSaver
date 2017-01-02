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


-(id) initWithName:(NSString *)name savingsTarget:(NSNumber *)target forStartDate:(NSDate *)start andEndDate:(NSDate *)end;

// Getters
-(NSArray<GoalContribution *> *) getContributions;
-(NSString *) getName;
-(NSNumber *) getSavingsTarget;
-(NSDate *) getStartDate;
-(NSDate *) getEndDate;

// Operations
-(void) contribute:(GoalContribution *)contribution;
-(NSNumber *) daysRemaining;
-(NSNumber *) numberOfContributions;
-(NSNumber *) totalContributed;
-(BOOL) hasDeadline;

-(NSString *)description;

-(BOOL) isEqual:(id)object;
@end

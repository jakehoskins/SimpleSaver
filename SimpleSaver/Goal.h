//
//  Goal.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 01/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kGoalName;
extern NSString * const kIconUrl;
extern NSString * const kSavingsTarget;
extern NSString * const kCurrency;
extern NSString * const kContributions;
extern NSString * const kInitialContribution;
extern NSString * const kStartDate;
extern NSString * const kDeadlineDate;
@class GoalContribution;

@interface Goal : NSObject

// Deprecating soon
-(id) initWithName:(NSString *)name savingsTarget:(NSNumber *)target forStartDate:(NSDate *)start andEndDate:(NSDate *)end;

-(id) initWithDictionary:(NSDictionary *)dictionary;


// Getters
-(NSArray<GoalContribution *> *) getContributions;
-(NSString *) getName;
-(NSNumber *) getSavingsTarget;
-(NSDate *) getStartDate;
-(NSDate *) getEndDate;
-(NSString *)getIconUrl;
-(NSNumber *) daysRemaining;
-(NSNumber *) daysPast;
-(NSNumber *) numberOfContributions;
-(NSNumber *) totalContributed;
-(NSNumber *) completionPercentage;
-(NSNumber *) initialContribution;
-(NSNumber *) daysRemainingPercentage;
-(NSDictionary *) dictionaryForGoal;
-(NSString *) currency;
-(BOOL) hasDeadline;
-(BOOL) isOverdue;
-(BOOL) hasTarget;

// Setters
-(void) setIconUrl:(NSString *)url;
-(void) setContributons:(NSArray<GoalContribution *> *)contributions;

// Operations
-(void) contribute:(GoalContribution *)contribution;
-(void) removeContributionAtIndex:(NSInteger)index;
-(void) ammendContributionAtIndex:(NSInteger)index newContrbution:(GoalContribution *)newContribution;
-(NSString *)description;

-(BOOL) isEqual:(id)object;

@property  (readwrite, nonatomic) NSString *iconUrl;
@end

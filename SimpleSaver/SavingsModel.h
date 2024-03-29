//
//  SavingsModel.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 01/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Goal;

@interface SavingsModel : NSObject

extern NSString * const kProfile;


+ (id)getInstance;

- (void) assertContext;

-(void) addGoal:(Goal *) goal;

-(void) removeGoal:(Goal *)goal;

-(void) editGoalAtIndex:(NSInteger)index forGoal:(Goal *)goal;

-(NSArray *) getGoals;

-(void) writeToUserDefaults;

-(void) resetUserDefaults;

-(NSInteger) indexForGoal:(Goal *)goal;

@end

//
//  GoalContribution.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 01/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoalContribution : NSObject

-(id) initWithAmount:(NSNumber *)amount forDate:(NSDate *)date withNotes:(NSString *)notes;

-(NSNumber *) amount;
-(NSString *) notes;
-(NSDate *) contributionDate;
-(BOOL) isEqual:(id)object;
@end

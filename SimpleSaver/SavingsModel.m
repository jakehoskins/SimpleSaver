//
//  SavingsModel.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 01/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "SavingsModel.h"
#import "Goal.h"

NSString * const kProfile = @"ss-user-profile";

@interface SavingsModel()
@property (nonatomic, strong) NSMutableArray<Goal *> *goals;
@end

@implementation SavingsModel

// @TODO: We must ensure we listen to notifications from iCloud to force re-initialisation
+ (id)getInstance{
    static SavingsModel *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id) init
{
    self = [super init];
    
    if (self)
    {
        [self assertContext];
    }
    
    return self;
}

-(void) assertContext
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kProfile])
    {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kProfile];
        self.goals = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
    else
    {
        self.goals = [NSMutableArray array];
    }
}

-(void) addGoal:(Goal *) goal
{
    NSLog(@"Adding Goal: %@", [goal description]);
    
    [self.goals addObject:goal];
}

-(void) removeGoal:(Goal *)goal
{
    NSLog(@"Removing Goal: %@", [goal description]);
 
    [self.goals removeObject:goal];
}

-(void) editGoalAtIndex:(NSInteger)index forGoal:(Goal *)goal
{
    if ([self.goals objectAtIndex:index])
    {
        NSLog(@"Replacing Goal: %@ ",[[self.goals objectAtIndex:index] description]);
        NSLog(@"UpdatedGoal: %@", [goal description]);
        
        [self.goals replaceObjectAtIndex:index withObject:goal];
    }
}

-(NSInteger) indexForGoal:(Goal *)goal
{
    for (NSInteger i = 0; i < self.goals.count; i++)
    {
        if ([[self.goals objectAtIndex:i] isEqual:goal])
        {
            return i;
        }
    }
    
    return -1;
}

-(NSArray *) getGoals
{
    return self.goals;
}

-(void) writeToUserDefaults
{
    if (self.goals.count == 0) return;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.goals] forKey:kProfile];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) resetUserDefaults
{
    // Should re-init our self to update our context
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kProfile];
}

@end

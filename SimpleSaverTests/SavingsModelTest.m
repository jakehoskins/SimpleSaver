//
//  SavingsModelTest.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 01/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SavingsModel.h"
#import "Goal.h"

@interface SavingsModelTest : XCTestCase

@end

@implementation SavingsModelTest

- (void)setUp
{
    [super setUp];
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)tearDown
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super tearDown];
}

- (void)testAddGoal
{
    SavingsModel *model = [[SavingsModel alloc] init];
    int goalCount;
    NSString *name = @"Test Goal ";
    
    for(int i = 0; i < goalCount; i++)
    {
        Goal *goal = [[Goal alloc] initWithName:[NSString stringWithFormat:@"%@ %i", name, i] savingsTarget:@(10000) forStartDate:[NSDate date] andEndDate:[NSDate date]];
        
        [model addGoal:goal];
    }
    
    NSArray *goals = [model getGoals];
    
    XCTAssertTrue([goals count] == goalCount);
    
    for (int i = 0; i < goalCount; i++)
    {
        Goal *goal = [goals objectAtIndex:i];
        NSString *expectedName = [NSString stringWithFormat:@"%@ %i", name, i];
        
        XCTAssertTrue([[goal getName] isEqualToString:expectedName]);
    }
}

-(void) testEditGoal
{
    int goalCount = 10;
    int editIndex = 5;
    SavingsModel *model = [[SavingsModel alloc] init];
    NSString *name = @"Test Goal ";
    NSString *editName = @"Edited Goal";
    NSNumber *newSavingsTarget = @(500000);
    
    for(int i = 0; i < goalCount; i++)
    {
        Goal *goal = [[Goal alloc] initWithName:[NSString stringWithFormat:@"%@ %i", name, i] savingsTarget:@(10000) forStartDate:[NSDate date] andEndDate:[NSDate date]];
        
        [model addGoal:goal];
    }
    
    Goal *goal = [[Goal alloc] initWithName:editName savingsTarget:newSavingsTarget forStartDate:[[[model getGoals] objectAtIndex:editIndex] getStartDate] andEndDate:[[[model getGoals] objectAtIndex:editIndex] getEndDate]];
    
    [model editGoalAtIndex:editIndex forGoal:goal];
    
    NSLog(@"%@", [[[model getGoals] objectAtIndex:editIndex] getName]);
    NSLog(@"%@", [[[model getGoals] objectAtIndex:editIndex] getSavingsTarget]);
    
    XCTAssertTrue([[[[model getGoals] objectAtIndex:editIndex] getName] isEqualToString:editName]);
    XCTAssertTrue([[[model getGoals] objectAtIndex:editIndex] getSavingsTarget] == newSavingsTarget);
}

-(void) testWriteToUserDefaults
{
    int goalCount = 10;
    SavingsModel *model = [SavingsModel getInstance];
    NSString *name = @"Test Goal ";
    
    for(int i = 0; i < goalCount; i++)
    {
        Goal *goal = [[Goal alloc] initWithName:[NSString stringWithFormat:@"%@ %i", name, i] savingsTarget:@(10000) forStartDate:[NSDate date] andEndDate:[NSDate date]];
        
        [model addGoal:goal];
    }
    
    [model writeToUserDefaults];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kProfile];
    NSArray *savedGoals = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    XCTAssertTrue([savedGoals isEqualToArray:[model getGoals]]);
}

-(void) testInitForNSUserDefaults
{
    int goalCount = 10;
    SavingsModel *model = [SavingsModel getInstance];
    NSString *name = @"Test Goal ";
    NSMutableArray *persistance = [NSMutableArray array];
    
    for(int i = 0; i < goalCount; i++)
    {
        Goal *goal = [[Goal alloc] initWithName:[NSString stringWithFormat:@"%@ %i", name, i] savingsTarget:@(10000) forStartDate:[NSDate date] andEndDate:[NSDate date]];
        
        [model addGoal:goal];
        [persistance addObject:goal];
    }
    
    [model writeToUserDefaults];
    
    model = nil;
    
    model = [SavingsModel getInstance];
    
    NSArray<Goal *> *nonMutablePeristance = [NSArray arrayWithArray:persistance];
    
    XCTAssertTrue([nonMutablePeristance isEqualToArray:[model getGoals]]);
}
@end

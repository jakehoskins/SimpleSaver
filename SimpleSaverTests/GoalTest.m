//
//  GoalTest.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 01/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Goal.h"

@interface GoalTest : XCTestCase

@end

@implementation GoalTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitProperties
{
    NSString *name = @"Testing Savings Goal";
    NSNumber *target = @(10000);
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [NSDate date];
    Goal *goal = [[Goal alloc] initWithName:name savingsTarget:target forStartDate:startDate andEndDate:endDate];
    
    XCTAssert([goal getName] == name);
    XCTAssert([goal getSavingsTarget] == target);
    XCTAssert([goal getStartDate] == startDate);
}


@end

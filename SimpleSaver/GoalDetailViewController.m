//
//  GoalDetailViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 03/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "GoalDetailViewController.h"
#import "GoalsViewController.h"

// Model
#import "SavingsModel.h"

// Views
#import "GoalContributedView.h"

// Util
#import "Colours.h"
#import "Helpers.h"

#define PARENT_TOTAL_CONTRIBUTED @"%@"
#define CHILD_TOTAL_CONTRIBUTED ""

@interface GoalDetailViewController () <GoalContributedViewEvent, GoalSelection>
@property (nonatomic, strong) Goal *goal;
@property GoalContributedViewTouchState state;
@end

@implementation GoalDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.state = TotalContribution;
    self.gcv.delegate = self;
    [self setupUi];
}

-(void) setGoal:(Goal *)goal
{
    _goal = goal;
}

-(void) setupUi
{
    [self.btnAddFunds addTarget:self action:@selector(presentAddFundsView) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRemoveFunds addTarget:self action:@selector(presentAddFundsView) forControlEvents:UIControlEventTouchUpInside];
    [self.btnViewContributions addTarget:self action:@selector(presentViewContributionsView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnAddFunds setBackgroundColor:[UIColor seafoamColor]];
    [self.btnRemoveFunds setBackgroundColor:[UIColor salmonColor]];
    [self.btnViewContributions setBackgroundColor:[UIColor robinEggColor]];
    
    [self.btnAddFunds setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnRemoveFunds setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnViewContributions setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (self.goal)
    {
        [self.gcv reload];
        self.title = [self.goal getName];
    }
}

-(void) presentAddFundsView
{
    return;
}
-(void) presentRemoveFundsView
{
    return;
}
-(void) presentViewContributionsView
{
    return;
}

-(NSString *) getParentTextForState:(GoalContributedViewTouchState)state
{
    switch (state)
    {
        case TotalContribution:
            return [Helpers formatCurrency:@"#" forAmount:[self.goal totalContributed]];
            break;
        case TotalRemaining:
            return [NSString stringWithFormat:@"TODO"];
            break;
        default:
            break;
    }
}

-(NSString *) getChildTextForState:(GoalContributedViewTouchState)state
{
    switch (state)
    {
        case TotalContribution:
            return [NSString stringWithFormat:@"%li days remaining",[self.goal daysRemaining].integerValue];
            break;
        case TotalRemaining:
            return [NSString stringWithFormat:@"TODO"];
            break;
        default:
            break;
    }
}


#pragma mark GoalContributedViewEvent

- (NSString *) textForParent:(id)sender
{
    NSString *parentText = [self getParentTextForState:self.state];
    
    // CYCLE THE STATE
    
    return parentText;
}
- (NSString *) textForChild:(id)sender;
{
    NSString *childText = [self getChildTextForState:self.state];;
    
    // CYCLE THE STATE
    
    return childText;
}

#pragma GoalSelection

- (void) goalSelected:(Goal *)goal
{
    [self setGoal:goal];
    
    [self setupUi];
}
@end

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
#import "ChartsBuilder.h"

#define PARENT_TOTAL_CONTRIBUTED @"%@"
#define CHILD_TOTAL_CONTRIBUTED ""

@interface GoalDetailViewController () <GoalContributedViewEvent, GoalSelection, UIScrollViewDelegate>
@property (nonatomic, strong) Goal *goal;
@property NSInteger numberOfCharts;
@property GoalContributedViewTouchState state;
@end

@implementation GoalDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.state = TotalContribution;
    [self initUi];
    [self refreshUi];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self refreshScrollView];
}

-(void)initUi
{
    self.gcv.delegate = self;
    self.numberOfCharts = 3; //  may need to move elsewhere
    self.scrollView.showsVerticalScrollIndicator = false;
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.pagingEnabled = true;
    self.scrollView.delegate = self;
}

-(void)refreshScrollView
{
    
    [self removeAllSubviewsFromView:self.scrollView];
    self.pageControl.backgroundColor = [UIColor lightGrayColor];
    self.pageControl.numberOfPages = self.numberOfCharts;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width*self.numberOfCharts, self.scrollView.frame.size.height)];
    
    CGFloat x = 0.0f;
    for (int i = 0; i < self.numberOfCharts; i++)
    {
        // Have a build chart for state and goal factory function
        UIView *view = [ChartsBuilder buildTotalContributedViewForGoal:self.goal];
        
        view.frame = CGRectMake(x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        x+=view.frame.size.width;

        [self.scrollView addSubview:view];
    }
}

-(void) removeAllSubviewsFromView:(UIView *)view
{
    for (UIView *subview in view.subviews)
    {
        [subview removeFromSuperview];
    }
    
}
-(void) setGoal:(Goal *)goal
{
    _goal = goal;
}

// Probably needs to be `reloadForGoalContributedEventChange`
-(void) refreshUi
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

-(GoalContributedViewTouchState) rotateState
{
    switch (self.state)
    {
        case TotalContribution:
            return TotalRemaining;
            break;
        case TotalRemaining:
            return TotalContribution;
            break;
        default:
            return TotalContribution;
            break;
    }
}

#pragma mark ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.bounds.size.width;
    NSInteger pageNumber = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = pageNumber;
}

#pragma mark GoalContributedViewEvent

- (NSString *) textForParent:(id)sender
{
    NSString *parentText = [self getParentTextForState:self.state];
    
    return parentText;
}
- (NSString *) textForChild:(id)sender;
{
    NSString *childText = [self getChildTextForState:self.state];;
    
    return childText;
}


-(void) didCallDelegates:(id)sender
{
    self.state = [self rotateState];
}
#pragma GoalSelection

- (void) goalSelected:(Goal *)goal
{
    [self setGoal:goal];
    [self refreshScrollView];
    [self refreshUi];
}
@end

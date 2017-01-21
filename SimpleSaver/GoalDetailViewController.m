//
//  GoalDetailViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 03/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "GoalDetailViewController.h"
#import "GoalsViewController.h"
#import "GoalContributionViewController.h"
#import "GoalContributionsTableViewController.h"

// Model
#import "SavingsModel.h"
#import "GoalContribution.h"
// Views
#import "GoalContributedView.h"

// Util
#import "Colours.h"
#import "Helpers.h"
#import "ChartsBuilder.h"


@interface GoalDetailViewController () <GoalContributedViewEvent, GoalSelection, UIScrollViewDelegate, ContributionEvent>
@property (nonatomic, strong) Goal *goal;
@property GoalContributedViewTouchState state;
@property NSArray *availableCharts;
@end

@implementation GoalDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUi];
    [self reloadForGoalChange];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self refreshScrollView];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self reloadForGoalChange];
}
-(void)initUi
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail-background"]];
    self.gcv.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = false;
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.pagingEnabled = true;
    self.scrollView.delegate = self;
}

-(void)refreshScrollView
{
    
    [self removeAllSubviewsFromView:self.scrollView];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.numberOfPages = self.availableCharts.count;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width*self.availableCharts.count, self.scrollView.frame.size.height)];
    [self.pageControl addTarget:self action:@selector(changePageManually:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat x = 0.0f;
    for (int i = 0; i < self.availableCharts.count; i++)
    {
        UIView *view = [ChartsBuilder buildChart:[[self.availableCharts objectAtIndex:i] integerValue] forGoal:self.goal];
        
        view.frame = CGRectMake(x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        x+=view.frame.size.width;

        [self.scrollView addSubview:view];
    }
}

-(void) changePageManually:(id) sender
{
    UIPageControl *pager=sender;
    NSInteger page = pager.currentPage;
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
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
    
    self.availableCharts = [self declareAvailableCharts];
}

-(NSArray *) declareAvailableCharts
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@(ChartCircularContribution), @(ChartContributed), nil];
    
    if (self.goal.hasTarget)
    {
        [array addObject:@(ChartBurndown)];
    }
    
    return [NSArray arrayWithArray:array];
}

// Probably needs to be `reloadForGoalContributedEventChange`
-(void) reloadForGoalChange
{
    self.state = TotalContribution;
    [self.btnAddFunds addTarget:self action:@selector(presentAddFundsView) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRemoveFunds addTarget:self action:@selector(presentRemoveFundsView) forControlEvents:UIControlEventTouchUpInside];
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
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

-(void) presentAddFundsView
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GoalContributionViewController *vc = (GoalContributionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoalContributionViewController"];
    [vc setType:ContributionTypeCreateAddFunds];
    [vc setDelegate:self];
    [self presentViewController:vc];
}

-(void) presentRemoveFundsView
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GoalContributionViewController *vc = (GoalContributionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoalContributionViewController"];
    [vc setType:ContributionTypeCreateRemoveFunds];
    [vc setDelegate:self];
    [self presentViewController:vc];
}

-(void) presentViewContributionsView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GoalContributionsTableViewController *vc = (GoalContributionsTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoalContributionsTableViewController"];

    [vc setGoal:self.goal];
    
    [self.navigationController pushViewController:vc animated:true];
}

-(void) presentViewController:(UIViewController *)viewController
{
    if (![Helpers isIpad])
    {
        [self.navigationController pushViewController:viewController animated:true];
    }
    else
    {
        UIPopoverController *popOverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
        [popOverController setPopoverContentSize:CGSizeMake(viewController.view.frame.size.width, viewController.view.frame.size.width)];
        
        [popOverController presentPopoverFromRect:self.btnAddFunds.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
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
            return TotalContributions;
            break;
        case TotalContributions:
            return TotalContribution;
        default:
            return TotalContribution;
            break;
    }
}

-(NSString *) getTotalContributedString
{
    return [Helpers formatCurrency:@"#" forAmount:[self.goal totalContributed]];
}

-(NSString *) getTotalRemainingString
{
    return [Helpers formatCurrency:@"#" forAmount:@([self.goal getSavingsTarget].doubleValue - [self.goal totalContributed].doubleValue)];
}

-(NSString *) getTotalElapsedTimeString
{
    if (![self.goal isOverdue])
    {
        return [NSString stringWithFormat:@"%li days remaining",[self.goal daysRemaining].integerValue];
    }
    else
    {
        return [NSString stringWithFormat:@"%i days overdue",abs([self.goal daysRemaining].intValue)];
    }
}

-(NSString *) getNumberOfContributions
{
    return [NSString stringWithFormat:@"%i", self.goal.numberOfContributions.intValue];
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
    switch (self.state)
    {
        case TotalContribution:
            return [self getTotalContributedString];
            break;
        case TotalRemaining:
            if ([self.goal hasTarget])
            {
                return [self getTotalRemainingString];
            }
            break;
        case TotalContributions:
            return [self getNumberOfContributions];
        default:
            break;
    }
    
    return ((GoalContributedView *)sender).lblParent.text;
}
- (NSString *) textForBottomChild:(id)sender;
{
    switch (self.state)
    {
        case TotalContribution:
            if ([self.goal hasDeadline])
            {
                return [self getTotalElapsedTimeString];
            }
            break;
        case TotalRemaining:
            break;
        case TotalContributions:
            break;
        default:
            break;
    }
    
    return ((GoalContributedView *)sender).lblBottomChild.text;
}

- (NSString *) textForTopChild:(id)sender
{
    if ([self.goal hasTarget])
    {
        return [Helpers formatCurrency:@"Savings Target: #" forAmount:[self.goal getSavingsTarget]];
    }
    
    return ((GoalContributedView *)sender).lblTopChild.text;
}

-(NSString *) textForParentInfo:(id)sender
{
    switch (self.state)
    {
        case TotalContribution:
            return @"total saved";
            break;
        case TotalRemaining:
            if ([self.goal hasTarget])
            {
                return @"total remaining";
            }
            break;
        case TotalContributions:
            return @"contributions";
        default:
            break;
    }
    
    return ((GoalContributedView *)sender).lblParentInfo.text;
}

-(void) didCallDelegates:(id)sender
{
    self.state = [self rotateState];
}

// Used when goal contribution view controller needs dismissing
-(void) dismissCurrentViewController
{
    if(![Helpers isIpad])
    {
        [self.navigationController popViewControllerAnimated:true];
    } else
    {
        [self.navigationController.presentedViewController dismissViewControllerAnimated:true completion:nil];
    }
    
}

-(void) addPositiveContribution:(NSNumber *) amount withNotes:(NSString *)notes
{
    GoalContribution *contribution = [[GoalContribution alloc] initWithAmount:amount forDate:[NSDate date] withNotes:notes];
    
    [self.goal contribute:contribution];
    [[SavingsModel getInstance] writeToUserDefaults];
    
    [self reloadForGoalChange];
    
    // @TODO::: Notify the left vc to update
}

-(void) addNegativeContribution:(NSNumber *) amount withNotes:(NSString *)notes
{
    GoalContribution *contribution = [[GoalContribution alloc] initWithAmount:@(-amount.doubleValue) forDate:[NSDate date] withNotes:notes];
    
    [self.goal contribute:contribution];
    [[SavingsModel getInstance] writeToUserDefaults];
    
    [self reloadForGoalChange];
    
    // @TODO::: Notify the left vc to update
}

#pragma mark GoalSelection

- (void) goalSelected:(Goal *)goal
{
    [self setGoal:goal];
    [self refreshScrollView];
    [self reloadForGoalChange];
}

#pragma mark ContributionEvent
- (void) contributionWasMade:(ContributionType)contributionType forAmount:(NSNumber *)amount andNotes:(NSString *)notes
{
    switch (contributionType)
    {
        case ContributionTypeCreateAddFunds:
            [self dismissCurrentViewController];
            [self addPositiveContribution:amount withNotes:notes];
            break;
        case ContributionTypeCreateRemoveFunds:
            [self dismissCurrentViewController];
            [self addNegativeContribution:amount withNotes:notes];
            break;
        default:
            break;
    }
}

#pragma Rotation
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.view setNeedsLayout];
}
@end

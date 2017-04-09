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
#import "Skin.h"
#import "GoalMeta.h"

// Views
#import "GoalContributedView.h"
#import "SteppedControlPannelView.h"

// Util
#import "Colours.h"
#import "Helpers.h"
#import "ChartsBuilder.h"
#import "Constants.h"
#import "Skin.h"

@interface GoalDetailViewController () <GoalContributedViewEvent, GoalSelection, UIScrollViewDelegate, ContributionEvent, SteppedControlPannelDataSource, SteppedControlPannelEvent>
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
    [self.controlPannel setDelegate:self];
    [self.controlPannel setDatasource:self];
    [self.controlPannel reloadDatasource];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self refreshScrollView];
    [self reloadForGoalChange];
}
-(void)initUi
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[Skin backgroundImageForDetail]];
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
        UIView *view = [[ChartsBuilder sharedInstance] buildChart:[[self.availableCharts objectAtIndex:i] integerValue] forGoal:self.goal];
        
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
    [vc setCurrency:self.goal.currency];
    [self presentViewController:vc];
}

-(void) presentRemoveFundsView
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GoalContributionViewController *vc = (GoalContributionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoalContributionViewController"];
    [vc setType:ContributionTypeCreateRemoveFunds];
    [vc setDelegate:self];
    [vc setCurrency:self.goal.currency];
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
        [popOverController setPopoverContentSize:CGSizeMake(MAX_POPOVER_WIDTH, MAX_POPOVER_HEIGHT)];
        [popOverController presentPopoverFromRect:self.controlPannel.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
    }
}

-(GoalContributedViewTouchState) rotateState
{
    GoalContributedViewTouchState fromTotalContributions = ([self canDisplayMonthlyAverageNeeded]) ? TotalMonthlyAverageNeeded : TotalContribution;
    
    switch (self.state)
    {
        case TotalContribution:
            return TotalRemaining;
            break;
        case TotalRemaining:
            return TotalContributions;
            break;
        case TotalContributions:
            return fromTotalContributions;
            break;
        case TotalMonthlyAverageNeeded:
            return TotalContribution;
            break;
        default:
            return TotalContribution;
            break;
    }
}

-(BOOL) canDisplayMonthlyAverageNeeded
{
    return (self.goal.hasDeadline && self.goal.hasTarget && !self.goal.isOverdue);
}

-(NSString *) getTotalContributedString
{
    return [Helpers formatCurrency:self.goal.currency forAmount:[self.goal totalContributed]];
}

-(NSString *) getTotalRemainingString
{
    return [Helpers formatCurrency:self.goal.currency forAmount:@([self.goal getSavingsTarget].doubleValue - [self.goal totalContributed].doubleValue)];
}

-(NSString *) getTotalElapsedTimeString
{
    if (![self.goal isOverdue] && [self.goal hasDeadline])
    {
        NSDateComponents *components;
        components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear ) fromDate: [self.goal getStartDate] toDate:[NSDate date] options: 0];
        
        return [NSString stringWithFormat:@"%@",[Helpers formatTimeInterval:components]].uppercaseString;
    }
    else if([self.goal hasDeadline])
    {
        NSDateComponents *components;
        components = [[NSCalendar currentCalendar] components: (NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMonth | NSCalendarUnitYear ) fromDate:[NSDate date] toDate:[self.goal getStartDate] options: 0];
        
        return [NSString stringWithFormat:@"%@",[Helpers formatTimeInterval:components]].uppercaseString;
    }
    
    return @"";
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
    GoalMeta *goalMeta = [[GoalMeta alloc] initWithGoal:self.goal];
    
    switch (self.state)
    {
        case TotalContribution:
            return [self getTotalContributedString];
            break;
        case TotalRemaining:
            // Lol don't do this, see how we do it for avg needed
            if ([self.goal hasTarget])
            {
                return [self getTotalRemainingString];
            }
            break;
        case TotalContributions:
            return [self getNumberOfContributions];
        case TotalMonthlyAverageNeeded:
            return [Helpers formatCurrency:self.goal.currency forAmount:[goalMeta averageMonthlyNeededToReachTarget]];
            break;
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
        return [Helpers formatCurrency:[NSString stringWithFormat:@"TARGET: %@", self.goal.currency] forAmount:[self.goal getSavingsTarget]];
    }
    
    return ((GoalContributedView *)sender).lblTopChild.text;
}

-(NSString *) textForParentInfo:(id)sender
{
    switch (self.state)
    {
        case TotalContribution:
            return [@"total saved" uppercaseString];
            break;
        case TotalRemaining:
            // Lol don't do this, see how we do it for avg needed
            if ([self.goal hasTarget])
            {
                return [@"total remaining" uppercaseString];
            }
            break;
        case TotalContributions:
            return [@"contributions" uppercaseString];
            break;
        case TotalMonthlyAverageNeeded:
            return [@"monthly avg. required" uppercaseString];
            break;
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
}

-(void) addNegativeContribution:(NSNumber *) amount withNotes:(NSString *)notes
{
    GoalContribution *contribution = [[GoalContribution alloc] initWithAmount:@(-amount.doubleValue) forDate:[NSDate date] withNotes:notes];
    
    [self.goal contribute:contribution];
    [[SavingsModel getInstance] writeToUserDefaults];
    
    [self reloadForGoalChange];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GOAL_UPDATE object:self.goal];
}

#pragma mark - Rotation

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.view setNeedsLayout];
}

# pragma mark - Control Pannel Datasource

-(NSString *) textforLeftButton
{
    return @"View Contributions";
}

-(NSString *) textforMiddleButton
{
    return @"Remove Funds";
}

-(NSString *) textForRightButton
{
    return @"Add Funds";
}

#pragma mark - Control Panel Delegate

- (void) leftButtonClicked
{
    [self presentViewContributionsView];
}
- (void) middleButtonClicked
{
    [self presentRemoveFundsView];
}
- (void) rightButtonClicked
{
    [self presentAddFundsView];
}

- (UIColor *) backgroundColourForLeftButton
{
    return [Skin defaultBlueColour];
}
- (UIColor *) backgroundColourForMiddleButton
{
    return [Skin defaultRedColour];
}
- (UIColor *) backgroundColourForRightButton
{
    return [Skin defaultGreenColour];
}

@end

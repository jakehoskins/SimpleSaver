//
//  GoalsViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 02/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

// View Controllers
#import "GoalsViewController.h"
#import "StepOneViewController.h"
#import "GoalDetailViewController.h"
#import "IAPPurchaseTableViewController.h"

// Views
#import "YLProgressBar.h"
#import "NZCircularImageView.h"

// Model
#import "SavingsModel.h"
#import "Goal.h"
#import "StepOneViewController.h"
#import "SteppedNavigationViewController.h"

// Util
#import "Constants.h"
#import "Helpers.h"
#import "Colours.h"

// Mocks
#import "GoalContribution.h"

@interface GoalsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) Goal *lastSelectedGoal;
@end

@implementation GoalsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.createGoal.target = self;
    self.createGoal.action = @selector(presentCreateGoalViewController);
    self.btnInAppPurchase.target = self;
    self.btnInAppPurchase.action = @selector(presentInAppPurchaseViewController);
    [self hideIAPIfNeeded];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColour = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    self.tableView.backgroundColor = self.backgroundColour;
    [[SavingsModel getInstance] resetUserDefaults];
    
    if ([[SavingsModel getInstance] getGoals].count == 0)
    {
        [self setupMockDataForSize:12];
    }
    
    [self setupNavigationBarImage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    if ([Helpers isIpad] && [[SavingsModel getInstance] getGoals].count > 0)
    {
        [self.tableView selectRowAtIndexPath:indexPath animated:animated  scrollPosition:UITableViewScrollPositionTop];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
    
    // Register to receive notifications for when contributions have been edited / deleted / created
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveUpdateNotification:) name:NOTIFICATION_GOAL_UPDATE object:nil];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_GOAL_UPDATE object:nil];
    
    [super viewDidDisappear:animated];
}

-(void) didReceiveUpdateNotification:(NSNotification *) notificaton
{
    [self.tableView reloadData];
}
#pragma mark private

-(void) hideIAPIfNeeded
{
    // No .hidden property on UIBarButtonIte
    if (!SHOULD_SHOW_IAP)
    {
        self.btnInAppPurchase.enabled = false;
        self.btnInAppPurchase.tintColor = [UIColor clearColor];
    }
}
-(void)setupNavigationBarImage
{
    UIImage *image = [UIImage imageNamed:@"simplesaver"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    self.navigationItem.titleView = imageView;
}

- (void) setupMockDataForSize:(NSInteger)numFakes
{
    SavingsModel *model = [SavingsModel getInstance];
    for (int i = 0; i < numFakes; i++)
    {
        NSString *name = [NSString stringWithFormat:@"Goal %i", i + 1];
        NSNumber *savingsTarget = [Helpers randomNumberBetween:0.00f and:9999999.00f];
        NSInteger numContributions = [Helpers randomNumberBetween:0.0f and:100.0f].integerValue;
        NSDate *startDate = [Helpers addDaysToDate:[NSDate date] increaseBy:[Helpers randomNumberBetween:-1.0f and:-2880.0f].integerValue];
        NSDate *endDate = [Helpers addDaysToDate:startDate increaseBy:[Helpers randomNumberBetween:1.0f and:2880.0f].integerValue];
        Goal *goal = [[Goal alloc] initWithName:name savingsTarget:savingsTarget forStartDate:startDate andEndDate:endDate];
        
        
        [goal setIconUrl:[self randomGoalmage]];
        
        [self setupMockContributionsForGoal:goal withNumberOfContributions:numContributions];
        
        [model addGoal:goal];
    }
    
    [model writeToUserDefaults];
}

-(NSString *)randomGoalmage
{
    NSArray *urls = [Constants getGoalIconURLSet];
    NSInteger randomIndex = [Helpers randomNumberBetween:0.0f and:urls.count].integerValue;
    
    return [urls objectAtIndex:randomIndex];
}

-(void) setupMockContributionsForGoal:(Goal *)goal withNumberOfContributions:(NSInteger)numContributions
{
    NSString *notes = @"This is some mocked notes used to distinguish between placeholders in testing...";
    
    for (NSInteger i = 0; i < numContributions; i++)
    {
        NSNumber *amount = [Helpers randomNumberBetween:-1000 and:10000];
        GoalContribution *contribution = [[GoalContribution alloc] initWithAmount:amount forDate:[Helpers addDaysToDate:[goal getStartDate] increaseBy:5*i] withNotes:notes];
        
        [goal contribute:contribution];
    }
}

-(void) presentInAppPurchaseViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    IAPPurchaseTableViewController *iap = (IAPPurchaseTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"IAPPurchaseTableViewController"];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:iap];
    
    [self presentViewController:navigation animated:true completion:nil];
}

-(void) presentCreateGoalViewControllerWithEditingGoal:(Goal *)goal
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StepOneViewController *cgvc = (StepOneViewController *)[storyboard instantiateViewControllerWithIdentifier:@"StepOneViewController"];
    SteppedNavigationViewController *snvc = [[SteppedNavigationViewController alloc] initWithRootViewController:cgvc isEditing:true];
    cgvc.delegate = snvc;
    snvc.goalItems = [NSMutableDictionary dictionaryWithDictionary:[goal dictionaryForGoal]];
    snvc.goalIndex = [[SavingsModel getInstance] indexForGoal:goal];
    [self presentViewController:snvc animated:true completion:nil];
}

-(void) presentCreateGoalViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StepOneViewController *cgvc = (StepOneViewController *)[storyboard instantiateViewControllerWithIdentifier:@"StepOneViewController"];
    SteppedNavigationViewController *snvc = [[SteppedNavigationViewController alloc] initWithRootViewController:cgvc isEditing:false];
    
    [self presentViewController:snvc animated:true completion:nil];
}

-(void) presentViewController:(UIViewController *)viewController
{
    if (![Helpers isIpad])
    {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        [self presentViewController:navController animated:true completion:nil];
    }
    else
    {
        UIPopoverController *popOverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
        [popOverController setPopoverContentSize:CGSizeMake(viewController.view.frame.size.width, viewController.view.frame.size.width)];
        
        [popOverController presentPopoverFromBarButtonItem:self.createGoal permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
    }
}

-(void) dismissModal
{
    [self dismissViewControllerAnimated:true completion:nil];
}


-(UIViewController *) detailViewController
{
    UIViewController *detailVC = nil;
    if (self.splitViewController.viewControllers.count > 1) {
        detailVC = self.splitViewController.viewControllers[1];
    }
    
    return detailVC;
}

#pragma mark TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[SavingsModel getInstance] getGoals].count;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = [self detailViewController];
    BOOL willPush = false;
    Goal *goal = [[[SavingsModel getInstance] getGoals] objectAtIndex:indexPath.row];
    
    self.lastSelectedGoal = [[[SavingsModel getInstance] getGoals] objectAtIndex:indexPath.row];
    if ([detail isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *) detail;
        
        detail = [nav.viewControllers firstObject];
    }
    
    willPush = (!detail);
    
    // iPhone wont have the vc loaded so load it
    if (willPush)
    {
        detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    }
    
    // Set some important properties for GoalDetailViewController
    if ([detail isKindOfClass:[GoalDetailViewController class]])
    {
        self.delegate = detail;
        
        [self.delegate goalSelected:goal];
        
        // On iPhone we need to push the vc 
        if (willPush)
        {
            [self.navigationController pushViewController:detail animated:true];
        }
    }
    
    // Push a notification as other than our detail we may have views who care about what goal we have updated to
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NEW_GOAL_SELECTED object:goal];
    
     [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        Goal *goal = [[[SavingsModel getInstance] getGoals] objectAtIndex:indexPath.row];
        
        [self presentCreateGoalViewControllerWithEditingGoal:goal];
    }];
    editAction.backgroundColor = [UIColor pastelBlueColor];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        SavingsModel *model = [SavingsModel getInstance];
        Goal *goal = [[model getGoals] objectAtIndex:indexPath.row];
        [model removeGoal:goal];
        [model writeToUserDefaults];
        [self.tableView reloadData];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction,editAction];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goals-cell"];
    UILabel *goalName = (UILabel *)[cell viewWithTag:100];
    YLProgressBar *contributionsVsTotal = (YLProgressBar *)[cell viewWithTag:101];
    YLProgressBar *daysVsDaysRemaining = (YLProgressBar *)[cell viewWithTag:102];
    NZCircularImageView *iconView = (NZCircularImageView *)[cell viewWithTag:103];
    
    Goal *goal = [[[SavingsModel getInstance] getGoals] objectAtIndex:indexPath.row];
    
    goalName.text = [goal getName];
    
    
    cell.backgroundColor = [UIColor clearColor];
    [self setupProgressIndicatorForIndicator:contributionsVsTotal forContext:ProgressContributedVsTotal forGoal:goal];
    [self setupProgressIndicatorForIndicator:daysVsDaysRemaining forContext:ProgressDaysVsDaysRemaining forGoal:goal];
    [self setupGoalIconForGoal:goal forImageView:iconView];
    return cell;
}

-(void) setupGoalIconForGoal:(Goal *)goal forImageView:(NZCircularImageView *)imageView
{
    imageView.borderColor = [UIColor goldColor];
    imageView.borderWidth = @(1.0f);
    imageView.image = [UIImage imageNamed:[goal getIconUrl]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
}

-(void) setupProgressIndicatorForIndicator:(YLProgressBar *)progress forContext:(ProgressIndicator)indicator forGoal:(Goal *)goal
{
    if ([self shouldDisplayIndicatorForContext:indicator forGoal:goal])
    {
        [self setupDefaultsForIndicator:progress];
        NSNumber *completion;
        
        switch (indicator)
        {
            case ProgressContributedVsTotal:
                completion = [goal completionPercentage];
                progress.progressTintColor  = [self colourForProgressValue:completion];
                progress.progress = completion.doubleValue;
                progress.indicatorTextLabel.text = [Helpers formatCurrency:goal.currency forAmount:[goal totalContributed]];
                break;
            case ProgressDaysVsDaysRemaining:
                completion = [goal daysRemainingPercentage];
                progress.progressTintColor  = [self colourForProgressValue:completion];
                progress.progress = completion.doubleValue;
                progress.indicatorTextLabel.text = [NSString stringWithFormat:@"%2.f days remaining.", [goal daysRemaining].doubleValue];
                progress.indicatorTextLabel.font = [UIFont systemFontOfSize:14.0f];
                break;
            default:
                break;
        }
    }
    else
    {
        progress.hidden = true;
    }
}

-(void) setupDefaultsForIndicator:(YLProgressBar *)progress
{
    progress.type = YLProgressBarTypeRounded;
    progress.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeFixedRight;
    progress.hideStripes = true;
    progress.trackTintColor = [UIColor clearColor];
    progress.indicatorTextLabel.textColor = [UIColor blackColor];
    progress.uniformTintColor = true;
}

-(BOOL) shouldDisplayIndicatorForContext:(ProgressIndicator)indicator forGoal:(Goal *)goal
{
    switch (indicator)
    {
        case ProgressContributedVsTotal:
            return true;
            break;
            
        case ProgressDaysVsDaysRemaining:
            return ([goal hasDeadline]);
            break;
        default:
            break;
    };
}

-(UIColor *) colourForProgressValue:(NSNumber *)value
{
    if (value.doubleValue <= 0.f)
    {
        return [UIColor dangerColor];
    }
    else if(value.doubleValue < 0.2f)
    {
        return [UIColor salmonColor];
    }
    else if(value.doubleValue < 0.4f)
    {
        return [UIColor robinEggColor];
    }
    else if(value.doubleValue < 0.6f)
    {
        return [UIColor skyBlueColor];
    }
    else if(value.doubleValue < 0.8f)
    {
        return [UIColor honeydewColor];
    }
    else if(value.doubleValue < 1.00f)
    {
        return [UIColor pastelGreenColor];
    } else
    {
        return [UIColor successColor];
    }
}

#pragma Rotation
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.view setNeedsLayout];
    
    if(self.lastSelectedGoal && self.delegate)
    {
        [self.delegate goalSelected:self.lastSelectedGoal];
    }
}

@end

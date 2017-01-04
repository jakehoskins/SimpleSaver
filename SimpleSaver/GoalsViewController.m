//
//  GoalsViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 02/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

// View Controllers
#import "GoalsViewController.h"
#import "CreateGoalViewController.h"

// Views
#import "YLProgressBar.h"
#import "NZCircularImageView.h"

// Model
#import "SavingsModel.h"
#import "Goal.h"

// Util
#import "Constants.h"
#import "Helpers.h"
#import "Colours.h"

// Mocks
#import "GoalContribution.h"

@interface GoalsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation GoalsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.createGoal.target = self;
    self.createGoal.action = @selector(presentCreateGoalViewController);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColour = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
    self.tableView.backgroundColor = self.backgroundColour;
    [[SavingsModel getInstance] resetUserDefaults];
    
    if ([[SavingsModel getInstance] getGoals].count == 0)
    {
        [self setupMockDataForSize:5];
    }
    self.title = @"SimpleSaver";
}

#pragma mark private

- (void) setupMockDataForSize:(NSInteger)numFakes
{
    SavingsModel *model = [SavingsModel getInstance];
    for (int i = 0; i < numFakes; i++)
    {
        NSString *name = [NSString stringWithFormat:@"Goal %i", i + 1];
        NSNumber *savingsTarget = [Helpers randomNumberBetween:0.00f and:9999999.00f];
        NSInteger numContributions = [Helpers randomNumberBetween:0.0f and:100.0f].integerValue;
        NSDate *startDate = [NSDate date];
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
    NSString *notes = @"Some notes...";
    
    for (NSInteger i = 0; i < numContributions; i++)
    {
        NSNumber *amount = [Helpers randomNumberBetween:0.00f and:10000];
        GoalContribution *contribution = [[GoalContribution alloc] initWithAmount:amount forDate:[NSDate date] withNotes:notes];
        
        [goal contribute:contribution];
    }
}

-(void) presentCreateGoalViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateGoalViewController *cgvc = (CreateGoalViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CreateGoalViewController"];
    
    [self presentViewController:cgvc];
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


#pragma mark TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[SavingsModel getInstance] getGoals].count;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // @TODO: implement
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        SavingsModel *model = [SavingsModel getInstance];
        Goal *goal = [[model getGoals] objectAtIndex:indexPath.row];
        [model removeGoal:goal];
        [model writeToUserDefaults];
        [self.tableView reloadData];
    }
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
                progress.indicatorTextLabel.text = [Helpers formatCurrency:@"#" forAmount:[goal totalContributed]];
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

@end

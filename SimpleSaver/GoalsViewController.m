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

// Model
#import "SavingsModel.h"
#import "Goal.h"

// Util
#import "Helpers.h"

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
    [[SavingsModel getInstance] resetUserDefaults];
    [self setupMockDataForSize:5];
}

#pragma mark private

- (void) setupMockDataForSize:(NSInteger)numFakes
{
    SavingsModel *model = [SavingsModel getInstance];
    
    for (int i = 0; i < numFakes; i++)
    {
        NSString *name = [NSString stringWithFormat:@"Goal %i", i + 1];
        NSNumber *savingsTarget = [Helpers randomNumberBetween:0.00f and:9999999.00f];
        NSDate *startDate = [NSDate date];
        NSDate *endDate = [Helpers addDaysToDate:startDate increaseBy:[Helpers randomNumberBetween:1.0f and:2880.0f].integerValue];
        Goal *goal = [[Goal alloc] initWithName:name savingsTarget:savingsTarget forStartDate:startDate andEndDate:endDate];
        
        // Setup contributions here
        
        [model addGoal:goal];
    }
    
    [model writeToUserDefaults];
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
    Goal *goal = [[[SavingsModel getInstance] getGoals] objectAtIndex:indexPath.row];
    
    goalName.text = [goal getName];
    
    return cell;
}

@end

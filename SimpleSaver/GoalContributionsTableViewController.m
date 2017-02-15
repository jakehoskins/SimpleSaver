//
//  GoalContributionsTableViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 21/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "GoalContributionsTableViewController.h"
#import "GoalContributionViewController.h"

// Model
#import "Goal.h"
#import "GoalContribution.h"
#import "SavingsModel.h"

// Util
#import "Helpers.h"
#import "Colours.h"
#import "Constants.h"
#import "Skin.h"

@interface GoalContributionsTableViewController () <ContributionEvent>

@end

@implementation GoalContributionsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setSeparatorColor:[UIColor blackColor]];
    self.title = @"Contributions";
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[Skin backgroundImageForDetail]];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Register for goal change notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveGoalNotification:) name:NOTIFICATION_NEW_GOAL_SELECTED object:nil];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_NEW_GOAL_SELECTED object:nil];
    [super viewDidDisappear:animated];
}

-(void) didRecieveGoalNotification:(NSNotification *)notification
{
    if ([[notification object] isKindOfClass:[Goal class]])
    {
        Goal *goal = (Goal *) [notification object];
        
        self.goal = goal;
        
        [self.tableView reloadData];
    }
}

-(void) presentGoalContributeNormalForGoalContribution:(GoalContribution *)contribution
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GoalContributionViewController *vc = (GoalContributionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoalContributionViewController"];
    [vc setType:ContributionTypeNormal];
    [vc setDelegate:self];
    [vc setContribution:contribution];
    
    [self presentViewController:vc];
}

-(void) presentGoalContributionEditForGoalContrbution:(GoalContribution *)contribution
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GoalContributionViewController *vc = (GoalContributionViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoalContributionViewController"];
    [vc setDelegate:self];
    [vc setContribution:contribution];
    [vc setType:ContributionTypeCreateAmmendContribution];
    
    [self presentViewController:vc];
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
        
        [popOverController presentPopoverFromRect:self.navigationController.navigationBar.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
    }
}


-(UIColor *) cellBackgroundForAmount:(NSNumber *)amount
{
    if (amount.doubleValue < 0)
    {
        return [Skin defaultRedColour];
    }
    else
    {
        return [Skin defaultGreenColour];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        GoalContribution *contribution = [[self.goal getContributions] objectAtIndex:[self reversedIndex:indexPath.row]];
        self.previousSelection = [self reversedIndex:indexPath.row];
        [self presentGoalContributionEditForGoalContrbution:contribution];
    }];
    editAction.backgroundColor = [UIColor pastelBlueColor];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self.goal removeContributionAtIndex:[self reversedIndex:indexPath.row]];
        [[SavingsModel getInstance] writeToUserDefaults];
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GOAL_UPDATE object:self.goal];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction,editAction];
}

// Want most recent at top so change how we access the list
-(NSInteger) reversedIndex:(NSInteger)index
{
    return ([self.goal getContributions].count - 1) - index;
}

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
#pragma mark - ContributionEvent

-(void) ammendmentWasMade:(AmmendmentType)ammendmentType forAmount:(NSNumber *)amount andNotes:(NSString *)notes
{
    
    [self dismissCurrentViewController];
    
    NSNumber *trueAmount = (ammendmentType == AmmendmentTypeNegative) ? @(-amount.doubleValue) : amount;
    
    GoalContribution *original = [[self.goal getContributions] objectAtIndex:self.previousSelection];
    GoalContribution *ammended = [[GoalContribution alloc] initWithAmount:trueAmount forDate:original.contributionDate withNotes:notes];
    
    [self.goal ammendContributionAtIndex:self.previousSelection newContrbution:ammended];
    
    [[SavingsModel getInstance] writeToUserDefaults];
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GOAL_UPDATE object:self.goal];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.goal getContributions].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contribution-cell" forIndexPath:indexPath];
    UILabel *amount = (UILabel *)[cell viewWithTag:300];
    UILabel *date = (UILabel *)[cell viewWithTag:301];
    GoalContribution *contribution = [[self.goal getContributions] objectAtIndex:[self reversedIndex:indexPath.row]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMM d, yyyy h:mm a"];
    
    amount.text = [Helpers formatCurrency:self.goal.currency forAmount:contribution.amount];
    date.text = [formatter stringFromDate:contribution.contributionDate].uppercaseString;
    date.font = [UIFont systemFontOfSize:10];
    date.textColor = [UIColor grayColor];
    
    cell.backgroundColor = [self cellBackgroundForAmount:contribution.amount];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoalContribution *contribution = [[self.goal getContributions] objectAtIndex:[self reversedIndex:indexPath.row]];
    
    self.previousSelection = [self reversedIndex:indexPath.row];
    [self presentGoalContributeNormalForGoalContribution:contribution];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}



@end

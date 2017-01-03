//
//  GoalsViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 02/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "GoalsViewController.h"
#import "CreateGoalViewController.h"
#import "Helpers.h"

@interface GoalsViewController ()

@end

@implementation GoalsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.createGoal.target = self;
    self.createGoal.action = @selector(presentCreateGoalViewController);
}

#pragma mark private

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

@end

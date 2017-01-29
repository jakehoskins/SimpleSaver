//
//  SteppedNavigationViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 22/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <JKSteppedProgressBar/JKSteppedProgressBar-Swift.h>

#import "SteppedNavigationViewController.h"
#import "SteppedControlPannelView.h"
#import "StepBaseViewController.h"
#import "StepTwoViewController.h"
#import "StepThreeViewController.h"
#import "StepFourViewController.h"
#import "StepFiveViewController.h"
#import "Colours.h"
#import "Constants.h"
#import "SavingsModel.h"

@interface SteppedNavigationViewController () 
@property (nonatomic, strong) SteppedProgressBar *steppedProgress;
@property (nonatomic, strong) NSArray<NSString *> *stepTitles;
@end

@implementation SteppedNavigationViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController isEditing:(BOOL)edit
{
    self = [super initWithRootViewController:rootViewController];
    
    if (self)
    {
        self.isEditing = edit;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect progressFrame = CGRectMake(0, 10, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
    
    self.stepTitles = [NSArray arrayWithObjects:@"Step 1",@"Step 2", @"Step 3",@"Step 4",@"Done", nil];
    self.steppedProgress = [[SteppedProgressBar alloc] initWithFrame:progressFrame];
    self.steppedProgress.circleSpacing = 45.0f;
    self.steppedProgress.backgroundColor = [UIColor clearColor];
    self.steppedProgress.titles = self.stepTitles;
    self.steppedProgress.currentTab = 1;
    self.steppedProgress.activeColor = [UIColor seafoamColor];
    self.steppedProgress.inactiveColor = [UIColor salmonColor];
    [self.view addSubview:self.steppedProgress];
}

-(void) incrementProgressStep
{
    if (self.steppedProgress.currentTab < self.stepTitles.count)
    {
        self.steppedProgress.currentTab++;
    }
}

-(void) decrementProgressStep
{
    if (self.steppedProgress.currentTab > 1)
    {
        self.steppedProgress.currentTab--;
    }
}

-(void) back
{
    [self decrementProgressStep];
    [self popViewControllerAnimated:false];
}

-(void) next
{
    StepBaseViewController *nextViewController = (StepBaseViewController *) [self getNextViewController];
    
    // Cast the pointer to our base class, ( can still invoke validate respectively )
    StepBaseViewController *currentViewController = (StepBaseViewController *) [self visibleViewController];
    ValidationResult *validationResult = [currentViewController validate];
    
    if (nextViewController && [validationResult getCode] == CODE_OK)
    {
        [self addToGoalSteps:currentViewController.stepItems];
        [self pushViewController:nextViewController animated:false];
        [self incrementProgressStep];
    }
    else if ([validationResult getCode] != CODE_OK)
    {
        [currentViewController presentErrorDialogForValidationResult:validationResult];
    }
    else if(!nextViewController)
    {
        [self complete];
    }
}

-(void) complete
{
    // All Steps have finished create the goal and dismiss the view controller
    Goal *goal = [[Goal alloc] initWithDictionary:self.goalItems];
    
    if (!self.isEditing)
    {
        [[SavingsModel getInstance] addGoal:goal];
    }
    else
    {
        // Have to transfer goal contributions
        NSDictionary* edit = [self dictionaryForEdit];
        
        if ([edit objectForKey:kContributions])
        {
            [goal setContributons:[edit objectForKey:kContributions]];
        }
        
        [[SavingsModel getInstance] editGoalAtIndex:self.goalIndex forGoal:goal];
    }
    
    [[SavingsModel getInstance] writeToUserDefaults];
    
    [self dismissViewControllerAnimated:true completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GOAL_UPDATE object:self];
    }];

}

-(UIViewController *) getNextViewController
{
    StepBaseViewController *viewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    switch (self.steppedProgress.currentTab)
    {
        case 0:
            break;
        case 1:
            viewController = (StepTwoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"StepTwoViewController"];
            break;
        case 2:
            viewController = (StepThreeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"StepThreeViewController"];
            break;
        case 3:
            viewController = (StepFourViewController *)[storyboard instantiateViewControllerWithIdentifier:@"StepFourViewController"];
            break;
        case 4:
            viewController = (StepFiveViewController *)[storyboard instantiateViewControllerWithIdentifier:@"StepFiveViewController"];
            break;
        default:
            viewController = nil;
            break;
    }
    
    if (viewController)
    {
        viewController.delegate = self;
    }
    
    return viewController;
}

-(void) addToGoalSteps:(NSMutableDictionary *)stepItems
{
    if(!self.goalItems)
    {
        self.goalItems = [NSMutableDictionary dictionary];
    }
    
    for (NSString *key in stepItems)
    {
        [self.goalItems setObject:[stepItems objectForKey:key] forKey:key];
    }
}
-(void) leftButtonClicked
{
    [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

-(void) middleButtonClicked
{
    [self back];
}


-(void) rightButtonClicked
{
    [self next];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

#pragma EditProtocol
-(NSDictionary *) dictionaryForEdit
{
    if (!self.isEditing) return nil;
    
    return self.goalItems;
}
@end

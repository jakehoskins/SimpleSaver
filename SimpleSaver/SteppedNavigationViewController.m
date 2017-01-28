//
//  SteppedNavigationViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 22/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "SteppedNavigationViewController.h"
#import <JKSteppedProgressBar/JKSteppedProgressBar-Swift.h>
#import "SteppedControlPannelView.h"
#import "StepBaseViewController.h"
#import "StepTwoViewController.h"
#import "StepThreeViewController.h"
#import "Colours.h"

@interface SteppedNavigationViewController () 
@property (nonatomic, strong) SteppedProgressBar *steppedProgress;
@property (nonatomic, strong) NSArray<NSString *> *stepTitles;
@end

@implementation SteppedNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect progressFrame = CGRectMake(0, 10, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
    
    self.stepTitles = [NSArray arrayWithObjects:@"Step 1",@"Step 2", @"Step 3",@"Step 4", @"Step 5", nil];
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
        NSLog(@"%s", __PRETTY_FUNCTION__);
    }
}

-(UIViewController *) getNextViewController
{
    UIViewController *viewController;
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
            break;
        default:
            viewController = nil;
            break;
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

@end

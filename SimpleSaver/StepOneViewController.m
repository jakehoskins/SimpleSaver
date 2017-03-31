//
//  StepOneViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 22/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

// Controllers
#import "StepOneViewController.h"
#import "GoalIconTableViewController.h"

// Util
#import "Colours.h"
#import "Helpers.h"


@interface StepOneViewController () <GoalIconTableViewDelegate>
@property (nonatomic, strong) NSString *goalName;
@property (nonatomic, strong) NSString *imageUrl;
@end

@implementation StepOneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageUrl = [Constants getDefaultGoalIcon];
    [self.btnAvatar addTarget:self action:@selector(presentGoalAvatarSelector) forControlEvents:UIControlEventTouchUpInside];
    [self setUpGoalIconForImage:[UIImage imageNamed:self.imageUrl]];
    
    if (self.delegate)
    {
        [self loadEditItems:[self.delegate dictionaryForEdit]];
    }
    self.lblInfo.textColor = [Skin defaultTextColour];
}

-(void) loadEditItems:(NSDictionary *)dictionary
{
    if (!dictionary) return;
    
    if ([dictionary objectForKey:kGoalName])
    {
        self.tfGoalName.text = [dictionary objectForKey:kGoalName];
    }
    
    if ([dictionary objectForKey:kIconUrl])
    {
        self.imageUrl = [dictionary objectForKey:kIconUrl];
        [self setUpGoalIconForImage:[UIImage imageNamed:self.imageUrl]];
    }
}

-(void) setUpGoalIconForImage:(UIImage *)image
{
    self.goalIcon.image = [Helpers goalIconForImage:image];
    self.goalIcon.borderColor = [UIColor goldColor];
    self.goalIcon.borderWidth = @(4.0f);
    self.goalIcon.backgroundColor = [UIColor colorWithPatternImage:[Skin backgroundImageForMaster]];
}


-(void) presentGoalAvatarSelector
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GoalIconTableViewController *vc = (GoalIconTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GoalIconTableViewController"];
    vc.delegate = self;
    
    [self presentViewController:vc];
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
        [popOverController setPopoverContentSize:CGSizeMake(MAX_POPOVER_WIDTH, MAX_POPOVER_HEIGHT)];
        [popOverController presentPopoverFromRect:self.pannel.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
    }
}

// Override to validate within our step
-(ValidationResult *) validate
{
    // Set any ui objects to our properties
    self.goalName = self.tfGoalName.text;
    
    ValidationResult *result;
    
    if (self.goalName.length <= 0)
    {
        result = [[ValidationResult alloc] initWithValidationCode:CODE_EMPTY_FIELD];
    }
    else
    {
        result = [[ValidationResult alloc] initWithValidationCode:CODE_OK];
    }
    
    [self.stepItems setObject:self.goalName forKey:kGoalName];
    [self.stepItems setObject:self.imageUrl forKey:kIconUrl];
    
    return result;
}

#pragma mark GoalIconViewDelegate

- (void) imageSelectedWithURL:(NSString *)url
{
    self.imageUrl = url;
    self.goalIcon.image = [UIImage imageNamed:url];
}

@end

//
//  StepOneViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 22/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "StepOneViewController.h"

// Util
#import "Colours.h"

// remove
#import "SavingsModel.h"
#import "Constants.h"

@interface StepOneViewController ()

@end

@implementation StepOneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.btnAvatar addTarget:self action:@selector(presentGoalAvatarSelector) forControlEvents:UIControlEventTouchUpInside];
    [self setUpGoalIconForImage:[UIImage imageNamed:@"car"]];

}

-(void) setUpGoalIconForImage:(UIImage *)image
{
    self.goalIcon.borderColor = [UIColor goldColor];
    self.goalIcon.borderWidth = @(4.0f);
    [self.goalIcon setImage:image];
    self.goalIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
}

-(void) presentGoalAvatarSelector
{
    
}

// Override to validate within our step
-(ValidationResult *) validate
{
    NSInteger code = (self.preValidatedDictionry.count == 1) ? CODE_OK : CODE_EMPTY_FIELD;
    
    return [[ValidationResult alloc] initWithValidationCode:code];
}

@end

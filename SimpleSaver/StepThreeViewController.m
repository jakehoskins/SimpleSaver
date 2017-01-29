//
//  StepThreeViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 28/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "StepThreeViewController.h"

@interface StepThreeViewController ()
@property (nonatomic, strong) NSNumber *initialContribution;
@end

@implementation StepThreeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(ValidationResult *)validate
{
    if (self.tfInitialContribution.text.length > 0 && ![Helpers containsOnlyNumericals:self.tfInitialContribution.text])
    {
        return [[ValidationResult alloc] initWithValidationCode:CODE_NON_NUMERIC];
    }
    
    self.initialContribution = (self.tfInitialContribution.text.length > 0) ? @(self.tfInitialContribution.text.doubleValue) : @(0.00);
    
    [self.stepItems setObject:self.initialContribution forKey:kInitialContribution];
    
    return [[ValidationResult alloc] initWithValidationCode:CODE_OK];
}

@end


//
//  StepFiveViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 29/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "StepFiveViewController.h"

@interface StepFiveViewController ()

@end

@implementation StepFiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.ivSuccess.layer setShadowOffset:CGSizeMake(10, 10)];
    [self.ivSuccess.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.ivSuccess.layer setShadowOpacity:0.5];
}

// Subclasses can override these
-(NSString *) textForRightButton
{
    return @"Done";
}

-(ValidationResult *) validate
{
    return [[ValidationResult alloc] initWithValidationCode:CODE_OK];
}

@end

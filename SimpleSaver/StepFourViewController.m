//
//  StepFourViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 29/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "StepFourViewController.h"

@interface StepFourViewController ()
@property (nonatomic, strong) NSDate *deadlineDate;
@end

@implementation StepFourViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dfDeadline.minimumDate = [Helpers addDaysToDate:[NSDate date] increaseBy:1];
    [self.swNoDeadline addTarget:self action:@selector(toggleDeadlineEnabled:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.delegate)
    {
        [self loadEditItems:[self.delegate dictionaryForEdit]];
    }
    
}

-(void) loadEditItems:(NSDictionary *)dictionary
{
    if (!dictionary) return;
    
    if ([dictionary objectForKey:kSavingsTarget])
    {
        self.deadlineDate = [dictionary objectForKey:kDeadlineDate];
        self.dfDeadline.date = self.deadlineDate;
    }
    else
    {
        [self.swNoDeadline setOn:true];
        [self.dfDeadline setEnabled:false];
    }
}

-(void) toggleDeadlineEnabled:(id) sender
{
    self.dfDeadline.enabled = !((UISwitch *)sender).isOn;
}

-(ValidationResult *) validate
{
    
    if (!self.swNoDeadline.isOn)
    {
        self.deadlineDate = self.dfDeadline.date;
        [self.stepItems setObject:self.deadlineDate forKey:kDeadlineDate];
        
        // NOTE WHEN IN EDIT MODE WE DON'T ACTUALLY WANT TO SET THIS PROPERTY I.E KEEP AS IS!
        [self.stepItems setObject:[NSDate date] forKey:kStartDate];
    }
    return [[ValidationResult alloc] initWithValidationCode:CODE_OK];
}

@end

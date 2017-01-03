//
//  ViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 01/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <OpinionzAlertView/OpinionzAlertView.h>

#import "CreateGoalViewController.h"
#import "SavingsModel.h"
#import "Goal.h"

#import "Helpers.h"
#import "ValidationResult.h"

int const MAX_CURRENCY_LENGTH = 2;
int const SC_START_DATE_INDEX = 0;
int const SC_END_DATE_INDEX = 1;
@interface CreateGoalViewController () <UITextFieldDelegate>
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) Goal *goal;
@end

@implementation CreateGoalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tfCurrency setDelegate:self];
    [self.btnCreateGoal setEnabled:true];
    [self.dpDateSelector addTarget:self action:@selector(handleNewDateSelected) forControlEvents:UIControlEventValueChanged];
    [self.scDateContext addTarget:self action:@selector(handleSegmentedChange) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissViewController)];
    self.navigationItem.leftBarButtonItem = closeButton;
    self.state = CreateState;
}


-(void)viewDidAppear:(BOOL)animated
{
    [self setupForState:(self.state) ? self.state : CreateState];
}


-(void) setGoal:(Goal *)goal
{
    self.goal = goal;
    self.state = EditState;
    [self setupForState:self.state];
}

#pragma Private Methods


-(void) dismissViewController
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) setupForState:(State)state
{
    switch (state) {
        case CreateState:
            [self.btnCreateGoal setTitle:@"Create" forState:UIControlStateNormal];
            [self.btnCreateGoal addTarget:self action:@selector(createNewGoal) forControlEvents:UIControlEventTouchUpInside];
            [self.dpDateSelector setMinimumDate:[NSDate date]];
            break;
        case EditState:
            [self.tfGoalTarget setText:[NSString stringWithFormat:@"%2.f", [self.goal getSavingsTarget].doubleValue]];
            [self.tfGoalName setText:[self.goal getName]];
            self.startDate = [self.goal getStartDate];
            self.endDate = [self.goal getEndDate];
            [self.btnCreateGoal setTitle:@"Save" forState:UIControlStateNormal];
            [self.btnCreateGoal addTarget:self action:@selector(editGoal) forControlEvents:UIControlEventTouchUpInside];
            [self resetDatePicker];
            break;
        default:
            break;
    }
}

-(void) resetDatePicker
{
    switch (self.scDateContext.selectedSegmentIndex)
    {
        case SC_START_DATE_INDEX:
            if(self.startDate)
            {
                [self.dpDateSelector setDate:self.startDate animated:true];
            }
            break;
        case SC_END_DATE_INDEX:
            if (self.endDate)
            {
                [self.dpDateSelector setDate:self.endDate animated:true];
            }
            break;
        default:
            break;
    }
}

-(void) handleSegmentedChange
{
    switch (self.scDateContext.selectedSegmentIndex)
    {
        case SC_START_DATE_INDEX:
            [self.dpDateSelector setEnabled:(self.state == CreateState)];
            break;
        case SC_END_DATE_INDEX:
            break;
        default:
            break;
    }
}

-(void) handleNewDateSelected
{
    switch (self.scDateContext.selectedSegmentIndex)
    {
        case SC_START_DATE_INDEX:
            self.startDate = (self.state == CreateState) ? [self.dpDateSelector date] : nil;
            break;
        case SC_END_DATE_INDEX:
            self.endDate = (self.swCreateDeadline.on) ? [self.dpDateSelector date] : nil;
            break;
        default:
            break;
    }
}

-(void) editGoal
{
    if (!self.goal) return;
    ValidationResult *result = [self isValid];
    
    if ([result getCode] == CODE_OK)
    {
        SavingsModel *model = [SavingsModel getInstance];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        
        Goal *newGoal = [[Goal alloc] initWithName:self.tfGoalName.text savingsTarget:[numberFormatter numberFromString:self.tfGoalTarget.text] forStartDate:self.startDate andEndDate:self.endDate];
        
        [model editGoalAtIndex:[model indexForGoal:self.goal] forGoal:newGoal];
    }
    else
    {
        [self showErrorWithMessage:[result description]];
    }
}

- (void) createNewGoal
{
    ValidationResult *result = [self isValid];
    
    if ([result getCode] == CODE_OK)
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        
        self.goal = [[Goal alloc] initWithName:self.tfGoalName.text savingsTarget:[numberFormatter numberFromString:self.tfGoalTarget.text] forStartDate:self.startDate andEndDate:self.endDate];
        
        [[SavingsModel getInstance] addGoal:self.goal];
        [[SavingsModel getInstance] writeToUserDefaults];
    }
    else
    {
        [self showErrorWithMessage:[result description]];
    }
}

-(void) showErrorWithMessage:(NSString *)message
{
    OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:@"Error"
                                                                message:message
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
    alert.iconType = OpinionzAlertIconWarning;
    [alert show];
}

-(ValidationResult *) isValid
{
    
    if (self.tfGoalName.text.length == 0) return [[ValidationResult alloc] initWithValidationCode:CODE_EMPTY_FIELD];
    if (self.tfGoalTarget.text.length == 0) return [[ValidationResult alloc] initWithValidationCode:CODE_EMPTY_FIELD];
    if (self.tfCurrency.text.length == 0) return [[ValidationResult alloc] initWithValidationCode:CODE_EMPTY_FIELD];
    
    if (![Helpers containsOnlyNumericals:self.tfGoalTarget.text]) return [[ValidationResult alloc] initWithValidationCode:CODE_NON_NUMERIC];
    if ([Helpers containsOnlyNumericals:self.tfGoalName.text]) return [[ValidationResult alloc] initWithValidationCode:CODE_NEEDS_STRING];
    if ([Helpers containsOnlyNumericals:self.tfCurrency.text]) return [[ValidationResult alloc] initWithValidationCode:CODE_NEEDS_STRING];
    
    
    if (self.swCreateDeadline.on && self.startDate == self.endDate) return [[ValidationResult alloc] initWithValidationCode:CODE_BAD_DEADLINE];
    
    return [[ValidationResult alloc] initWithValidationCode:CODE_OK];
}

#pragma UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (![textField isEqual:self.tfCurrency]) return true;
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength < MAX_CURRENCY_LENGTH;
}

@end

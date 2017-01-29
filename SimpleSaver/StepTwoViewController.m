//
//  StepTwoViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 22/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "StepTwoViewController.h"

@interface StepTwoViewController () <UITextFieldDelegate>
@property (nonatomic, strong) NSNumber *targetAmount;
@property (nonatomic, strong) NSString *currency;
@end

@implementation StepTwoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.swNoTarget addTarget:self action:@selector(toggleTargetEnabled:) forControlEvents:UIControlEventValueChanged];
    self.tfCurrency.delegate = self;
    
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
        self.targetAmount = [dictionary objectForKey:kSavingsTarget];
        self.tfTarget.text = [NSString stringWithFormat:@"%.2f",self.targetAmount.doubleValue];
    }
    else
    {
        [self.swNoTarget setOn:true];
        self.tfTarget.enabled = false;
    }
    
    if ([dictionary objectForKey:kCurrency])
    {
        self.currency = [dictionary objectForKey:kCurrency];
        self.tfCurrency.text = self.currency;
    }
}

-(void) toggleTargetEnabled:(id)sender
{
    self.tfTarget.enabled = !((UISwitch *)sender).isOn;
}

// Override to validate within our step
-(ValidationResult *) validate
{
    if (self.tfCurrency.text.length == 0 || (self.tfTarget.text.length == 0 && !self.swNoTarget.isOn))
    {
        return [[ValidationResult alloc] initWithValidationCode:CODE_EMPTY_FIELD];
    }
    
    if (![Helpers containsOnlyNumericals:self.tfTarget.text] && self.swNoTarget.isOn == false)
    {
        return [[ValidationResult alloc] initWithValidationCode:CODE_NON_NUMERIC];
    }
    
    // Set any ui objects to our properties
    self.currency =self.tfCurrency.text;
    
    if (!self.swNoTarget.isOn)
    {
        self.targetAmount = @([self.tfTarget.text doubleValue]);
        [self.stepItems setObject:self.targetAmount forKey:kSavingsTarget];
    }
    
    [self.stepItems setObject:self.currency forKey:kCurrency];
    
    return [[ValidationResult alloc] initWithValidationCode:CODE_OK];
}

#pragma mark UITextFieldDelegate
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField != self.tfCurrency) return true;
    
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 1;
}

@end

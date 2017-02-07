//
//  GoalContributionViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 15/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//
#import <OpinionzAlertView/OpinionzAlertView.h>

#import "GoalContributionViewController.h"
#import "Colours.h"
#import "GoalContribution.h"
#import "AmountView.h"
#import "Helpers.h"

@interface GoalContributionViewController () <AmountViewDatasource>

@end

@implementation GoalContributionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [self updateUi];
    [self.av setShadowColour:[self themeColour]];
    self.currency = (self.currency) ? self.currency : [Helpers defaultCurrency];
    [self.av setCurrency:self.currency];
    self.av.delegate = self;
    [self.av reload];
    self.tv.layer.borderColor = [self themeColour].CGColor;
    self.tv.layer.borderWidth = 3.0f;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail-background"]];
    [self.btnContribute addTarget:self action:@selector(confirmContribution) forControlEvents:UIControlEventTouchUpInside];
    [self.btnContribute setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (self.type == ContributionTypeNormal)
    {
        [self.av.tfAmount setText:[Helpers formatCurrency:self.currency forAmount:self.contribution.amount]];
        [self.av.tfAmount setEnabled:false];
        [self.tv setText:self.contribution.notes];
        [self.tv setEditable:false];
    }
    else if(self.type == ContributionTypeCreateAmmendContribution)
    {
        [self.av.tfAmount setText:[Helpers formatCurrency:self.currency forAmount:self.contribution.amount]];
        [self.tv setText:self.contribution.notes];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void) confirmContribution
{
    NSNumber *amount = [self.av getAmount];
    
    if (self.delegate && amount.doubleValue != 0)
    {
        switch (self.type)
        {
            case ContributionTypeCreateAddFunds:
                [self.delegate contributionWasMade:self.type forAmount:amount andNotes:self.tv.text];
                break;
            case ContributionTypeCreateRemoveFunds:
                [self.delegate contributionWasMade:self.type forAmount:amount andNotes:self.tv.text];
                break;
            case ContributionTypeCreateAmmendContribution:
                [self.delegate ammendmentWasMade:self.ammendmentType forAmount:amount andNotes:self.tv.text];
            default:
                break;
        }
    }
    else
    {
        [self showErrorWithMessage:@"Cannot make an empty contribution"];
    }
}


-(UIColor *) themeColour
{
    switch (self.type)
    {
        case ContributionTypeCreateAddFunds:
            return [UIColor seafoamColor];
            break;
        case ContributionTypeCreateRemoveFunds:
            return [UIColor salmonColor];
            break;
        case ContributionTypeCreateAmmendContribution:
            return [UIColor cornflowerColor];
            break;
        case ContributionTypeNormal:
            return [UIColor goldColor];
        default:
            break;
    }
    
    return [UIColor blackColor];
}

-(void) updateTitle
{
    switch (self.type)
    {
        case ContributionTypeCreateAddFunds:
            self.title = @"Add Funds";
            break;
        case ContributionTypeCreateRemoveFunds:
            self.title = @"Remove Funds";
            break;
        case ContributionTypeCreateAmmendContribution:
            self.title = @"Ammend Funds";
            break;
        case ContributionTypeNormal:
            self.title = @"Contribution";
            break;
        default:
            break;
    }
}

-(void) updateUi
{
    switch (self.type)
    {
        case ContributionTypeCreateAddFunds:
            [self updateTitle];
            [self.btnContribute setTitle:@"Add Funds" forState:UIControlStateNormal];
            break;
        case ContributionTypeCreateRemoveFunds:
            [self updateTitle];
            [self.btnContribute setTitle:@"Remove Funds" forState:UIControlStateNormal];
            break;
        case ContributionTypeCreateAmmendContribution:
            [self updateTitle];
            [self.btnContribute setTitle:@"Ammend" forState:UIControlStateNormal];
            break;
        case ContributionTypeNormal:
            [self updateTitle];
            [self.btnContribute setHidden:true];
            break;
        default:
            break;
    }
    
    [self.btnContribute setBackgroundColor:[self themeColour]];
}

-(void) dismissKeyboard
{
    if ([self.av.tfAmount isFirstResponder])
    {
        [self.av.tfAmount resignFirstResponder];
    } else if ([self.tv isFirstResponder])
    {
        [self.tv resignFirstResponder];
    }
}
-(void) setType:(ContributionType)type
{
    _type = type;
    
    [self setAmmendmentType];
}
// Must set contribution before.
-(void) setAmmendmentType
{
    if (!self.contribution)
    {
        self.ammendmentType = AmmendmentTypeNone;
        return;
    }
    
    if (self.contribution.amount.doubleValue < 0)
    {
        self.ammendmentType = AmmendmentTypeNegative;
    }
    else
    {
        self.ammendmentType = AmmendmentTypePositive;
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

#pragma mark AmountViewDatasource

- (NSDate *) dateForFieldContribution
{
    NSDate *date;
    
    if (self.contribution)
    {
        date = [self.contribution contributionDate];
    }
    else
    {
        date = [NSDate date];
    }
    
    return date;
}

@end

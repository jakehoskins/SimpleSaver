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
@interface GoalContributionViewController () <AmountViewDatasource>

@end

@implementation GoalContributionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [self updateUi];
    [self.av setShadowColour:[self shadowColour]];
    [self.av setCurrency:@"#"];
    self.av.delegate = self;
    [self.av reload];
    self.tv.layer.borderColor = [UIColor blackColor].CGColor;
    self.tv.layer.borderWidth = 3.0f;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail-background"]];
    [self.btnContribute addTarget:self action:@selector(confirmContribution) forControlEvents:UIControlEventTouchUpInside];
    [self.btnContribute setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void) confirmContribution
{
    NSNumber *amount = [self.av getAmount];
    
    // Need to also check non zero values
    if (self.delegate && amount.doubleValue != 0)
    {
        [self.delegate contributionWasMade:self.type forAmount:amount andNotes:self.tv.text];
    }
    else
    {
        [self showErrorWithMessage:@"Cannot make an empty contribution"];
    }
}


-(UIColor *) shadowColour
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
            [self.btnContribute setBackgroundColor:[UIColor cornflowerColor]];
            break;
        case ContributionTypeNormal:
            break;
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
            [self.btnContribute setBackgroundColor:[UIColor seafoamColor]];
            break;
        case ContributionTypeCreateRemoveFunds:
            [self updateTitle];
            [self.btnContribute setTitle:@"Remove Funds" forState:UIControlStateNormal];
            [self.btnContribute setBackgroundColor:[UIColor salmonColor]];
            break;
        case ContributionTypeCreateAmmendContribution:
            [self updateTitle];
            [self.btnContribute setTitle:@"Ammend" forState:UIControlStateNormal];
            [self.btnContribute setBackgroundColor:[UIColor cornflowerColor]];
            break;
        case ContributionTypeNormal:
            [self updateTitle];
            break;
        default:
            break;
    }
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

//
//  StepBaseViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 22/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

// Controllers
#import "StepBaseViewController.h"
#import "SteppedNavigationViewController.h"

// View
#import "SteppedControlPannelView.h"
@interface StepBaseViewController ()

@end

// For subviews to access IBOutlets connect them through the files owner ;)
@implementation StepBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    SteppedNavigationViewController *navigation = [self getNavigationController];
    
    if (navigation)
    {
        // Let the navigation controller handle switching vc's
        self.pannel.delegate = navigation;
    }

    // Subcclasses can override the defaults
    self.pannel.datasource = self;
    [self.pannel reloadDatasource];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail-background"]];
    
    self.navigationItem.hidesBackButton = true;
}

-(SteppedNavigationViewController *) getNavigationController
{
    if (self.navigationController)
    {
        return (SteppedNavigationViewController *) self.navigationController;
    }
    
    return nil;
}

-(void) presentErrorDialogForValidationResult:(ValidationResult *)validationResult
{
    OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:@"Error"
                                                                message:[validationResult description]
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
    alert.iconType = OpinionzAlertIconWarning;
    [alert show];
}

// Subclasses are expected to overide this.
-(ValidationResult *) validate
{
    NSInteger code = (self.preValidatedDictionry.count > 0) ? CODE_OK : CODE_EMPTY_FIELD;
    
    return [[ValidationResult alloc] initWithValidationCode:code];
}

// Subclasses can override these
-(NSString *) textforLeftButton
{
    return @"Cancel";
}
// Subclasses can override these
-(NSString *) textforMiddleButton
{
    return @"Back";
}
// Subclasses can override these
-(NSString *) textForRightButton
{
    return @"Next";
}
@end

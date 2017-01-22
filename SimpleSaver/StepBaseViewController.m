//
//  StepBaseViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 22/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "StepBaseViewController.h"
#import "SteppedControlPannelView.h"
#import "SteppedNavigationViewController.h"

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

// Subclasses can override these
-(NSString *) textforLeftButton
{
    return @"close";
}
// Subclasses can override these
-(NSString *) textforMiddleButton
{
    return @"back";
}
// Subclasses can override these
-(NSString *) textForRightButton
{
    return @"next";
}
@end

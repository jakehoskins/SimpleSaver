//
//  SimpleSaverSplitViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 03/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "SimpleSaverSplitViewController.h"

#import "Helpers.h"

@interface SimpleSaverSplitViewController ()

@end

@implementation SimpleSaverSplitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    
    if ([Helpers isIpad])
    {
        self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    }
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
collapseSecondaryViewController:(UIViewController *)secondaryViewController
  ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    return YES;
}

@end

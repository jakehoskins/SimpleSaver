//
//  DefaultSettingsViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 20/03/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "DefaultSettingsViewController.h"
#import "Constants.h"
#import "UserSettings.h"
#import "Skin.h"

@implementation DefaultSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[Skin backgroundImageForDetail]];
    UIBarButtonItem *btnClose = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(dismissViewController)];
    self.navigationItem.rightBarButtonItem = btnClose;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.showCreditsFooter = NO;
}

- (void) dismissViewController
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController *)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // @ todo change to hasPurchasedDarkSkin
    return ([Constants hasPurchasedUnlimitedGoals] || [UserSettings isUsingDebugSettings])
    ?  [super tableView:tableView numberOfRowsInSection:section]
    : [super tableView:tableView numberOfRowsInSection:section] - 1;
}

@end

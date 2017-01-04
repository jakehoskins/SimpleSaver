//
//  GoalsViewController.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 02/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoalsViewController : UIViewController

typedef NS_ENUM(NSInteger, ProgressIndicator)
{
    ProgressContributedVsTotal,
    ProgressDaysVsDaysRemaining
};

@property (nonatomic, strong) UIColor *backgroundColour;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createGoal;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

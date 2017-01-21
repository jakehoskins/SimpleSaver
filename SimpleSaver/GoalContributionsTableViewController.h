//
//  GoalContributionsTableViewController.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 21/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Goal;

@interface GoalContributionsTableViewController : UITableViewController
@property (nonatomic, strong) Goal *goal;
@property NSInteger previousSelection;
@end

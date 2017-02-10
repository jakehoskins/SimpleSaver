//
//  GoalsViewController.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 02/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Goal;

@protocol GoalSelection <NSObject>
@required
- (void) goalSelected:(Goal *)goal;
@end


@interface GoalsViewController : UIViewController

typedef NS_ENUM(NSInteger, ProgressIndicator)
{
    ProgressContributedVsTotal,
    ProgressDaysVsDaysRemaining
};

@property (nonatomic, strong) UIColor *backgroundColour;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createGoal;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnInAppPurchase;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak, readwrite) id <GoalSelection> delegate;
@end

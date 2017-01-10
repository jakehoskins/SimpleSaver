//
//  GoalDetailViewController.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 03/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoalContributedView;

@interface GoalDetailViewController : UIViewController

typedef NS_ENUM(NSInteger, GoalContributedViewTouchState)
{
    TotalContribution,
    TotalRemaining
};

@property (weak, nonatomic) IBOutlet GoalContributedView *gcv;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFunds;
@property (weak, nonatomic) IBOutlet UIButton *btnRemoveFunds;
@property (weak, nonatomic) IBOutlet UIButton *btnViewContributions;

@end

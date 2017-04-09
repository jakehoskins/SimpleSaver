//
//  GoalDetailViewController.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 03/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoalContributedView;
@class SteppedControlPannelView;

@interface GoalDetailViewController : UIViewController

typedef NS_ENUM(NSInteger, GoalContributedViewTouchState)
{
    TotalContribution,
    TotalRemaining,
    TotalContributions,
    TotalMonthlyAverageNeeded
};

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet GoalContributedView *gcv;
@property (weak, nonatomic) IBOutlet SteppedControlPannelView *controlPannel;

@end

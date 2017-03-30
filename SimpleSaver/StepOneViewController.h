//
//  StepOneViewController.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 22/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepBaseViewController.h"

// Views
#import "SteppedControlPannelView.h"
#import "NZCircularImageView.h"

@interface StepOneViewController : StepBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *tfGoalName;
@property (weak, nonatomic) IBOutlet NZCircularImageView *goalIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;

@end

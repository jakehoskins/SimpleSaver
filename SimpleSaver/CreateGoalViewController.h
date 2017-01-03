//
//  ViewController.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 01/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SavingsModel;
@class Goal;

@interface CreateGoalViewController : UIViewController

typedef NS_ENUM(NSInteger, State) {
    CreateState,
    EditState
};

-(void) setGoal:(Goal *)goal;   // For Editing //


@property (weak, nonatomic) IBOutlet UITextField *tfGoalName;
@property (weak, nonatomic) IBOutlet UITextField *tfGoalTarget;
@property (weak, nonatomic) IBOutlet UITextField *tfCurrency;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scDateContext;
@property (weak, nonatomic) IBOutlet UISwitch *swCreateDeadline;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpDateSelector;
@property (weak, nonatomic) IBOutlet UIButton *btnCreateGoal;
@property State state;
@end


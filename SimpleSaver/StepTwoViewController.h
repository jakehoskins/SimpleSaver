//
//  StepTwoViewController.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 22/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "StepBaseViewController.h"

@interface StepTwoViewController : StepBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *tfTarget;
@property (weak, nonatomic) IBOutlet UISwitch *swNoTarget;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@property (weak, nonatomic) IBOutlet UITextField *tfCurrency;
@end

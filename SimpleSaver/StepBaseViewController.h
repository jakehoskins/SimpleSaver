//
//  StepBaseViewController.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 22/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SteppedControlPannelView.h"

@interface StepBaseViewController : UIViewController <SteppedControlPannelDataSource> 

@property (weak, nonatomic) IBOutlet SteppedControlPannelView *pannel;
@end

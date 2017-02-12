//
//  StepBaseViewController.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 22/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpinionzAlertView/OpinionzAlertView.h>

#import "SteppedControlPannelView.h"
#import "ValidationResult.h"
#import "Goal.h"
#import "Colours.h"
#import "Helpers.h"
#import "EditProtocol.h"
#import "Skin.h"

@interface StepBaseViewController : UIViewController <SteppedControlPannelDataSource>
@property (weak, nonatomic) IBOutlet SteppedControlPannelView *pannel;
@property (nonatomic, strong) NSMutableDictionary *stepItems;
-(ValidationResult *) validate;
-(void) presentErrorDialogForValidationResult:(ValidationResult *)validationResult;
@property (nonatomic, weak, readwrite) id <EditProtocol> delegate;
@end

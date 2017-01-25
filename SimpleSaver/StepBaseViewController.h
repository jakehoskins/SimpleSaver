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

@interface StepBaseViewController : UIViewController <SteppedControlPannelDataSource>
@property (weak, nonatomic) IBOutlet SteppedControlPannelView *pannel;
@property (nonatomic, strong) NSMutableDictionary *preValidatedDictionry;
@property (nonatomic, strong) NSDictionary *aggregatedValidatedDictionary;
-(ValidationResult *) validate;
-(void) presentErrorDialogForValidationResult:(ValidationResult *)validationResult;
@end

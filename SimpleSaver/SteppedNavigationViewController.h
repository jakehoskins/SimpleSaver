//
//  SteppedNavigationViewController.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 22/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SteppedControlPannelView.h"
#import "Goal.h"
#import "EditProtocol.h"

// This class controls the navigation between stepped classeds. It must therefore implement the pannels delegate.
@interface SteppedNavigationViewController : UINavigationController <SteppedControlPannelEvent, EditProtocol>

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController isEditing:(BOOL)edit;

@property (nonatomic, strong) NSMutableDictionary *goalItems;
@property BOOL isEditing;
@property NSInteger goalIndex;                                                      // used for editing only //
@end

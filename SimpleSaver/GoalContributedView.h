//
//  GoalContributedView.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 10/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"

@protocol GoalContributedViewEvent <NSObject>
@required
- (NSString *) textForParent:(id)sender;
- (NSString *) textForBottomChild:(id)sender;
- (NSString *) textForTopChild:(id)sender;
- (NSString *) textForParentInfo:(id)sender;
@optional
- (void) didCallDelegates:(id) sender;
@end


@interface GoalContributedView : UIView

-(void) reload;
@property (weak, nonatomic) IBOutlet UILabel *lblParentInfo;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *lblParent;
@property (weak, nonatomic) IBOutlet UILabel *lblTopChild;
@property (weak, nonatomic) IBOutlet UILabel *lblBottomChild;
@property (nonatomic, weak, readwrite) id <GoalContributedViewEvent> delegate;
@end

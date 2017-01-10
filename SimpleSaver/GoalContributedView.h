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
- (NSString *) textForChild:(id)sender;
@optional
-(void) userDidTouchView:(id)sender;
@end


@interface GoalContributedView : UIView

-(void) reload;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *lblParent;
@property (weak, nonatomic) IBOutlet UILabel *lblChild;
@property (nonatomic, weak, readwrite) id <GoalContributedViewEvent> delegate;
@end

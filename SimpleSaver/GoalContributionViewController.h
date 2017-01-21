//
//  GoalContributionViewController.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 15/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Goal;
@class GoalContribution;
@class AmountView;

typedef NS_ENUM(NSInteger, ContributionType) {
    ContributionTypeCreateAddFunds,
    ContributionTypeCreateRemoveFunds,
    ContributionTypeCreateAmmendContribution,
    ContributionTypeNormal
};
@protocol ContributionEvent <NSObject>
@required
- (void) contributionWasMade:(ContributionType)contributionType forAmount:(NSNumber *)amount andNotes:(NSString *)notes;
@end

@interface GoalContributionViewController : UIViewController

@property (nonatomic) ContributionType type;
@property (nonatomic, strong) GoalContribution *contribution;
@property (weak, nonatomic) IBOutlet UIButton *btnContribute;
@property (weak, nonatomic) IBOutlet AmountView *av;
@property (weak, nonatomic) IBOutlet UITextView *tv;
@property (nonatomic, weak, readwrite) id <ContributionEvent> delegate;
@end

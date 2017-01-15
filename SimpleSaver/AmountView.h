//
//  AmountView.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 15/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AmountViewDatasource <NSObject>
@required
- (NSDate *) dateForFieldContribution;
@end

@interface AmountView : UIView <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *tfAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property(nonatomic, strong) UIColor *shadowColour;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, weak, readwrite) id <AmountViewDatasource> delegate;

-(NSNumber *) getAmount;
-(void) reload;


@end

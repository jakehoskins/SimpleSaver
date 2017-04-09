//
//  SteppedControlPannel.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 22/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SteppedControlPannelEvent <NSObject>
@required
- (void) leftButtonClicked;
- (void) middleButtonClicked;
- (void) rightButtonClicked;
@end

@protocol SteppedControlPannelDataSource <NSObject>
@required
- (NSString *) textforLeftButton;
- (NSString *) textforMiddleButton;
- (NSString *) textForRightButton;
@optional
- (UIColor *) backgroundColourForLeftButton;
- (UIColor *) backgroundColourForMiddleButton;
- (UIColor *) backgroundColourForRightButton;
@end

@interface SteppedControlPannelView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *middleButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic, weak, readwrite) id <SteppedControlPannelEvent> delegate;
@property (nonatomic, weak, readwrite) id <SteppedControlPannelDataSource> datasource;

-(void) reloadDatasource;
@end

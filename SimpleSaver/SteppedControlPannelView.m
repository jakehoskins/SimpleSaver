//
//  SteppedControlPannel.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 22/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "SteppedControlPannelView.h"

@implementation SteppedControlPannelView

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"SteppedControlPannelView" owner:self options:nil];
    
    
    [self addSubview: self.contentView];
    
    self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
    self.contentView.layer.borderWidth = 3.0f;
    [self.contentView.layer setShadowOffset:CGSizeMake(5, 5)];
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.contentView.layer setShadowOpacity:0.5];
    
    [self.leftButton addTarget:self action:@selector(callLeftDelegate) forControlEvents:UIControlEventTouchUpInside];
    [self.middleButton addTarget:self action:@selector(callMiddleDelegate) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(callRightDelegate) forControlEvents:UIControlEventTouchUpInside];

}


-(void) callLeftDelegate
{
    if (self.delegate)
    {
        [self.delegate leftButtonClicked];
    }
}

-(void) callMiddleDelegate
{
    if (self.delegate)
    {
        [self.delegate middleButtonClicked];
    }
}

-(void) callRightDelegate
{
    if (self.delegate)
    {
        [self.delegate rightButtonClicked];
    }
}

-(void) reloadDatasource
{
    if (self.datasource)
    {
        NSString *left = [self.datasource textforLeftButton];
        NSString *middle = [self.datasource textforMiddleButton];
        NSString *right = [self.datasource textForRightButton];
        
        [self.leftButton setTitle:left forState:UIControlStateNormal];
        [self.middleButton setTitle:middle forState:UIControlStateNormal];
        [self.rightButton setTitle:right forState:UIControlStateNormal];
    }
}

-(void)layoutSubviews
{
    self.contentView.frame = self.bounds;
}

@end

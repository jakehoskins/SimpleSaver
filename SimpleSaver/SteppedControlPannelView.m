//
//  SteppedControlPannel.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 22/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "SteppedControlPannelView.h"

// Util
#import "Colours.h"
#import "Skin.h"
@implementation SteppedControlPannelView

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"SteppedControlPannelView" owner:self options:nil];
    
    
    [self addSubview: self.contentView];
    
    [self.contentView.layer setShadowOffset:CGSizeMake(-5, -5)];
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.contentView.layer setShadowOpacity:0.5];
    
    [self.leftButton addTarget:self action:@selector(callLeftDelegate) forControlEvents:UIControlEventTouchUpInside];
    [self.middleButton addTarget:self action:@selector(callMiddleDelegate) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(callRightDelegate) forControlEvents:UIControlEventTouchUpInside];
    
    self.leftButton.backgroundColor = [Skin defaultRedColour];
    self.middleButton.backgroundColor = [Skin defaultBlueColour];
    self.rightButton.backgroundColor = [Skin defaultGreenColour];
    
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.middleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
        
        if ([self.datasource respondsToSelector:@selector(backgroundColourForLeftButton)])
        {
            [self.leftButton setBackgroundColor:[self.datasource backgroundColourForLeftButton]];
        }
        if ([self.datasource respondsToSelector:@selector(backgroundColourForMiddleButton)])
        {
            [self.middleButton setBackgroundColor:[self.datasource backgroundColourForMiddleButton]];
        }
        if ([self.datasource respondsToSelector:@selector(backgroundColourForRightButton)])
        {
            [self.rightButton setBackgroundColor:[self.datasource backgroundColourForRightButton]];
        }
    }
}

-(void)layoutSubviews
{
    self.contentView.frame = self.bounds;
}

@end

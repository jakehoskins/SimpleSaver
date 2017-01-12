//
//  GoalContributedView.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 10/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "GoalContributedView.h"

@implementation GoalContributedView


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate)
    {
        [self reload];
    }
}
-(void) reload
{
    if (self.delegate)
    {
        self.lblParent.text = [self.delegate textForParent:self];
        self.lblChild.text = [self.delegate textForChild:self];
        [self.delegate didCallDelegates:self];
    }
}

-(void) setupBackground
{
    
    self.contentView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.contentView.layer.borderWidth = 3.0f;
    [self.contentView.layer setShadowOffset:CGSizeMake(5, 5)];
    [self.contentView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.contentView.layer setShadowOpacity:0.5];
}
-(void)layoutSubviews
{
    self.contentView.frame = self.bounds;
}

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"GoalContributedView" owner:self options:nil];
    

    [self addSubview: self.contentView];
    
    [self setupBackground];
}
@end

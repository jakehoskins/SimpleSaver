/*
 MIT License
 
 Copyright (c) 2017 Jake Hoskins
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
*/

#import "ChartMarker.h"

#define SIZE CGSizeMake(25, 25)
@interface ChartMarker()
@property (nonatomic, strong) NSString *markerText;
@property (nonatomic, strong) NSDictionary *textAttributes;
@end

@implementation ChartMarker

@synthesize offset;

#pragma mark ChartMarker

-(instancetype) init
{
    self = [super init];
    
    if (self)
    {
        self.textAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:12.0f]};
    }
    
    return self;
}

- (CGPoint)offsetForDrawingAtPoint:(CGPoint)atPoint
{
    return CGPointMake(-(SIZE.width + ([self size].width / 2)) / 2, -(SIZE.height - [self size].height));
}

-(CGSize)size
{
    CGSize textSize = [self.markerText sizeWithAttributes:self.textAttributes];
    
    return textSize;
}

- (void)refreshContentWithEntry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight
{
    self.markerText = [NSString stringWithFormat:@"   %.2f   ",entry.y];
}

- (void)drawWithContext:(CGContextRef _Nonnull)context point:(CGPoint)point
{
    CGPoint ooffset = [self offsetForDrawingAtPoint:point];
    CGRect frame = CGRectMake(point.x + ooffset.x, point.y + ooffset.y, [self size].width, [self size].height);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, frame.origin.x, frame.origin.y);
    CGContextAddLineToPoint(context, frame.origin.x + frame.size.width, frame.origin.y);
    CGContextAddLineToPoint(context, frame.origin.x + frame.size.width, frame.origin.y + frame.size.height);
    CGContextAddLineToPoint(context, frame.origin.x + (frame.size.width) / 2.0, frame.origin.y + frame.size.height);
    CGContextAddLineToPoint(context, frame.origin.x + frame.size.width / 2.0, frame.origin.y + frame.size.height);
    CGContextAddLineToPoint(context, frame.origin.x + (frame.size.width) / 2.0, frame.origin.y + frame.size.height);
    CGContextAddLineToPoint(context, frame.origin.x, frame.origin.y + frame.size.height - 0);
    CGContextAddLineToPoint(context, frame.origin.x, frame.origin.y);
    CGContextStrokePath(context);
    CGContextFillRect(context, frame);
    UIGraphicsPushContext(context);
    [self.markerText drawInRect:frame withAttributes:self.textAttributes];
    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}

@end

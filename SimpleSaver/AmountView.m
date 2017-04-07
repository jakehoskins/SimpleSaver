//
//  AmountView.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 15/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "AmountView.h"
#import "Helpers.h"

@implementation AmountView

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"AmountView" owner:self options:nil];
    
    
    [self addSubview: self.contentView];
    
    self.tfAmount.delegate = self;
    [self.lblDate setAdjustsFontSizeToFitWidth:true];
    self.lblDate.font = [UIFont systemFontOfSize:8];
    self.lblDate.textColor = [UIColor lightGrayColor];
}

-(void) setShadowColour:(UIColor *)shadowColour
{
    _shadowColour = shadowColour;
    
    self.contentView.layer.borderColor = _shadowColour.CGColor;
    self.contentView.layer.borderWidth = 3.0f;
    [self.contentView.layer setShadowOffset:CGSizeMake(5, 5)];
    [self.contentView.layer setShadowColor:_shadowColour.CGColor];
    [self.contentView.layer setShadowOpacity:0.5];
}

-(void) reload
{
    if (self.delegate)
    {
        NSDate *date = [self.delegate dateForFieldContribution];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"EEEE, MMM d, yyyy h:mm a"];
        self.lblDate.text = [formatter stringFromDate:date].uppercaseString;
    }
}

-(void)layoutSubviews
{
    self.contentView.frame = self.bounds;
}

-(NSNumber *) getAmount
{
    // Always have currency as first index
    if (self.tfAmount.text.length > 1)
    {
        NSString *str = [self replaceFormatting:[self.tfAmount.text substringFromIndex:1]];
        
        return @(str.doubleValue);
    }

    return @(0);
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    if ([string isEqualToString:@"\n"])
    {
        return false;
    }
    
    if (textField.text.length == 0)
    {
        if ([string isEqualToString:@"."])
        {
            string = [NSString stringWithFormat:@"0."];
        }
        
        textField.text = [Helpers formatCurrency:self.currency forAmount:[f numberFromString:string]];
    }
    else
    {
        NSString *escaped = [self replaceFormatting:textField.text];
        
        // Check only one decimal
        NSArray  *arrayOfDecimal = [escaped componentsSeparatedByString:@"."];
        if ([arrayOfDecimal count] > 2 )
        {
            return false;
        }
        
        if ([string isEqualToString:@""] && [escaped length] > 0)
        {
            escaped = [escaped substringWithRange:NSMakeRange(0, [escaped length] - 1)];
        }
        else
        {
            escaped = [NSString stringWithFormat:@"%@%@", escaped, string];
        }
        
        if ([Helpers containsOnlyNumericals:escaped])
        {
            NSArray *split = [escaped componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
            
            // If decimal we need to present it
            if (split.count > 1)
            {
                if (((NSString *) [split objectAtIndex:1]).length == 0)
                {
                    textField.text = [NSString stringWithFormat:@"%@.",[Helpers formatCurrency:self.currency forAmount:[f numberFromString:escaped]]];
                }
                else if([string isEqualToString:@"0"])
                {
                    textField.text = [Helpers formatCurrentAmountWithZeroDecimal:self.currency forAmount:[f numberFromString:escaped]];
                }
                else
                {
                    textField.text = [Helpers formatCurrency:self.currency forAmount:[f numberFromString:escaped]];
                }
            }
            else
            {
                textField.text = [Helpers formatCurrency:self.currency forAmount:[f numberFromString:escaped]];
            }
            
        } else if([escaped isEqualToString:@""])
        {
            [self setPlaceholder];
        }
    }
    
    
    return NO;
}

-(NSString *) replaceFormatting:(NSString *)current
{
    NSString *escaped = current;
    escaped = [escaped stringByReplacingOccurrencesOfString:self.currency withString:@""];
    escaped = [escaped stringByReplacingOccurrencesOfString:@"," withString:@""];
    escaped = [escaped stringByReplacingOccurrencesOfString:@"+" withString:@""];
    escaped = [escaped stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return escaped;
}


-(void) setCurrency:(NSString *)currency
{
    _currency = currency;
    
    [self setPlaceholder];
}

-(void) setPlaceholder
{
    NSString *placeholder = [NSString stringWithFormat:@"(%@) Enter contribution...", self.currency];
    self.tfAmount.text = @"";
    self.tfAmount.placeholder = placeholder;
}

@end

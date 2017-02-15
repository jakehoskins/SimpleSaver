//
//  Skin.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 12/02/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "Skin.h"
#import "Colours.h"
#import "UserSettings.h"

@implementation Skin

+(UIColor *) defaultGreenColour
{
    UIColor *colour = nil;
    
    switch ([Skin currentSkin])
    {
        case LightSkin:
            colour = [UIColor successColor];
            break;
        case DarkSkin:
            colour = [UIColor emeraldColor];
        default:
            break;
    }
    
    return colour;
}

+(UIColor *) defaultBlueColour
{
    UIColor *colour = nil;
    
    switch ([Skin currentSkin])
    {
        case LightSkin:
            colour = [UIColor pastelBlueColor];
            break;
        case DarkSkin:
            colour = [UIColor indigoColor];
        default:
            break;
    }
    
    return colour;
}

+(UIColor *) defaultRedColour
{
    UIColor *colour = nil;
    
    switch ([Skin currentSkin])
    {
        case LightSkin:
            colour = [UIColor salmonColor];
            break;
        case DarkSkin:
            colour = [UIColor brickRedColor];
        default:
            break;
    }
    
    return colour;
}

+(UIColor *) goalIconColour
{
    UIColor *colour = nil;
    
    switch ([Skin currentSkin])
    {
        case LightSkin:
            colour = [UIColor blackColor];
            break;
        case DarkSkin:
            colour = [UIColor grayColor];
        default:
            break;
    }
    
    return colour;
}

+(UIColor *) goalIconBackgroundColour
{
    UIColor *colour = nil;
    switch ([Skin currentSkin])
    {
        case LightSkin:
            colour = [UIColor clearColor];
            break;
        case DarkSkin:
            colour = [UIColor colorWithPatternImage:[Skin backgroundImageForMaster]];
        default:
            break;
    }
    
    return colour;
}
+(UIColor *) defaultTextColourForDarkBackground
{
    UIColor *colour = nil;
    switch ([Skin currentSkin])
    {
        case LightSkin:
            colour = [UIColor blackColor];
            break;
        case DarkSkin:
            colour = [UIColor grayColor];
        default:
            break;
    }
    
    return colour;
}

+(UIColor *) progressBarBackgroundColour
{
    UIColor *colour = nil;
    switch ([Skin currentSkin])
    {
        case LightSkin:
            colour = [UIColor colorWithPatternImage:[Skin backgroundImageForDetail]];
            break;
        case DarkSkin:
            colour = [UIColor colorWithPatternImage:[Skin backgroundImageForDetail]];
        default:
            break;
    }
    
    return colour;
}


+(UIImage *) backgroundImageForMaster
{
    UIImage *image = nil;
    switch ([Skin currentSkin])
    {
        case LightSkin:
            image = [UIImage imageNamed:@"master-background-default"];
            break;
        case DarkSkin:
            image = [UIImage imageNamed:@"master-background-dark"];
        default:
            break;
    }
    
    return image;
}

+(UIImage *) backgroundImageForDetail
{
    UIImage *image = nil;
    switch ([Skin currentSkin])
    {
        case LightSkin:
            image = [UIImage imageNamed:@"detail-background-default"];
            break;
        case DarkSkin:
            image = [UIImage imageNamed:@"detail-background-dark"];
        default:
            break;
    }
    
    return image;
}


+(SkinType) currentSkin
{
    return ([[UserSettings getInstance] darkSkinEnabled]) ? DarkSkin : LightSkin;
}

@end

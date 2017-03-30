//
//  Skin.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 12/02/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SkinType) {
    LightSkin,
    DarkSkin
};

@interface Skin : NSObject
+(SkinType) currentSkin;
+(UIColor *) defaultGreenColour;
+(UIColor *) defaultBlueColour;
+(UIColor *) defaultRedColour;
+(UIColor *) goalIconColour;
+(UIColor *) defaultTextColour;
+(UIColor *) progressBarBackgroundColour;
+(UIColor *) goalIconBackgroundColour;
+(UIImage *) backgroundImageForMaster;
+(UIImage *) backgroundImageForDetail;
@end

//
//  SettingsConfig.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 12/03/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface SettingsConfig : NSObject

+(instancetype) sharedInstance;


@property (nonatomic, strong) NSArray *settingItems;
@property (nonatomic, strong) NSMutableDictionary *settingsMap;

@end

//
//  SettingsConfig.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 12/03/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "SettingsConfig.h"

@implementation SettingsConfig

+(instancetype) sharedInstance
{
    static SettingsConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:SETTINGS_CONFIG_PATH ofType:@"plist"]];
        NSDictionary *settingItems =  [dictionary objectForKey:@"settings"];
        NSMutableArray *itemLocators = [NSMutableArray arrayWithCapacity:5];
        self.settingsMap = [NSMutableDictionary dictionaryWithCapacity:5];
        
        for (NSDictionary *key in settingItems)
        {
            
            [itemLocators addObject:[key objectForKey:@"name"]];
            [self.settingsMap setValue:key forKey:[key objectForKey:@"name"]];
        }
        
        self.settingItems = [NSArray arrayWithArray:itemLocators];
    }
    return self;
}

@end

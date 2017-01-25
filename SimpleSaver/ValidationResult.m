//
//  ValidationResult.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 02/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "ValidationResult.h"

NSInteger const CODE_OK = 1;
NSInteger const CODE_NON_NUMERIC = 2;
NSInteger const CODE_BAD_DEADLINE = 3;
NSInteger const CODE_EMPTY_FIELD = 4;
NSInteger const CODE_NEEDS_STRING = 5;

NSString * const DESC_OK = @"Validation Successful";
NSString * const DESC_NON_NUMERIC = @"Numeric value expected please check the fields";
NSString * const DESC_BAD_DEADLINE = @"End date cannot be the same as start date";
NSString * const DESC_BAD_FIELD = @"Ensure all required fields are set";
NSString * const DESC_NEEDS_STRING = @"Did not expect a numerican value";

@interface ValidationResult()
@property NSInteger code;

@end
@implementation ValidationResult

-(id) initWithValidationCode:(NSInteger)code
{
    self = [super init];
    
    if (self)
    {
        self.code = code;
    }
    
    return self;
}

-(NSInteger) getCode
{
    return self.code;
}

-(NSString *) description
{
    NSString *description = nil;
    
    switch (self.code) {
        case CODE_OK:
            description = DESC_OK;
            break;
        case CODE_NON_NUMERIC:
            description = DESC_NON_NUMERIC;
            break;
        case CODE_BAD_DEADLINE:
            description = DESC_BAD_DEADLINE;
            break;
        case CODE_EMPTY_FIELD:
            description = DESC_BAD_FIELD;
            break;
        case CODE_NEEDS_STRING:
            description = DESC_NEEDS_STRING;
            break;
        default:
            break;
    }
    
    return description;
}
@end

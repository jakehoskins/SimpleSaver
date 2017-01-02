//
//  ValidationResult.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 02/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidationResult : NSObject

extern NSInteger const CODE_OK;
extern NSInteger const CODE_NON_NUMERIC ;
extern NSInteger const CODE_BAD_DEADLINE;
extern NSInteger const CODE_EMPTY_FIELD;
extern NSInteger const CODE_NEEDS_STRING;

-(id) initWithValidationCode:(NSInteger)code;
-(NSString *) description;
-(NSInteger) getCode;

@end

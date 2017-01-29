//
//  EditProtocol.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 29/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#ifndef EditProtocol_h
#define EditProtocol_h

@protocol EditProtocol <NSObject>

@optional
-(NSDictionary *) dictionaryForEdit;
@end

#endif /* EditProtocol_h */

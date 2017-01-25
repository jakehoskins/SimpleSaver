//
//  GoalIconTableViewController.h
//  SimpleSaver
//
//  Created by Jake Hoskins on 25/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GoalIconTableViewDelegate <NSObject>
@optional
- (void) imageSelectedWithURL:(NSString *)url;
@end

@interface GoalIconTableViewController : UITableViewController
@property (nonatomic, weak, readwrite) id <GoalIconTableViewDelegate> delegate;
@end

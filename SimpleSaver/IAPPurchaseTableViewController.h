//
//  IAPPurchaseTableViewController.h
//  MathToolKit 2
//
//  Created by Jake Hoskins on 04/09/2016.
//  Copyright © 2016 Jake Hoskins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <OpinionzAlertView/OpinionzAlertView.h>

#define CELL_IAP @"store-cell"
#define UNLIMITED_GOALS_PRODUCT_ID @"com.jakehoskins.simplesaver.iap.unlimitedgoals"

@interface IAPPurchaseTableViewController : UITableViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property NSMutableArray *productCatalog;                                  // Name, Description, Price //
@property SKProductsRequest *request;
@property NSMutableArray *cellButtons;
@property UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UIButton *restore;



- (IBAction)restorePurchases:(id)sender;


@end

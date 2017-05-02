//
//  IAPPurchaseTableViewController.m
//  MathToolKit 2
//
//  Created by Jake Hoskins on 04/09/2016.
//  Copyright © 2016 Jake Hoskins. All rights reserved.
//

#import "IAPPurchaseTableViewController.h"
#import "AvePurchaseButton.h"
#import "Constants.h"
#import "Skin.h"

@interface IAPPurchaseTableViewController ()
@property NSMutableIndexSet* busyIndexes;
@end

@implementation IAPPurchaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[Skin backgroundImageForDetail]];

    UIBarButtonItem *btnClose = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(dismissViewController)];
    self.navigationItem.rightBarButtonItem = btnClose;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupNavigationBarImage];
    
    _busyIndexes = [NSMutableIndexSet new];
    
    // Initiate the product catalog
    [self getProductInfo:[NSSet setWithObjects:UNLIMITED_GOALS_PRODUCT_ID, DARK_THEME_PRODUCT_ID, nil]];
    
    // Add observations for transaction
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)setupNavigationBarImage
{
    UIImage *image = [UIImage imageNamed:@"simplesaver"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    self.navigationItem.titleView = imageView;
}

#pragma Alerts
- (void) showValidationError:(NSString *) title withMessage:(NSString *) message{
    OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:title
                                                                message:message
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
    alert.iconType = OpinionzAlertIconWarning;
    [alert show];
}

-(void) showPurchaseSuccess:(NSString *) title withMessage:(NSString *) message {
    OpinionzAlertView *alert = [[OpinionzAlertView alloc] initWithTitle:title
                                                                message:message
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
    alert.iconType = OpinionzAlertIconSuccess;
    alert.color = [UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1];
    [alert show];
    
}

-(void) dismissViewController
{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_productCatalog count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IAP forIndexPath:indexPath];
    UILabel *title = (UILabel *)[self.view viewWithTag:700];
    UILabel *description = (UILabel *)[self.view viewWithTag:701];
    
    SKProduct *product = [_productCatalog objectAtIndex:indexPath.row];
    
  
    AvePurchaseButton* button = [[AvePurchaseButton alloc] initWithFrame:CGRectZero];
    [button addTarget:self action:@selector(purchaseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = button;
    
    [title setText:[product localizedTitle]];
    [description setText:[product localizedDescription]];
    
    
    button.buttonState = AvePurchaseButtonStateNormal;
    BOOL hasPaid = false;
    
    if ([product.productIdentifier isEqualToString:UNLIMITED_GOALS_PRODUCT_ID])
    {
        hasPaid = [Constants hasPurchasedUnlimitedGoals];
    }
    else if([product.productIdentifier isEqualToString:DARK_THEME_PRODUCT_ID])
    {
        hasPaid = [Constants hasPurchasedDarkTheme];
    }
    
    if (!hasPaid)
    {
        button.normalTitle = [self getPrice:product];
        
    } else
    {
        button.normalTitle = @"Purchased";
        [button setEnabled:false];
    }
    
    button.confirmationTitle = @"BUY";
    [button sizeToFit];
    
    // if the item at this indexPath is being "busy" with purchasing, update the purchase
    // button's state to reflect so.
    if([_busyIndexes containsIndex:indexPath.row] == YES)
    {
        button.buttonState = AvePurchaseButtonStateProgress;
    }
    
    [button sizeToFit];
    
    // if the item at this indexPath is being "busy" with purchasing, update the purchase
    // button's state to reflect so.
    if([_busyIndexes containsIndex:indexPath.row] == YES)
    {
        button.buttonState = AvePurchaseButtonStateProgress;
    }
    
    if (indexPath.row < [_cellButtons count]) {
        [_cellButtons addObject:button];
    }
    
    return cell;
}


#pragma Payment
// Request product catalog
- (void)getProductInfo:(NSSet *) identifiers {
    [_activity startAnimating];
    if ([SKPaymentQueue canMakePayments]) {
        _request = [[SKProductsRequest alloc]
                    initWithProductIdentifiers:
                    identifiers];
        
        _request.delegate = self;
        [_request start];
    } else {
        
    }
}

// Delegate that fills our product catalog
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    int count = (int) [response.products count];
    [_activity stopAnimating];
    if(count > 0){
        [_productCatalog removeAllObjects];
        _productCatalog = [[NSMutableArray alloc] init];
        for (int i = 0; i < count; i++) {
            [_productCatalog addObject:[response.products objectAtIndex:i]];
        }
        [self.tableView reloadData];
    }
}

-(void)purchaseButtonTapped:(AvePurchaseButton*)button {
    NSIndexPath* indexPath = [self.tableView indexPathForCell:(UITableViewCell*)button.superview];
    NSInteger index = indexPath.row;
    
    // handle taps on the purchase button by
    switch(button.buttonState)
    {
        case AvePurchaseButtonStateNormal:
            // progress -> confirmation
            [button setButtonState:AvePurchaseButtonStateConfirmation animated:YES];
            break;
            
        case AvePurchaseButtonStateConfirmation:
            // confirmation -> "purchase" progress
            [_busyIndexes addIndex:index];
            [button setButtonState:AvePurchaseButtonStateProgress animated:YES];
            
            [self purchase:[_productCatalog objectAtIndex:index]];
            
            break;
            
        case AvePurchaseButtonStateProgress:
            [_busyIndexes removeIndex:index];
            break;
    }
}


// Called when request fail
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    AvePurchaseButton* button = [_cellButtons objectAtIndex:0];         // not scalable //
    
    [_restore setEnabled:true];
    [_activity stopAnimating];
    [button setButtonState:AvePurchaseButtonStateNormal];
}

// Purchase a product
- (void)purchase:(SKProduct *)product{
    [_activity startAnimating];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction)restorePurchases:(id)sender {
    [_activity startAnimating];
    [_restore setEnabled:false];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            
            if ([transaction.payment.productIdentifier isEqualToString: UNLIMITED_GOALS_PRODUCT_ID])
            {
                [Constants writeToUnlimtedGoals:true];
            }
            else if([transaction.payment.productIdentifier isEqualToString:DARK_THEME_PRODUCT_ID])
            {
                [Constants writeToDarkTheme:true];
            }
            
            [_activity stopAnimating];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
    [self.tableView reloadData];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    [_restore setEnabled:true];
    [_activity stopAnimating];
}

// Delegate for updates transactions -- write to Config
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    NSString *message;
    NSString *title;
    AvePurchaseButton* button = [_cellButtons objectAtIndex:0];         // not scalable //
    
    [_restore setEnabled:true];
    [_activity stopAnimating];
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                NSLog(@"Transaction state -> Purchased");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [Constants writeToUnlimtedGoals:true];
                title = [NSString stringWithFormat:@"Purchase Successful"];
                message = [NSString stringWithFormat:@"Successfuly purchased item"];
                
                [button setButtonState:AvePurchaseButtonStateNormal];
                [button setNormalTitle:@"Purchased"];
                [button setEnabled:false];
                break;
            case SKPaymentTransactionStateRestored:
                title = [NSString stringWithFormat:@"Restore Successful"];
                message = [NSString stringWithFormat:@"Successfuly restored in app purchases"];
                
                NSLog(@"Transaction state -> Restored");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [Constants writeToUnlimtedGoals:true];
                [button setButtonState:AvePurchaseButtonStateNormal];
                [button setNormalTitle:@"Purchased"];
                [button setEnabled:false];
                [self showPurchaseSuccess:title withMessage:message];
                break;
            case SKPaymentTransactionStateFailed:
                title = [NSString stringWithFormat:@"Transaction Failed"];
                message = [NSString stringWithFormat:@"Successfuly restored in app purchases"];
                
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    message = [NSString stringWithFormat:@"Cancelled payment!"];
                }
                
                message = [NSString stringWithFormat:@"Could not complete transaction!"];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [Constants writeToUnlimtedGoals:false];
                [self showValidationError:title withMessage:message];
                
                break;
                default:
                    break;
        }
    }
    [self.tableView reloadData];
}

-(NSString*)getPrice:(SKProduct*)product{
    NSNumberFormatter * _priceFormatter;
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    [_priceFormatter setLocale:product.priceLocale];
    return [_priceFormatter stringFromNumber:product.price];
    
}
@end

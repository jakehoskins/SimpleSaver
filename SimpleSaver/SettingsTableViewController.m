//
//  SettingsTableViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 12/03/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "SettingsConfig.h"
#import "Skin.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[Skin backgroundImageForDetail]];
    
    UIBarButtonItem *btnClose = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(dismissViewController)];
    self.navigationItem.rightBarButtonItem = btnClose;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupNavigationBarImage];
    
}

-(void)setupNavigationBarImage
{
    UIImage *image = [UIImage imageNamed:NAVIGATION_BAR_IMAGE];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    self.navigationItem.titleView = imageView;
}

- (void) dismissViewController
{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[SettingsConfig sharedInstance] settingItems].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settings-cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[[SettingsConfig sharedInstance] settingItems] objectAtIndex:indexPath.row];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsConfig *sharedInstance = [SettingsConfig sharedInstance];
    NSString *itemLocator = [[sharedInstance settingItems] objectAtIndex:indexPath.row];
    NSDictionary *itemMap = [[sharedInstance settingsMap] objectForKey:itemLocator];
                         
    if ([[itemMap objectForKey:@"target"] length] > 0)
    {
        [self loadViewControllerForTarget:[itemMap objectForKey:@"target"]];
    }
}

-(void) loadViewControllerForTarget:(NSString *)target
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id targetVc = [storyboard instantiateViewControllerWithIdentifier:target];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:targetVc];
    [self presentViewController:navigation animated:true completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

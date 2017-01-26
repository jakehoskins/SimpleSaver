//
//  GoalIconTableViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 25/01/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "GoalIconTableViewController.h"
#import "Constants.h"
#import "NZCircularImageView.h"
#import "Colours.h"
@interface GoalIconTableViewController ()
@property (nonatomic, strong) NSArray *loadedImages;
@property (nonatomic, strong) UIImage *imageViewBackground;
@end

@implementation GoalIconTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissViewController)];
    
    self.navigationItem.rightBarButtonItem = cancel;
    
    [self loadImages];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"detail-background"]];
    
    self.title = @"Select Goal Icon";
}

-(void) dismissViewController
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) loadImages
{
    NSMutableArray *icons = [NSMutableArray arrayWithCapacity:[Constants getGoalIconURLSet].count];
    
    self.imageViewBackground = [UIImage imageNamed:BACKGROUND_IMAGE];
    
    for (NSString *url in [Constants getGoalIconURLSet])
    {
        [icons addObject:[UIImage imageNamed:url]];
    }
    
    self.loadedImages = [NSArray arrayWithArray:icons];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.loadedImages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goal-icon" forIndexPath:indexPath];
    NZCircularImageView *imageView = (NZCircularImageView *)[cell viewWithTag:300];
    
    imageView.borderColor = [UIColor goldColor];
    imageView.borderWidth = @(1.0f);
    imageView.backgroundColor = [UIColor colorWithPatternImage:self.imageViewBackground];
    imageView.image = [self.loadedImages objectAtIndex:indexPath.row];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate)
    {
        [self.delegate imageSelectedWithURL:[[Constants getGoalIconURLSet] objectAtIndex:indexPath.row]];
        [self dismissViewController];
    }
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.view setNeedsLayout];
}

@end

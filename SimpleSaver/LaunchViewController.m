//
//  LaunchViewController.m
//  SimpleSaver
//
//  Created by Jake Hoskins on 08/02/2017.
//  Copyright © 2017 Jake Hoskins. All rights reserved.
//

#import "LaunchViewController.h"
#import "SKSplashView.h"
#import "SKSplashIcon.h"
#import "SimpleSaverSplitViewController.h"
#import "GoalsViewController.h"
#import "GoalDetailViewController.h"
#import "Colours.h"
@interface LaunchViewController ()<SKSplashDelegate>

@end

@implementation LaunchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    SKSplashIcon *icon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"simplesaver"] animationType:SKIconAnimationTypePing];
    
    SKSplashView *splashView = [[SKSplashView alloc] initWithSplashIcon:icon backgroundColor:[UIColor blueberryColor] animationType:SKSplashAnimationTypeBounce];

    splashView.delegate = self;
    splashView.animationDuration = 3.0f;
    [self.view addSubview:splashView];
    [splashView startAnimation];
}


-(void) splashViewDidEndAnimating:(SKSplashView *)splashView
{
    [self launchApplication];
}

-(void) launchApplication
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SimpleSaverSplitViewController *sssvc = [[SimpleSaverSplitViewController alloc] init];
        GoalsViewController *master = (GoalsViewController *) [storyboard instantiateViewControllerWithIdentifier:@"goalsviewcontroller"];
    
    GoalDetailViewController *detail = (GoalDetailViewController *) [storyboard instantiateViewControllerWithIdentifier:@"detail"];
    UINavigationController *masterNavigation = [[UINavigationController alloc] initWithRootViewController:master];
    UINavigationController *detailNavigation = [[UINavigationController alloc] initWithRootViewController:detail];
    
    [sssvc setViewControllers:[NSArray arrayWithObjects:masterNavigation, detailNavigation,nil]];
    sssvc.delegate = sssvc;
    [window setRootViewController:(UIViewController*)sssvc];
    [window makeKeyAndVisible];
}

@end

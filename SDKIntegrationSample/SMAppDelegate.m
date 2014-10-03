//
//  SMAppDelegate.m
//  SDKIntegrationSample
//
//  Created by Kevin Yarmosh on 9/5/14.
//  Copyright (c) 2014 sessionm. All rights reserved.
//

#import "SMAppDelegate.h"
#import "SMContainerViewController.h"
#import "SMViewController.h"
@implementation SMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    SMContainerViewController * container = [self makeContainer];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = container;
    [self.window makeKeyAndVisible];

    return YES;
}

-(SMContainerViewController*)makeContainer {
    UITableViewController *tvc = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    SMViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"viewController"];
    UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:tvc];
    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    SMContainerViewController *cvc = [[SMContainerViewController alloc] initWithCenterViewController:centerNav andLeftViewController:leftNav];
    return cvc;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

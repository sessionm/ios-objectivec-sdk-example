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
#import "SMLeftViewController.h"
#import "SessionMUIWelcomeViewController.h"
#import "SMMultiCastDelegate.h"

// See https://developer.sessionm.com/get_started
// to get your app ID as well as setup actions and achievements.
#define YOUR_APP_ID @""

@implementation SMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    SMContainerViewController * container = [self makeContainer];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = container;
    [self.window makeKeyAndVisible];
    
    // Set the delegate so we get notified from the SDK to MutlicastDelegate instance
    [[SessionM sharedInstance] setDelegate:[SMMulticastDelegate sharedInstance]];
    
    // Init the SDK
    SMStart(YOUR_APP_ID);
    // If you need to Debug Logs uncomment the line below
    //[SessionM sharedInstance].logLevel = SMLogLevelDebug;
    
    // SessionM Welcome View.
    // Instantiate it Here
    // Optionally Ensure that you have reached out to the SessionM Publisher team to enable
    // this feature on the Session Counts, Its recommended that developers Either show it at
    // the 2nd or the 3rd time the App Starts to make users aware of the Rewards/Loyalty Program.
    // Use the Header image sizes and Customize the colors from the SessionMUIWelcomeViewController.xib
    // Out Publisher team can also help you with Enhancing the images and content. Feel free to reach out.
    welcomeView = [[SessionMUIWelcomeViewController alloc] init];
    
    return YES;
}

-(SMContainerViewController*)makeContainer {
    SMLeftViewController *lvc = [[SMLeftViewController alloc] init];
    UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:lvc];

    SMViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"viewController"];
    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    SMContainerViewController *cvc = [[SMContainerViewController alloc] initWithCenterViewController:centerNav andLeftViewController:leftNav];
    lvc.containerVC = cvc;
    vc.containerVC = cvc;
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
    
    // SessionM observer to make sure we display rewards welcome content only after the Blogroll has populated itself


}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// Methods to handle url support for SessionM. The scheme your app should register for to work with SessionM SDK is sessionmYouAppKey
// I.e. the url scheme for this app is sessionm7a6cf3f9d1a2016efd1bb5b3a1193a22785480cb
// Try texting sessionm7a6cf3f9d1a2016efd1bb5b3a1193a22785480cb://portal device with this app installed to test this method.
// It should result it presenting the SessionM Portal in a modal.
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([SessionM sharedInstance].sessionState == SessionMStateStartedOnline) {
        [[SessionM sharedInstance] handleURL:url];
    } else {
        self.pendingURL = url;
    }
    return YES;
}





@end

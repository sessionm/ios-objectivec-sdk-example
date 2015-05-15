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
    // Set the delegate so we get notified from the SDK
    [[SessionM sharedInstance] setDelegate:self];
    // Init the SDK
    SMStart(YOUR_APP_ID);
    //[SessionM sharedInstance].logLevel = SMLogLevelDebug;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSessionMWelcomeAfterNotification:)
                                                 name:@"SMWelcomeWillEnterForeground"
                                               object:nil];

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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SMWelcomeWillEnterForeground" object:nil];

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SMWelcomeWillEnterForeground" object:nil];

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // SessionM observer to make sure we display rewards welcome content only after the Blogroll has populated itself
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSessionMWelcomeAfterNotification:)
                                                 name:@"SMWelcomeWillEnterForeground"
                                               object:nil];
    
    // SessionM make sure we do not display the SessionM rewards welcome by default
    [self showSessionMWelcome:NO];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSessionMWelcomeAfterNotification:)
                                                 name:@"SMWelcomeWillEnterForeground"
                                               object:nil];

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


#pragma mark - Welcome Splash

-(void) showSessionMWelcome:(BOOL) enteredForeground {
    SessionM *smSessionInfo = [SessionM sharedInstance];
    
    if(smSessionInfo ) {
        SessionMState *smSessionState = (SessionMState *) smSessionInfo.sessionState;
        NSUserDefaults *smDefaults = [NSUserDefaults standardUserDefaults];
        if( ![smDefaults boolForKey:@"com.sessionm.SessionM.introSeen"] &&   // if the user has not see this yet
           smSessionState != (SessionMState *)SessionMServiceUnavailable &&  // the service is available
           smSessionInfo.user.isOptedOut == NO && // the user is opted into rewards and only display if on second session or app open to be polite
           smSessionInfo.displayInAppWelcomeFlow) {
            [smDefaults setBool:YES forKey:@"com.sessionm.SessionM.introSeen"];
            [smDefaults synchronize];
            // Add A Tap Gesture Recognizer if you do not want to Click the Button, but if you do want the tap to be captured.
            // Please use IBAction under SessionMUIWelcomeViewController.h
            SessionMUIWelcomeViewController *smWelcomeViewController = [[SessionMUIWelcomeViewController alloc] init];
            UITapGestureRecognizer *smWelcomeRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSMWelcomeView:)];
            [smWelcomeViewController.view addGestureRecognizer:smWelcomeRecognizer];
            UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
            [rootController.view addSubview:smWelcomeViewController.view];
        }
    }
}

-(void) showSessionMWelcomeAfterNotification:(NSNotification*) foregroundNotification {
    [self showSessionMWelcome:YES];
}


-(void)closeSMWelcomeView:(UIGestureRecognizer *)recognizer {
    [recognizer.view removeFromSuperview];
}


-(void)hideSMWelcome:(UITapGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations:^{
            welcomeView.alpha = 0;
        } completion:^(BOOL finished) {
            [welcomeView removeFromSuperview];
            welcomeView = nil;
        }];
    }
}


@end

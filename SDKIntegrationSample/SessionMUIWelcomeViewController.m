//
//  SessionMUIWelcomeViewController.m
//  SessionM
//
//  Created by Grafton Daniels on 5/23/14.
//  Copyright (c) 2014 SessionM. All rights reserved.
//

#import "SessionMUIWelcomeViewController.h"
#import "SessionM.h"

@interface SessionMUIWelcomeViewController ()

@end

@implementation SessionMUIWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.smWelcomeButton.enabled = YES;
        
        // Put these Application Notification handlers
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.view setAlpha:1.0];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startEarning:(id)sender {
    [[SessionM sharedInstance]presentActivity:SMActivityTypePortal];
    NSLog(@"SessionM: Tapped Gift Box");
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
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            self.view = nil;
        }];
    }
}

#pragma mark - UIApplication Notifications


- (void)didEnterBackground
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SMWelcomeWillEnterForeground" object:nil];

}

- (void)willEnterForeground
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSessionMWelcomeAfterNotification:)
                                                 name:@"SMWelcomeWillEnterForeground"
                                               object:nil];
    
    // SessionM make sure we do not display the SessionM rewards welcome by default
    [self showSessionMWelcome:NO];
}

- (void)didBecomeActive
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSessionMWelcomeAfterNotification:)
                                                 name:@"SMWelcomeWillEnterForeground"
                                               object:nil];
}

- (void)willResignActive
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SMWelcomeWillEnterForeground" object:nil];

}

- (void)applicationWillTerminate
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

@end

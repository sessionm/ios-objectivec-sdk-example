SessionMSDKExample
==================
Sample project showing how to use the SessionM SDK. 

This project takes advantage of cocoapods (http://guides.cocoapods.org/using/getting-started.html) for the sake of importing the SessionM SDK.

If you do not use cocoapods in your project, download the SessionM SDK (http://www.sessionm.com/documentation/downloads.php), place the SessionM-SDK folder in your project, and be sure to link against the following frameworks: AVFoundation, EventKit, EventKitUI, CoreData, CoreMedia, MediaPlayer, AdSupport and StoreKit frameworks.

For more help see http://www.sessionm.com/documentation/index.php

## Requirements
* Xcode 6 or higher
* Apple LLVM compiler
* iOS 6.0 or higher
* ARC

#How to use Animated Gift Box

<img src="https://github.com/sessionm/ios-objectivec-sdk-example/raw/master/SMNavGiftBox.png" alt="SMNavGiftBox Screenshot" width="200" height="359" />
<img src="https://github.com/sessionm/ios-objectivec-sdk-example/raw/master/SMNavGiftBox.gif" alt="SMNavGiftBox Anima" width="200" height="359" />

Add the follwing files found in the SDKIntegrationSample folder to your project:
 	`SMNavGiftBox.h`
 	`SMNavGiftBox.m`
 	`SMNavGiftBox.xib`

Create a `SMNavGiftBox`.

	@interface YOUR_VIEW_CONTROLLER () {
		SMNavGiftBox *smNav;
	}	
	
	
	- (void)viewDidLoad {
		
		// Initialize new SMNavGiftBox
		smNav = [SMNavGiftBox new];
		smNav.view.frame = CGRectMake(X_COORDINATE, Y_COORDINATE, smNav.view.frame.size.width/3, smNav.view.frame.size.height/3);
		[self.navigationController.view addSubview: smNav.view];

	}

	- (void)viewDidAppear:(BOOL)animated {
		[smNav animate];
	}	

#How to use the Welcome Screen to educate users on earning mPOINTS

Add the follwing files found in the SDKIntegrationSample folder to your project:
 	`SessionMUIWelcomeViewController.h`
 	`SessionMUIWelcomeViewController.m`
 	`SessionMUIWelcomeViewController.xib`

Create a `SessionMUIWelcomeViewController`.
	
	// YourAppDelegate.h
	
	#import "SessionMUIWelcomeViewController.h"

	// See https://developer.sessionm.com/get_started
	// to get your app ID as well as setup actions and achievements.
	
	#define YOUR_APP_ID @""
	
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
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

	- (void)applicationWillResignActive:(UIApplication *)application{
		// Use this method to remove notification observer.
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"SMWelcomeWillEnterForeground" object:nil];

	}

	- (void)applicationDidEnterBackground:(UIApplication *)application{
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"SMWelcomeWillEnterForeground" object:nil];
	}

	- (void)applicationWillEnterForeground:(UIApplication *)application{
		// SessionM observer to make sure we display rewards welcome content only after the Application enters Foreground 
		[[NSNotificationCenter defaultCenter] addObserver:self
							selector:@selector(showSessionMWelcomeAfterNotification:)
							name:@"SMWelcomeWillEnterForeground"
							object:nil];
    		
		// SessionM make sure we do not display the SessionM rewards welcome by default
		[self showSessionMWelcome:NO];

	}

	- (void)applicationDidBecomeActive:(UIApplication *)application{

    		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		[[NSNotificationCenter defaultCenter] addObserver:self
							selector:@selector(showSessionMWelcomeAfterNotification:)
							name:@"SMWelcomeWillEnterForeground"
							object:nil];
	}


	#pragma mark - Welcome Splash

	-(void) showSessionMWelcome:(BOOL) enteredForeground {
		SessionM *smSessionInfo = [SessionM sharedInstance];
		if(smSessionInfo ) {
			SessionMState *smSessionState = (SessionMState *) smSessionInfo.sessionState;
			NSUserDefaults *smDefaults = [NSUserDefaults standardUserDefaults];
			if(![[NSUserDefaults standardUserDefaults] boolForKey:@"com.sessionm.SessionM.introSeen"] &&   
			// if the user has not see this yet
           		smSessionState != (SessionMState *)SessionMServiceUnavailable &&
			// the service is available 
			smSessionInfo.user.isOptedOut == NO && 
			// the user is opted into rewards and only display if on second session or app open to be polite
			smSessionInfo.displayInAppWelcomeFlow) {
				// You can save this(com.sessionm.SessionM.introSeen) key using your Custom Defaults init or use the code below;
				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"com.sessionm.SessionM.introSeen"];
				[[NSUserDefaults standardUserDefaults] synchronize]; 
			
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
			welcomeView.alpha = 0;}
			completion:^(BOOL finished) {
				[welcomeView removeFromSuperview];
				welcomeView = nil;
			}];
		}
	}


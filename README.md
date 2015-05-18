SessionMSDKExample
==================
Sample project showing how to use the SessionM SDK. 

This project takes advantage of cocoapods (http://guides.cocoapods.org/using/getting-started.html) for the sake of importing the SessionM SDK.

If you do not use cocoapods in your project, download the SessionM SDK (http://www.sessionm.com/documentation/downloads.php), place the SessionM-SDK folder in your project, and be sure to link against the following frameworks: AVFoundation, EventKit, EventKitUI, CoreData, CoreMedia, MediaPlayer, AdSupport and StoreKit frameworks.

For more help see http://www.sessionm.com/documentation/index.php

#How to use Animated Gift Box

Add the follwing files found in the SDKIntegrationSample folder to your project:
 	`SMNavGiftBox.h`
 	`SMNavGiftBox.m`
 	`SMNavGiftBox.xib`

Create a `SMNavGiftBox`.

	@interface YOUR_VIEW_CONTROLLER () {
		SMNavGiftBox *smNav;
	}	


	- (void)viewDidAppear:(BOOL)animated {
		// Gift box on Navigation bar
		// You can use the code below to initialize the GiftBox at any other place.
    		
		[smNav.view removeFromSuperview];
		smNav = [SMNavGiftBox new];
		smNav.view.frame = CGRectMake(YOUR_X_COORDINATE,YOUR_Y_COORDINATE,smNav.view.frame.size.width/3, smNav.view.frame.size.height/3);
		[self.navigationController.view addSubview: smNav.view];
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

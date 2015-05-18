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

	@interface SMAppDelegate : UIResponder <UIApplicationDelegate>{
		SessionMUIWelcomeViewController *welcomeView;
	}

	// See https://developer.sessionm.com/get_started
	// to get your app ID as well as setup actions and achievements.
	
	#define YOUR_APP_ID @""
		
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
		// Set the delegate so we get notified from the SDK
		[[SessionM sharedInstance] setDelegate:self];
		
		// Init the SDK
		SMStart(YOUR_APP_ID);
		
		// Automatically Shows the Welcome View introducing users to the mPOINTS Rewards/Loyalty Program
		welcomeView = [[SessionMUIWelcomeViewController alloc] init];
	}

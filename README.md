SessionMSDKExample
==================
Sample project showing how to use the SessionM SDK. 

This project takes advantage of cocoapods (http://guides.cocoapods.org/using/getting-started.html) for the sake of importing the SessionM SDK.

If you do not use cocoapods in your project, download the SessionM SDK (http://www.sessionm.com/documentation/downloads.php), place the SessionM-SDK folder in your project, and be sure to link against the following frameworks: AVFoundation, EventKit, EventKitUI, CoreData, CoreMedia, MediaPlayer, AdSupport and StoreKit frameworks.

For more help see http://www.sessionm.com/documentation/index.php

## Requirements
* Xcode 6 or higher
* Apple LLVM compiler
* iOS 7.0 or higher
* ARC

## Table Of Contents
- [How to use Animated Gift Box](#how_to_use_animated_giftBox)
- [How to use the Welcome Screen to educate users on earning mPOINTS](#how-to-use-the-welcome-screen-to-educate-users-on-earning-mpoints)
- [How to use SMHamburger Bubble](#how-to-use-smhamburger-bubble)
- [How to Deep Link into Rewards Portal Content](#how-to-deep-link-into-rewards-portal-content)

## How to use Animated Gift Box

<img src="https://github.com/sessionm/ios-objectivec-sdk-example/raw/master/SDKIntegrationSampleImages/SMNavGiftBox.png" alt="SMNavGiftBox Screenshot" width="200" height="359" />
<img src="https://github.com/sessionm/ios-objectivec-sdk-example/raw/master/SDKIntegrationSampleImages/SMNavGiftBox.gif" alt="SMNavGiftBox Anima" width="200" height="359" />

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
	}

	- (void)viewDidAppear:(BOOL)animated {
		[self.view addSubview: smNav.view];
		[smNav animate];
	}

	-(void)viewWillDisappear:(BOOL)animated {
		// OPTIONAL (REMEMBER TO RE ADD THESE BACK im viewDidAppear method of your Controller )
    		[smNav.view removeFromSuperview];

	}

## How to use the Welcome Screen to educate users on earning mPOINTS

<img src="https://github.com/sessionm/ios-objectivec-sdk-example/raw/master/SDKIntegrationSampleImages/WelcomeView.png" alt="WelcomeView Screenshot" width="200" height="360" />
<img src="https://github.com/sessionm/ios-objectivec-sdk-example/raw/master/SDKIntegrationSampleImages/WelcomeView.gif" alt="WelcomeView Anima" width="200" height="360" />

Add the follwing files found in the SDKIntegrationSample folder to your project:
 	`SessionMUIWelcomeViewController.h`
 	`SessionMUIWelcomeViewController.m`
 	`SessionMUIWelcomeViewController.xib`

Create a `SessionMUIWelcomeViewController`.
	
	// YourAppDelegate.h
	
	#import "SessionMUIWelcomeViewController.h"

	@interface YourAppDelegate : UIResponder <UIApplicationDelegate>{
		SessionMUIWelcomeViewController *welcomeView;
	}

	// YourAppDelegate.m

	@implementation YourAppDelegate
	
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

#How to use SMHamburger Bubble

<img src="https://github.com/sessionm/ios-objectivec-sdk-example/raw/master/SDKIntegrationSampleImages/SMHamburger.png" alt="SMHamburger Screenshot" width="200" height="359" />
<img src="https://github.com/sessionm/ios-objectivec-sdk-example/raw/master/SDKIntegrationSampleImages/SMHamburger.gif" alt="SMHamburger" width="199" height="360" />

Add the follwing files found in the SDKIntegrationSample folder to your project:
 	`SMHamburger.h`
 	`SMHamburger.m`
 	`SMHamburger.xib`

Create a `SMHamburger`.
	
	#import "SMHamburger.h"

	@interface YOUR_VIEW_CONTROLLER () {
		SMHamburger *smBurger;
	}

	- (void)viewDidLoad {

		// Initialize new SMHamburdger
		smBurger = [SMHamburger new];
		smBurger.view.frame = CGRectMake(X_COORDINATE, Y_COORDINATE, smBurger.view.frame.size.width, smBurger.view.frame.size.height);
	}

	- (void)viewDidAppear:(BOOL)animated {
		[self.view addSubview: smBurger.view];
		[smBurger animate];
	}

	-(void)viewWillDisappear:(BOOL)animated {
		// OPTIONAL (REMEMBER TO RE ADD THESE BACK im viewDidAppear method of your Controller )
		[smBurger.view removeFromSuperview];

	}

## How to Deep Link into Rewards Portal Content

<img src="https://github.com/sessionm/ios-objectivec-sdk-example/raw/master/SDKIntegrationSampleImages/deepLink1.png" alt="deepLink1 Screenshot" width="200" height="359" />
<img src="https://github.com/sessionm/ios-objectivec-sdk-example/raw/master/SDKIntegrationSampleImages/deepLink2.png" alt="deepLink2 Screenshot" width="200" height="359" />
<img src="https://github.com/sessionm/ios-objectivec-sdk-example/raw/master/SDKIntegrationSampleImages/deepLink.gif" alt="deepLink" width="199" height="360" />

	// Pass The indexPath to this method or  
	// Or just call the Page type where ever you want in the code
	// [[SessionM sharedInstance] openURLForPortalPage:(enum)SMPortalPage];
	#import "SessionM.h"

	-(void) deepLinkContent: (NSIndexPath *)indexPath{
		NSDictionary *portalPageNames = @{
				[NSNumber numberWithInt:SMPortalPageHome]: @"Home Feed",
				[NSNumber numberWithInt:SMPortalPageAchievements]: @"Achievements List",
				[NSNumber numberWithInt:SMPortalPageFeatured]: @"Featured Offers",
				[NSNumber numberWithInt:SMPortalPageSweepstakes]: @"Sweepstakes",
				[NSNumber numberWithInt:SMPortalPageRewards]: @"Rewards",
				[NSNumber numberWithInt:SMPortalPageCharities]: @"Charities"
		};
		NSLog([portalPageNames objectForKey:[NSNumber numberWithInt:page]]);
		SMPortalPage page = (SMPortalPage)indexPath.item;
		[[SessionM sharedInstance] openURLForPortalPage:page];
	}

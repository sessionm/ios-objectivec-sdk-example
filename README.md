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
- [How to handle User OptOut Status to hide or show UI](#How-to-handle-User-OptOut-Status-to-hide-or-show-UI)
- [How to Deep Link into Rewards Portal Content](#how-to-deep-link-into-rewards-portal-content)
- [How to use a Multicast Delegate](#How-to-use-a-Multicast-Delegate)

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

## How to use SMHamburger Bubble

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

## How to handle User OptOut Status to hide or show UI
SessionM mPOINTS user can opt into or out of the program anytime. The SDK while doing such in Opted Out state stops communication with our service, it keeps a local state of which you can use to hide/show SessionM related UI accordingly. You can get this state from the following Boolean from the API --- [SessionM sharedInstance].user.isOptedOut

	#pragma mark - Update UI

	// UI refresh method showing how you can change UI based
	// on SessionM state or if a user has opted in or out.
	- (void)updateUI:(SessionMState)state  {
    		// Setup UI based on opt-in status
    		if ([SessionM sharedInstance].user.isOptedOut) {
        		[self updateMyViewForOptOutStatus];
   		} else {
        		[self updateMyViewForOptInStatus];
    		}

    
		// Setup UI based on if SessionM state
 		if (state == SessionMStateStartedOnline) {
    			// Set Up Stuff when Session is Online 
		} else {
        	        // Disable UI
		}
	}

Here is an Example of the use of OptIn OptOut status for `SMHamburger` and `SMNavGiftBox`

	# pragma mark - Handling SessionM OptIn OptOut
	- (void) updateMyViewForOptInStatus{
    
		// Add the SMHamburger View
		if(![smBurger.view isDescendantOfView:self.navigationController.view]) {
			[self.navigationController.view addSubview: smBurger.view];
			[smBurger animate];
		} else {
			smBurger.view.hidden = NO;
		}
    
    		// Add the SMNavGiftBox View
		if(![smNav.view isDescendantOfView:self.navigationController.view]) {
			[self.navigationController.view addSubview: smNav.view];
			[smNav animate];
		} else {
			smNav.view.hidden = NO;
		}
	}

	- (void) updateMyViewForOptOutStatus{
		[self.bigGreenButton setTitle:@"OptedOut" forState:UIControlStateNormal];
		[smBurger.view removeFromSuperview];
		[smNav.view removeFromSuperview];
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

## How to use a Multicast Delegate 

`SMMultiDelegate` is way to Handle Multiple delegate references
For example you may end up using multiple controllers on the same view, but setting
the delegate twice you may loose refrence to the first. Use a multicasting methodolgy:

        // Set the delegate so we get notified from the SDK to MutlicastDelegate instance
        // [[SessionM sharedInstance] setDelegate:[SMMulticastDelegate sharedInstance]];

       #import "SMMultiCastDelegate.h"

       @implementation YourAppDelegate

       - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
       {
         [[SessionM sharedInstance] setDelegate:[SMMulticastDelegate sharedInstance]];
         // Init the SDK
         SMStart(YOUR_APP_ID);
         return YES;
       }


       // Instead of Assigning Delegate directly to SessionM use SMMutliDelegate instead
       #import "SMMultiCastDelegate.h"

       @implementation YourViewControllers

       - (void)viewDidLoad {
         [super viewDidLoad];
    
         //[[SessionM sharedInstance] setDelegate:self];
    
         // WE USE OUR OWN CUSTOM DELEGATE MULTICASTER INSTEAD TO SHOW SOME
         // ADVANCED CAPABILITIES
         [[SMMulticastDelegate sharedInstance] addDelegate:self];
        }

SessionMSDKExample
==================
Sample project showing how to use the SessionM SDK. 

This project takes advantage of cocoapods (http://guides.cocoapods.org/using/getting-started.html) for the sake of importing the SessionM SDK.

If you do not use cocoapods in your project, download the SessionM SDK (http://www.sessionm.com/documentation/downloads.php), place the SessionM-SDK folder in your project, and be sure to link against the following frameworks: AVFoundation, EventKit, EventKitUI, CoreData, CoreMedia, MediaPlayer, AdSupport and StoreKit frameworks.

For more help see http://www.sessionm.com/documentation/index.php

#How to use Animated Gift Box

Create a `SMNavGiftBox`.

	@interface YOUR_VIEW_CONTROLLER () {
    		SMNavGiftBox *smNav;
	}	


	- (void)viewDidAppear:(BOOL)animated  {
    	
		// Gift box on Navigation bar
    		// You can use the code below to initialize the GiftBox at any other place.
    		
		[smNav.view removeFromSuperview];
    		smNav = [SMNavGiftBox new];
    		smNav.view.frame = CGRectMake(YOUR_X_COORDINATE,YOUR_Y_COORDINATE,smNav.view.frame.size.width/3, smNav.view.frame.size.height/3);
    		[self.navigationController.view addSubview: smNav.view];
    		[smNav animate];
 
	}	


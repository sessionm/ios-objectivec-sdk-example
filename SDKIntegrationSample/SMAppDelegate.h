//
//  SMAppDelegate.h
//  SDKIntegrationSample
//
//  Created by Kevin Yarmosh on 9/5/14.
//  Copyright (c) 2014 sessionm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionMUIWelcomeViewController.h"

@interface SMAppDelegate : UIResponder <UIApplicationDelegate>{
   SessionMUIWelcomeViewController *welcomeView;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSURL *pendingURL;
@end

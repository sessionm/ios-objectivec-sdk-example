//
//  SMAppDelegate.h
//  SDKIntegrationSample
//
//  Created by Kevin Yarmosh on 9/5/14.
//  Copyright (c) 2014 sessionm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionM.h"

@interface SMAppDelegate : UIResponder <UIApplicationDelegate,SessionMDelegate>{
   UIView *welcomeView;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSURL *pendingURL;
@end

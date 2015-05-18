//
//  SMMultiCastDelegate.h
//  SDKIntegrationSample
//
//  Created by Nash Gadre on 5/18/15.
//  Copyright (c) 2015 sessionm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionM.h"

// handles messages sent to delegates, multicasting these messages to multiple observers
@interface SMMulticastDelegate : NSObject<SessionMDelegate>

// Adds the given delegate implementation to the list of observers
- (void)addDelegate:(id)delegate;
+ (SMMulticastDelegate *)sharedInstance;
@end


//
//  SMCustomAchievementActivity.h
//  SDKIntegrationSample
//
//  Created by Kevin Yarmosh on 9/9/14.
//  Copyright (c) 2014 sessionm. All rights reserved.
//

#import "SessionM.h"

@interface SMCustomAchievementActivity : SMAchievementActivity
@property (nonatomic, strong) UIView *viewToPresentIn;
// presents achievement alert
- (void)present;
// dismisses achievement alert
- (void)dismiss;

@end

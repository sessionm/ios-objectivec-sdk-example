//
//  SMCustomAchievementActivity.m
//  SDKIntegrationSample
//
//  Created by Kevin Yarmosh on 9/9/14.
//  Copyright (c) 2014 sessionm. All rights reserved.
//

#import "SMCustomAchievementActivity.h"

@implementation SMCustomAchievementActivity {
    UIView *achievementView;
}

-(id)initWithAchievementData:(SMAchievementData *)theData {
    if(self = [super initWithAchievementData:theData]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

-(void)dealloc {
    // Be sure to hide any custom achievement UI that may be present upon app going to background,
    // as the acheivement will be invalid upon coming back to foreground. 
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)present {
    UIImage *achievementBackgroundImage = [UIImage imageNamed:@"alert-bar"];
    UIImageView *achievementBackgroundImageView = [[UIImageView alloc] initWithImage:achievementBackgroundImage];
    achievementBackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    achievementBackgroundImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, achievementBackgroundImageView.image.size.height);
    
    achievementView = [[UIView alloc] initWithFrame:CGRectMake(0, -achievementBackgroundImageView.frame.size.height, achievementBackgroundImageView.frame.size.width, achievementBackgroundImageView.frame.size.height)];
    [achievementView addSubview:achievementBackgroundImageView];
    
    UIImageView *leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert-icon"]];
    leftIcon.frame = CGRectMake(15, (achievementBackgroundImageView.image.size.height - leftIcon.image.size.height)/2.0f, leftIcon.image.size.width, leftIcon.image.size.height);
    [achievementView addSubview:leftIcon];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = self.data.message;;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    [achievementView addSubview:label];
    
    UIButton *claimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    claimButton.frame = achievementView.bounds;
    [claimButton addTarget:self action:@selector(claim) forControlEvents:UIControlEventTouchUpInside];
    [achievementView addSubview:claimButton];
    
    UIButton *x = [UIButton buttonWithType:UIButtonTypeCustom];
    [x setImage:[UIImage imageNamed:@"alert-x"] forState:UIControlStateNormal];
    x.contentMode = UIViewContentModeCenter;
    x.frame = CGRectMake(achievementBackgroundImageView.frame.size.width - 15 - achievementView.frame.size.height, (achievementBackgroundImageView.image.size.height - achievementView.frame.size.height)/2.0f, achievementView.frame.size.height, achievementView.frame.size.height);
    [x addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [achievementView addSubview:x];
    label.frame = CGRectMake(leftIcon.frame.origin.x + leftIcon.frame.size.width + 15, (achievementBackgroundImageView.image.size.height - label.frame.size.height)/2.0f, achievementView.frame.size.width - (leftIcon.frame.origin.x + leftIcon.frame.size.width + 15) - (achievementView.frame.size.width - x.frame.origin.x), label.frame.size.height);

    
    [self.viewToPresentIn addSubview:achievementView];
    [super notifyPresented];

    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        achievementView.frame = CGRectMake(0, 0, achievementView.frame.size.width, achievementView.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                label.text = self.data.name;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    label.text = [NSString stringWithFormat:@"%lu mPoints earned!",(unsigned long)self.data.mpointValue];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        label.text = @"Tap to claim";
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self dismiss];
                        });
                    });
                });
            });
        }
    }];
    
}

- (void)dismiss {
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        achievementView.frame = CGRectMake(0, -achievementView.frame.size.height, achievementView.frame.size.width, achievementView.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [super notifyDismissed:SMAchievementDismissTypeCanceled];
        }
    }];
}

-(void)claim {
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        achievementView.frame = CGRectMake(0, -achievementView.frame.size.height, achievementView.frame.size.width, achievementView.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            [super notifyDismissed:SMAchievementDismissTypeClaimed];
        }
    }];
}


@end

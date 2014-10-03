//
//  SessionMUITableViewCell.m
//  TMZ
//
//  Created by Nachiket Gadre on 4/24/14.
//  Copyright (c) 2014 SessionM. All rights reserved.
//

#import "SessionMUITableViewCell.h"
#import "SessionM.h"

@implementation SessionMUITableViewCell

@synthesize switchMPoints;
@synthesize unclaimedAchievementsLabel;

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (IBAction)switchHandle:(id)sender {
    BOOL optStatus = [sender isOn];
    NSString *rez = optStatus == YES ? @"Turn ON" : @"Turn OFF";
    NSLog(@"%@", [NSString stringWithFormat: @"%@%@", rez, @" SessionM Rewards"]);
    [[SessionM sharedInstance].user setIsOptedOut: !optStatus];
    [self prepareForReuse];
}

- (void)handleDisplay {
    if([SessionM sharedInstance].user.isOptedOut)
    {
        self.unclaimedAchievementsLabel.hidden = YES;
        [self.switchMPoints setOn:NO];
    }
    else {
        self.unclaimedAchievementsLabel.hidden = NO;
        [self.switchMPoints setOn:YES];
        //add a corner radius to the UILabel
        self.unclaimedAchievementsLabel.layer.cornerRadius = 11;
        if([SessionM sharedInstance].user.unclaimedAchievementCount > 0)
            self.unclaimedAchievementsLabel.text = [NSString stringWithFormat: @"%lu", (unsigned long)[SessionM sharedInstance].user.unclaimedAchievementCount];
        else
            [self.unclaimedAchievementsLabel setHidden:YES];
    }
}

@end

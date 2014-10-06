//
//  SMTableViewCell.m
//  TMZ
//
//  Created by Nachiket Gadre on 4/24/14.
//  Copyright (c) 2014 SessionM. All rights reserved.
//

#import "SMTableViewCell.h"
#import "SessionM.h"

@implementation SMTableViewCell

@synthesize switchMPoints;
@synthesize unclaimedAchievementsLabel;

- (void)prepareForReuse
{
    [super prepareForReuse];
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.292 green:0.292 blue:0.292 alpha:1];
    } else {
        self.contentView.backgroundColor = [UIColor colorWithRed:0.192 green:0.192 blue:0.192 alpha:1];
    }
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

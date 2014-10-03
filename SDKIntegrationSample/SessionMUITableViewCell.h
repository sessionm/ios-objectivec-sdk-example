//
//  SessionMUITableViewCell.h
//  TMZ
//
//  Created by Nachiket Gadre on 4/24/14.
//  Copyright (c) 2014 SessionM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionM.h"

@interface SessionMUITableViewCell  : UITableViewCell

@property (strong, nonatomic) IBOutlet UISwitch *switchMPoints;
@property (strong, nonatomic) IBOutlet UILabel* unclaimedAchievementsLabel;

-(void) handleDisplay;

@end

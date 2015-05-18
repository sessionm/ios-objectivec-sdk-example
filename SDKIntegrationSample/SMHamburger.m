//
//  SMHamburger.m
//  SessionM
//
//  Created by Nachiket Gadre on 5/22/14.
//  Copyright (c) 2014 SessionM. All rights reserved.
//

#import "SMHamburger.h"
#import "SessionM.h"

@interface SMHamburger () {
    BOOL safeToUpdate;
}

@end


@implementation SMHamburger

@synthesize circleView;
@synthesize achievementsLabel;
@synthesize imageview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,2,2)];
        imageview.image = [[UIImage imageNamed: @"m-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [imageview setTintColor:[UIColor colorWithRed:0.376 green:0.698 blue:0.059 alpha:1]];
        
        self.achievementsLabel = [[UILabel alloc] initWithFrame:CGRectMake(-4, -7, 25, 15)];
        [self.achievementsLabel  setTextColor:[[UIColor alloc]  initWithRed:201/255.f green:26/255.f blue:26/255.f alpha:1.0]];
        [self.achievementsLabel  setBackgroundColor:[UIColor clearColor]];
        [self.achievementsLabel  setFont:[UIFont fontWithName: @"Helvetica Neue" size: 17.0f]];
        
        self.achievementsLabel.text = [NSString stringWithFormat: @"%lu", (unsigned long)[SessionM sharedInstance].user.unclaimedAchievementCount];
        
        self.circleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,2,2)];
        
        
        circleView.alpha = 0.0;
        self.circleView.layer.cornerRadius = 1;
        self.circleView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:self.circleView];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) animate{
    achievementsLabel.text = @"";
    [self.circleView addSubview:imageview];
    safeToUpdate = NO;
    circleView.alpha = 0.0;
    [UIView animateWithDuration:0.2
                          delay:0.4
                        options:UIViewAnimationOptionAllowAnimatedContent // reverse back to original value
                     animations:^{
                         // scale up 10%
                         circleView.alpha = 1;
                         self.circleView.transform = CGAffineTransformMakeScale(16, 16);
                     } completion:^(BOOL finished) {
                         // restore the non-scaled state
                         if (finished)
                         [UIView animateWithDuration:0.1
                                               delay:0
                                             options:UIViewAnimationOptionAllowUserInteraction // reverse back to original value
                                          animations:^{
                                              // scale up 10%
                                              self.circleView.transform = CGAffineTransformMakeScale(13, 13);
                                          } completion:^(BOOL finished) {
                                              if (finished)
                                              [UIView animateWithDuration:0.2
                                                                    delay:2
                                                                  options:UIViewAnimationOptionAllowUserInteraction // reverse back to original value
                                                               animations:^{
                                                                   // scale down to 10%
                                                                   self.circleView.transform = CGAffineTransformMakeScale(1, 1);
                                                               } completion:^(BOOL finished) {
                                                                   if (finished)
                                                                   [UIView animateWithDuration:0.2
                                                                                         delay:0
                                                                                       options:UIViewAnimationOptionAllowUserInteraction // reverse back to original value
                                                                                    animations:^{
                                                                                        self.circleView.transform = CGAffineTransformMakeScale(12, 12);
                                                                                        if([SessionM sharedInstance].user.unclaimedAchievementCount > 0 && [SessionM sharedInstance].user.unclaimedAchievementCount < 10){                                                                                            [imageview removeFromSuperview];
                                                                                            achievementsLabel.text = [NSString stringWithFormat: @"%lu", (unsigned long)[SessionM sharedInstance].user.unclaimedAchievementCount];
                                                                                            [self.view addSubview:achievementsLabel];
                                                                                        }
                                                                                    } completion:^(BOOL finished) {
                                                                                        // restore the non-scaled state
                                                                                        if (finished) {
                                                                                            safeToUpdate = YES;
                                                                                        }
                                                                                    }];
                                                               }];
                                          }];
                     }];
}

-(void)update {
    if (!safeToUpdate) {
        return;
    }
    if([SessionM sharedInstance].user.unclaimedAchievementCount > 0 && [SessionM sharedInstance].user.unclaimedAchievementCount < 10){                                                                                            [imageview removeFromSuperview];
        achievementsLabel.text = [NSString stringWithFormat: @"%lu", (unsigned long)[SessionM sharedInstance].user.unclaimedAchievementCount];
        [self.view addSubview:achievementsLabel];
    } else {
        [self.circleView addSubview:imageview];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sessionM:(SessionM *)sessionM didUpdateUser:(SMUser *)user{
    [self update];
}

@end

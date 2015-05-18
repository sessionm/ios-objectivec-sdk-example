//
//  SMNavGiftBox.m
//  SDKIntegrationSample
//
//  Created by Nash Gadre on 5/14/15.
//  Copyright (c) 2015 sessionm. All rights reserved.
//

#import "SMNavGiftBox.h"
#import "SessionM.h"
#import "SMActivityViewController.h"

@interface SMNavGiftBox (){

    BOOL safeToUpdate;

}
@end


@implementation SMNavGiftBox

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
        
        self.achievementsLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, -7, 25, 15)];
        [self.achievementsLabel  setTextColor:[UIColor whiteColor]];
        [self.achievementsLabel  setBackgroundColor:[UIColor clearColor]];
        [self.achievementsLabel  setFont:[UIFont fontWithName: @"Helvetica Neue" size: 14.0f]];
        
        self.achievementsLabel.text = [NSString stringWithFormat: @"%lu", (unsigned long)[SessionM sharedInstance].user.unclaimedAchievementCount];
        
        self.circleView = [[UIView alloc] initWithFrame:CGRectMake(25,0,2,2)];
        
        
        circleView.alpha = 0.0;
        self.circleView.layer.cornerRadius = 1;
        self.circleView.backgroundColor = [UIColor redColor];
        
        [self.circleView addSubview:imageview];
        [self.view addSubview:self.circleView];
        
        // This is very important since Delegate will let us update the Label when the SMUser object updates
        // in the SessionM SDK
        [SessionM sharedInstance].delegate = self;
        
        
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
                         self.circleView.transform = CGAffineTransformMakeScale(14, 14);
                     } completion:^(BOOL finished) {
                         // restore the non-scaled state
                         if (finished)
                             [UIView animateWithDuration:0.1
                                                   delay:0
                                                 options:UIViewAnimationOptionAllowUserInteraction // reverse back to original value
                                              animations:^{
                                                  // scale up 10%
                                                  self.circleView.transform = CGAffineTransformMakeScale(11, 11);
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
                                                                                                    self.circleView.transform = CGAffineTransformMakeScale(10, 10);
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

- (IBAction)touchGiftBox:(id)sender {
    [[SessionM sharedInstance]presentActivity:SMActivityTypePortal];

    NSLog(@"SessionM: Tapped Gift Box");
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

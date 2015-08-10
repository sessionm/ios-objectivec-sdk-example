//
//  SMViewController.h
//  SDKIntegrationSample
//
//  Created by Kevin Yarmosh on 9/5/14.
//  Copyright (c) 2014 sessionm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionM.h"
#import "SMPortalButton.h"
#import "SMCustomAchievementActivity.h"
#import "SMContainerViewController.h"

@interface SMViewController : UIViewController <SessionMDelegate, UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    NSDictionary *portalPageNames;
    
}

@property (weak, nonatomic) IBOutlet UITableView *portalPagesTable;
@property (nonatomic, weak) IBOutlet UIButton *bigRedButton;
@property (weak, nonatomic) IBOutlet UIButton *bigPurpleButton;
@property (nonatomic, weak) IBOutlet UIButton *bigGreenButton;
@property (nonatomic, weak) IBOutlet UIButton *bigBlueButton;
@property (nonatomic, weak) IBOutlet UISwitch *memberSwitch;
@property (nonatomic, strong) SMCustomAchievementActivity *customAchievementActivity;
@property (nonatomic, strong) SMContainerViewController *containerVC;
- (IBAction)redButtonAction:(id)sender;
- (IBAction)purpleButtonAction:(id)sender;
- (IBAction)greenButtonAction:(id)sender;
- (IBAction)blueButtonAction:(id)sender;
- (IBAction)memberSwitchAction:(id)sender;

- (void)updateUI:(SessionMState)state;
- (void) updateMyViewForOptInStatus;
- (void) updateMyViewForOptOutStatus;

- (void)sessionM:(SessionM *)session didTransitionToState:(SessionMState)state;



@end
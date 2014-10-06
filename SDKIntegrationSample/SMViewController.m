//
//  SMViewController.m
//  SDKIntegrationSample
//
//  Created by Kevin Yarmosh on 9/5/14.
//  Copyright (c) 2014 sessionm. All rights reserved.
//

#import "SMViewController.h"
#import "SMCustomAchievementActivity.h"
#import "SMActivityViewController.h"
#import "SMLeftViewController.h"
#import "SMHamburger.h"

@interface SMViewController () {
    SMHamburger *smBurger;
}
@end

// See https://developer.sessionm.com/get_started
// to get your app ID as well as setup actions and achievements.
#define YOUR_APP_ID @"7a6cf3f9d1a2016efd1bb5b3a1193a22785480cb"
#define YOUR_TEST_ACTION @"red_button_tapped"
#define YOUR_TEST_ACTION2 @"purple_button_tapped"

@implementation SMViewController

-(void)viewDidAppear:(BOOL)animated  {
    [smBurger.view removeFromSuperview];
    smBurger = [SMHamburger new];
    smBurger.view.frame = CGRectMake(65, 40, smBurger.view.frame.size.width, smBurger.view.frame.size.height);
    [self.navigationController.view addSubview: smBurger.view];
    [smBurger animate];
    [self.containerVC setPanMode:MFSideMenuPanModeDefault];
}

-(void)viewWillDisappear:(BOOL)animated {
    [smBurger.view removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated {
    
    //Stylize nav bar
    CGRect rect = CGRectMake(0.0f, 0.0f, ((UIViewController*)self).navigationController.navigationBar.frame.size.width, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.376 green:0.698 blue:0.059 alpha:1] CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    ((UIViewController*)self).navigationController.navigationBar.tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    [((UIViewController*)self).navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    UIImage *logoImage = [UIImage imageNamed:@"logoWhite"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:logoImage];
    ((UIViewController*)self).navigationItem.titleView = imageView;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    // Add hamburger bar button item
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger"]
                                                                                                  style:UIBarButtonItemStyleBordered
                                                                                                 target:self
                                                                                                 action:@selector(hamburgerMenuButtonPressed:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SessionM SDK Sample";
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set the delegate so we get notified from the SDK
    [[SessionM sharedInstance] setDelegate:self];
    
    // Init the SDK
    SMStart(YOUR_APP_ID);
    
    // Create SMPortalButton - By using the SMPortalButton class, the button's tap
    // target is automagically setup for you. Just tap to open SessionM portal.
    SMPortalButton *portalButton=[SMPortalButton buttonWithType:UIButtonTypeCustom];
    [portalButton.button setImage:[UIImage imageNamed:@"gift-icon"] forState:UIControlStateNormal];
    [portalButton.button setImage:[UIImage imageNamed:@"gift-icon-selected"] forState:UIControlStateHighlighted];
    portalButton.frame = CGRectMake(20,100,portalButton.button.imageView.image.size.width,portalButton.button.imageView.image.size.height);
    portalButton.badgePosition = SMPortalButtonBadgePositionCustom;
    portalButton.badge.font = [UIFont fontWithName:@"Helvetica-Neue-Light" size:16];
    [portalButton layoutBadge];
    [self.view addSubview:portalButton];
    
    // Manually Enable / Disable Big Green Portal Button
    [self.bigGreenButton setTitle: @"Offline" forState: UIControlStateDisabled];
    [self updateUI:[SessionM sharedInstance].sessionState];
}

// Toggle showing left menu on hamburger tap.
-(void)hamburgerMenuButtonPressed:(UIBarButtonItem*)item {
    if (self.containerVC.menuState == MFSideMenuStateLeftMenuOpen) {
        [self.containerVC setMenuState:MFSideMenuStateClosed];
    } else {
        // Ensure SMLeftViewController's tableView is reloaded when opening to ensure proper badge count.
        [((SMLeftViewController*)((UINavigationController*)self.containerVC.leftMenuViewController).viewControllers[0]).tableView reloadData];
        [((SMLeftViewController*)((UINavigationController*)self.containerVC.leftMenuViewController).viewControllers[0]).tableView setContentOffset:CGPointZero];
        [self.containerVC setMenuState:MFSideMenuStateLeftMenuOpen];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Update UI

// UI refresh method showing how you can change UI based
// on SessionM state or if a user has opted in or out.
- (void)updateUI:(SessionMState)state  {
    // Setup UI based on opt-in status
    if ([SessionM sharedInstance].user.isOptedOut) {
        [self.bigGreenButton setTitle:@"OptedOut" forState:UIControlStateNormal];
    } else {
        [self.bigGreenButton setTitle:@"Portal" forState:UIControlStateNormal];
    }
    self.memberSwitch.on = ![SessionM sharedInstance].user.isOptedOut;
    
    // Setup UI based on if SessionM state
    if (state == SessionMStateStartedOnline) {
        self.bigGreenButton.enabled = YES;
    } else {
        self.bigGreenButton.enabled = NO;
    }
    
    // Setup UI based on unclaimedAchievement data. Achievement
    // must be setup as Native Display in dev portal for this
    // function properly.
    SMAchievementData *unclaimedAchievementData =
    [SessionM sharedInstance].unclaimedAchievement;
    if (unclaimedAchievementData) {
        self.bigBlueButton.hidden = NO;
    } else {
        self.bigBlueButton.hidden = YES;
    }
    
    [smBurger update];
}


#pragma mark - IBActions

// Red and purple buttons complete your test Actions. Tap the number of times required
// as specified by your test Achievement in SessionM dev portal to trigger the achievement
- (IBAction)redButtonAction:(id)sender{
    SMAction(YOUR_TEST_ACTION);
}

// Purple button's action is tied to a Native Diplay achievement. This
// means no SessionM UI will be displayed. Instead the
// [SessionM sharedInstance].unclaimedAchievement property
// will be populated with achievement data, allowing you to
// create custom UI to display the achievement.
- (IBAction)purpleButtonAction:(id)sender {
    SMAction(YOUR_TEST_ACTION2);
}

// Green button is alternate way of launching the portal.
// You could create a SMPortalButton, or just call the code
// below to launch SessionM portal.
- (IBAction)greenButtonAction:(id)sender{
    [[SessionM sharedInstance] presentActivity:SMActivityTypePortal];
}

// Blue button is example of how to claim an achievement via navite UI. Achievement
// in [SessionM sharedInstance].unclaimedAchievement will only be the most recent
// unpresented and unclaimed achievement.
- (IBAction)blueButtonAction:(id)sender{
    SMAchievementData *achievementData =
    [SessionM sharedInstance].unclaimedAchievement;
    
    // Example of showing Native UI in place of SessionM achievement UI. Here
    // we simple use a subclassed SMAchievementActivity which uses a UIAlertView,
    // but any custom view could be used, provided the notifyPresented and
    // notifyDismissed methods are called. See SMCustomAchievementActivity.m.
    self.customAchievementActivity = [[SMCustomAchievementActivity alloc] initWithAchievmentData:achievementData];
    [self.customAchievementActivity present];
}

// Switch shows example of how to toggle a user
// opting in or out of SessionM rewards.
- (IBAction)memberSwitchAction:(id)sender{
    [SessionM sharedInstance].user.isOptedOut = !self.memberSwitch.on;

    [self updateUI:[SessionM sharedInstance].sessionState];
}



#pragma mark - SMSessionDelegate

// Notifies about SessionM state transition.
- (void)sessionM: (SessionM *)session didTransitionToState: (SessionMState)state {
    [self updateUI:state];
//    NSLog(@"%u",state);
}

// Notifies that user info was updated. User info may be different from
// time SessionM state goes online, therefore important to setup this delegate as well.
- (void)sessionM:(SessionM *)sessionM didUpdateUser:(SMUser *)user {
    [self updateUI:[SessionM sharedInstance].sessionState];
}

// Refreshes UI after achievement activity dismiss.
- (void)sessionM:(SessionM *)sessionM didDismissActivity:(SMActivity *)activity {
    [self updateUI:[SessionM sharedInstance].sessionState];
}

-(void)sessionM:(SessionM *)sessionM didFailWithError:(NSError *)error {
    if (error.code == SessionMServiceUnavailable) {
        // International user and SessionM service is unavialable.
        // Here you should hide mPoints integration such as portal buttons.
    }
}

@end

//
//  SMViewController.m
//  SDKIntegrationSample
//
//  Created by Kevin Yarmosh on 9/5/14.
//  Copyright (c) 2014 sessionm. All rights reserved.
//

#import "SMAppDelegate.h"
#import "SMViewController.h"
#import "SMCustomAchievementActivity.h"
#import "SMActivityViewController.h"
#import "SessionMUIWelcomeViewController.h"
#import "SMLeftViewController.h"
#import "SMHamburger.h"
#import "SMNavGiftBox.h"
#import "SMMultiCastDelegate.h"
#import "SessionM.h"
#import <QuartzCore/QuartzCore.h>


@interface SMViewController () {
    SMHamburger *smBurger;
    SMNavGiftBox *smNav;
    UIView *welcomeView;
}
@end

// See https://developer.sessionm.com/get_started
// to get your app ID as well as setup actions and achievements.
#define YOUR_TEST_ACTION @"YOUR_TEST_ACTION"
#define YOUR_TEST_ACTION2 @"YOUR_TEST_ACTION2"
#define kIntroSeen @"com.sessionm.SessionM.introSeen"
@implementation SMViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"SessionM SDK Sample";
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set the delegate so we get notified from the SDK
    //[[SessionM sharedInstance] setDelegate:self];
    
    // WE USE OUR OWN CUSTOM DELEGATE MULTICASTER INSTEAD TO SHOW SOME
    // ADVANCED CAPABILITIES
    [[SMMulticastDelegate sharedInstance] addDelegate:self];
    
    // Create SMPortalButton - By using the SMPortalButton class, the button's tap
    // target is automagically setup for you. Just tap to open SessionM portal.
    SMPortalButton *portalButton=[SMPortalButton buttonWithType:UIButtonTypeCustom];
    [portalButton.button setImage:[UIImage imageNamed:@"gift-icon"] forState:UIControlStateNormal];
    [portalButton.button setImage:[UIImage imageNamed:@"gift-icon-selected"] forState:UIControlStateHighlighted];
    portalButton.frame = CGRectMake(20,60,portalButton.button.imageView.image.size.width,portalButton.button.imageView.image.size.height);
    portalButton.badgePosition = SMPortalButtonBadgePositionCustom;
    portalButton.badge.font = [UIFont fontWithName:@"Helvetica-Neue-Light" size:16];
    [portalButton layoutBadge];
    [self.view addSubview:portalButton];
    
    // Manually Enable / Disable Big Green Portal Button
    [self.bigGreenButton setTitle: @"Offline" forState: UIControlStateDisabled];
    [self updateUI:[SessionM sharedInstance].sessionState];
    
    // Initialize new SMNavGiftBox
    smNav = [SMNavGiftBox new];
    smNav.view.frame = CGRectMake(self.view.frame.size.width-60, 32, smNav.view.frame.size.width/3, smNav.view.frame.size.height/3);
    
    // Initialize Hamburger Style Menu
    smBurger = [SMHamburger new];
    smBurger.view.frame = CGRectMake(65, 40, smBurger.view.frame.size.width, smBurger.view.frame.size.height);
    
}

-(void)viewDidAppear:(BOOL)animated  {
    _portalPagesTable.hidden = TRUE;
    // Add Hamburger Bubble and SMNavGiftBox to the View
    [self updateUI:[SessionM sharedInstance].sessionState];
    [self.containerVC setPanMode:MFSideMenuPanModeDefault];
}

-(void)viewWillDisappear:(BOOL)animated {
    // OPTIONAL (REMEMBER TO RE ADD THESE BACK im viewDidAppear method of your Controller )
    [self updateUI:[SessionM sharedInstance].sessionState];
    smBurger.view.hidden = YES;
    smNav.view.hidden = YES;

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
    self.customAchievementActivity = [[SMCustomAchievementActivity alloc] initWithAchievementData:achievementData];
    self.customAchievementActivity.viewToPresentIn = self.view;
    [self.customAchievementActivity present];
    ((UIButton*)sender).hidden = YES;
}

// Switch shows example of how to toggle a user
// opting in or out of SessionM rewards.
- (IBAction)memberSwitchAction:(id)sender{
    [SessionM sharedInstance].user.isOptedOut = !self.memberSwitch.on;

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


#pragma mark - SMSessionDelegate

// Notifies about SessionM state transition.
- (void)sessionM: (SessionM *)session didTransitionToState: (SessionMState)state {
    [self updateUI:state];
    if (state == SessionMStateStartedOnline) {
        SMAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        if (appDelegate.pendingURL) {
            [[SessionM sharedInstance] handleURL:appDelegate.pendingURL];
            appDelegate.pendingURL = nil;
        }
    }
//    NSLog(@"%u",state);
}
- (IBAction)pressedDeepLinkBanner:(id)sender {
    // !!!!! NOTE
    // !!!!! MAKE SURE THE PROTOCOL is the following format @"sessionm" @"YOUR_API_KEY"
    // !!!!! ALSO ADD IT TO THE URLSchemes under your plist,
    // Refer Apple documentation: https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Inter-AppCommunication/Inter-AppCommunication.html
    
    portalPageNames = @{
                        [NSNumber numberWithInt:SMPortalPageHome]: @"Home Feed",
                        [NSNumber numberWithInt:SMPortalPageAchievements]: @"Achievements List",
                        [NSNumber numberWithInt:SMPortalPageFeatured]: @"Featured Offers",
                        [NSNumber numberWithInt:SMPortalPageSweepstakes]: @"Sweepstakes",
                        [NSNumber numberWithInt:SMPortalPageRewards]: @"Rewards",
                        [NSNumber numberWithInt:SMPortalPageCharities]: @"Charities"
                        };


    // border radius
    [_portalPagesTable.layer setCornerRadius:10.0f];
    
    // border
    
    _portalPagesTable.layer.borderColor = [UIColor orangeColor].CGColor;
    _portalPagesTable.layer.borderWidth = 1.5f;
    
    // drop shadow
    [_portalPagesTable.layer setShadowColor:[UIColor grayColor].CGColor];
    [_portalPagesTable.layer setShadowOpacity:0.8];
    [_portalPagesTable.layer setShadowRadius:3.0];
    [_portalPagesTable.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    _portalPagesTable.delegate = self;
    _portalPagesTable.dataSource = self;
    
    [_portalPagesTable reloadData];
    _portalPagesTable.hidden = FALSE;
    [self.view addSubview: _portalPagesTable];
    
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

#pragma mark - Update UI

// UI refresh method showing how you can change UI based
// on SessionM state or if a user has opted in or out.
- (void)updateUI:(SessionMState)state  {
    // Setup UI based on opt-in status
    if ([SessionM sharedInstance].user.isOptedOut) {
        [self updateMyViewForOptOutStatus];
    } else {
        [self updateMyViewForOptInStatus];
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
    
}



# pragma mark - Handling SessionM OptIn OptOut
-(void) updateMyViewForOptInStatus{
    [self.bigGreenButton setTitle:@"Portal" forState:UIControlStateNormal];
    
    // Add the SMHamburger View
    if(![smBurger.view isDescendantOfView:self.navigationController.view]) {
        [self.navigationController.view addSubview: smBurger.view];
        [smBurger animate];
    } else {
        smBurger.view.hidden = NO;
    }
    
    // Add the SMNavGiftBox View
    if(![smNav.view isDescendantOfView:self.navigationController.view]) {
        [self.navigationController.view addSubview: smNav.view];
        [smNav animate];
    } else {
        smNav.view.hidden = NO;
    }

}

- (void) updateMyViewForOptOutStatus{
    [self.bigGreenButton setTitle:@"OptedOut" forState:UIControlStateNormal];
    [smBurger.view removeFromSuperview];
    [smNav.view removeFromSuperview];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return portalPageNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    SMPortalPage page = (SMPortalPage)indexPath.item;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [portalPageNames objectForKey:[NSNumber numberWithInt:page]];
    cell.contentView.backgroundColor = [UIColor darkGrayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SMPortalPage page = (SMPortalPage)indexPath.item;
    [[SessionM sharedInstance] openURLForPortalPage:page];
}

@end

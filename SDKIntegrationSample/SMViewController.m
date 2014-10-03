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
#import <objc/runtime.h>

@interface SMViewController ()

@end


static IMP __view_Will_Appear_Imp;
static IMP __preferred_Status_Bar_Style;
static IMP __prefers_Status_Bar_Hidden;

// See https://developer.sessionm.com/get_started
// to get your app ID as well as setup actions and achievements.
#define YOUR_APP_ID @"7a6cf3f9d1a2016efd1bb5b3a1193a22785480cb"
#define YOUR_TEST_ACTION @"red_button_tapped"
#define YOUR_TEST_ACTION2 @"purple_button_tapped"

@implementation SMViewController

-(void)viewWillAppear:(BOOL)animated {
    ((UIViewController*)self).navigationController.navigationBar.tintColor = nil;
    [((UIViewController*)self).navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    ((UIViewController*)self).navigationItem.titleView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set the delegate so we get notified from the SDK
    [[SessionM sharedInstance] setDelegate:self];
    
    // Init the SDK
    SMStart(YOUR_APP_ID);
    
    // Create SMPortalButton - By using the SMPortalButton class, the button's tap
    // target is automagically setup for you. Just tap to open SessionM portal.
    SMPortalButton *portalButton=[SMPortalButton buttonWithType:UIButtonTypeSystem];
    [portalButton.button setTitle:@"Portal Button" forState:UIControlStateNormal];
    portalButton.frame = CGRectMake((self.view.frame.size.width-100)/2, self.bigRedButton.frame.origin.y - 40, 100, 30);
    portalButton.layer.cornerRadius = 4;
    portalButton.layer.borderColor = [UIColor blackColor].CGColor;
    portalButton.layer.borderWidth = 1;
    [self.view addSubview:portalButton];
    
    // Manually Enable / Disable Big Green Portal Button
    [self.bigGreenButton setTitle: @"Offline" forState: UIControlStateDisabled];
    [self updateUI:[SessionM sharedInstance].sessionState];
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
    
    // Example of tracking number of unclaimedAchievements on user
    SMUser *user = [SessionM sharedInstance].user;
    NSString *badgeValue = user.unclaimedAchievementCount > 0 ? [NSString stringWithFormat:@"%lu", (unsigned long)user.unclaimedAchievementCount] : nil;
    self.achievementCountLabel.text = badgeValue;
    if ([badgeValue integerValue] == 0) {
        self.achievementCountLabel.hidden = YES;
    } else {
        self.achievementCountLabel.hidden = NO;
    }
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


// Light blue button launches the portal inside your already exisiting navigation controller
- (IBAction)lightBlueButtonAction:(id)sender {
    
    // Code to overwrite what method is called when SMActivityViewController would normally call viewWillAppear:
    // We force it to instead call our _swizzle_viewWillAppear method
    Method m = class_getInstanceMethod([SMActivityViewController class], @selector(viewWillAppear:));
    __view_Will_Appear_Imp = method_setImplementation(m, (IMP)_swizzle_viewWillAppear);
    
    // Here we give SMActivityViewController a new method, which is just the old viewWilAppear,
    // allowing us to call the original viewWillAppear from our swizzle method
    NSString *newSel = [NSString stringWithFormat:@"__original_%@", NSStringFromSelector(@selector(viewWillAppear:))];
    const char *type = method_getTypeEncoding(m);
    class_addMethod([SMActivityViewController class], NSSelectorFromString(newSel), __view_Will_Appear_Imp, type);
    
    // This code overwrites the prefersStatusBarHidden method calls on SMActivityViewController with our _swizzle_prefersStatusBarHidden
    Method m2 = class_getInstanceMethod([SMActivityViewController class], @selector(prefersStatusBarHidden));
    __prefers_Status_Bar_Hidden = method_setImplementation(m2, (IMP)_swizzle_prefersStatusBarHidden);

    // This code overwrites the preferredStatusBarStyle method calls on UINavigationController with our _swizzle_preferredStatusBarStyle
    Method m3 = class_getInstanceMethod([UINavigationController class], @selector(preferredStatusBarStyle));
    __preferred_Status_Bar_Style = method_setImplementation(m3, (IMP)_swizzle_preferredStatusBarStyle);

    // Code to push SMActivityViewController onto nav stack
    SMActivityViewController *avc = [SMActivityViewController newInstanceWithActivityType:SMActivityTypePortal inNavigationController:self.navigationController];
    [self.navigationController pushViewController:avc animated:YES];
}

// Switch shows example of how to toggle a user
// opting in or out of SessionM rewards.
- (IBAction)memberSwitchAction:(id)sender{
    [SessionM sharedInstance].user.isOptedOut = !self.memberSwitch.on;

    [self updateUI:[SessionM sharedInstance].sessionState];
}

#pragma mark - Swizzled Methods
// Adds functionality to standard [SMActivityViewController viewWillAppear:animated] method
// Sets up nav bar custom appearance.
void _swizzle_viewWillAppear(id self, SEL _cmd, BOOL animated)
{
    assert([NSStringFromSelector(_cmd) isEqualToString:@"viewWillAppear:"]);
    
    // Calls standard viewWillAppear: method for SMActivityViewController
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self performSelector:@selector(__original_viewWillAppear:)];
#pragma clang diagnostic pop
    
    // Extra functionality to add to viewWillAppear: method to stylize nav and staus bars
    CGRect rect = CGRectMake(0.0f, 0.0f, ((UIViewController*)self).navigationController.navigationBar.frame.size.width, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1] CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    ((UIViewController*)self).navigationController.navigationBar.tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
    [((UIViewController*)self).navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    ((UIViewController*)self).navigationController.navigationBar.hidden = NO;
    
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:logoImage];
    ((UIViewController*)self).navigationItem.titleView = imageView;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    return;
}

// Overwrites UINavigationController preferredStatusBarStyle to give us control of style
// when transitioning to and from SMActivityViewController
UIStatusBarStyle _swizzle_preferredStatusBarStyle(id self, SEL _cmd) {
    if ([[((UINavigationController*)self).viewControllers lastObject] isKindOfClass:[SMActivityViewController class]]) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

// Overwrites SMActivityViewController prefersStatusBarHidden to give us control of style
// when transitioning to and from SMActivityViewController.
BOOL _swizzle_prefersStatusBarHidden(id self, SEL _cmd) {
    if (((SMActivityViewController*)self).navigationController) {
        return NO;
    }
    return YES;
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

//
//  SMLeftViewController.m
//  SDKIntegrationSample
//
//  Created by Kevin Yarmosh on 10/3/14.
//  Copyright (c) 2014 sessionm. All rights reserved.
//

#import "SMLeftViewController.h"
#import "SMTableViewCell.h"
#import "SMContainerViewController.h"
#import "SMActivityViewController.h"
#import <objc/runtime.h>

@interface SMLeftViewController ()

@end

@implementation SMLeftViewController

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Sets up UITableView
    CGRect frame = CGRectMake(0, self.view.frame.size.height/2 - 22.5, self.view.frame.size.width, 46);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = self.tableView.backgroundColor = [UIColor colorWithRed:0.192 green:0.192 blue:0.192 alpha:1];
    
    UIView *borderTopView = [[UIView alloc] initWithFrame:CGRectMake(15, self.tableView.frame.origin.y-1, self.containerVC.leftMenuWidth-30, 1)];
    UIView *borderBottomView = [[UIView alloc] initWithFrame:CGRectMake(15, self.tableView.frame.origin.y + self.tableView.frame.size.height, self.containerVC.leftMenuWidth-30, 1)];
    borderTopView.backgroundColor = borderBottomView.backgroundColor = [UIColor colorWithRed:0.153 green:0.153 blue:0.153 alpha:1];
    
    [self.view addSubview:borderTopView];
    [self.view addSubview:borderBottomView];
    
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
    Method m3 = class_getInstanceMethod([SMContainerViewController class], @selector(preferredStatusBarStyle));
    __preferred_Status_Bar_Style = method_setImplementation(m3, (IMP)_swizzle_preferredStatusBarStyle);

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMTableViewCell *cell = (SMTableViewCell*)[tableView dequeueReusableCellWithIdentifier:nil];
    
    if(cell == nil)
    {
        NSLog(@"Found Rewards");
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"SMTableViewCell" owner:self options:nil];
        cell = cells.lastObject;
        [cell prepareForReuse];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text =  @"Rewards";
        [cell handleDisplay];
        return cell;
    }
    else
    {
        
        [cell prepareForReuse];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Code to push SMActivityViewController onto nav stack
    SMActivityViewController *avc = [SMActivityViewController newInstanceWithActivityType:SMActivityTypePortal
                                                                   inNavigationController:((UINavigationController*)self.containerVC.centerViewController)];
    [((UINavigationController*)self.containerVC.centerViewController) pushViewController:avc animated:YES];

    [self.containerVC setMenuState:MFSideMenuStateClosed];
    [self.containerVC setPanMode:MFSideMenuPanModeNone];
}

static IMP __view_Will_Appear_Imp;
static IMP __preferred_Status_Bar_Style;
static IMP __prefers_Status_Bar_Hidden;

#pragma mark - Method Swizzling

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
    
    UIImage *logoImage = [UIImage imageNamed:@"logo"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:logoImage];
    ((UIViewController*)self).navigationItem.titleView = imageView;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    return;
}

// Overwrites UINavigationController preferredStatusBarStyle to give us control of style
// when transitioning to and from SMActivityViewController
UIStatusBarStyle _swizzle_preferredStatusBarStyle(id self, SEL _cmd) {
    if ([[((UINavigationController*)((SMContainerViewController*)self).centerViewController).viewControllers lastObject] isKindOfClass:[SMActivityViewController class]]) {
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
@end

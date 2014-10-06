//
//  SMContainerViewController.m
//  SDKIntegrationSample
//
//  Created by Kevin Yarmosh on 10/3/14.
//  Copyright (c) 2014 sessionm. All rights reserved.
//

#import "SMContainerViewController.h"
#import "SMLeftViewController.h"

@interface SMContainerViewController ()

@end

@implementation SMContainerViewController

-(id)initWithCenterViewController:(id)center andLeftViewController:(id)left {
    if (self = [super init]) {
        [super setCenterViewController:center];
        [super setLeftMenuViewController:left];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// handlePan: is default panGestureRecognizer selector for MFSideMenuContainerViewController
-(void)handlePan:(UIPanGestureRecognizer*)panGestureRecognizer {
    [super handlePan:panGestureRecognizer];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // Ensure SMLeftViewController's tableView is reloaded when opening to ensure proper badge count.
        [((SMLeftViewController*)((UINavigationController*)self.leftMenuViewController).viewControllers.firstObject).tableView reloadData];
        [((SMLeftViewController*)((UINavigationController*)self.leftMenuViewController).viewControllers.firstObject).tableView setContentOffset:CGPointZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

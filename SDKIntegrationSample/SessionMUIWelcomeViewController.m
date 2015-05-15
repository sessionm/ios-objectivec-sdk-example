//
//  SessionMUIWelcomeViewController.m
//  TMZ
//
//  Created by Grafton Daniels on 5/23/14.
//  Copyright (c) 2014 SessionM. All rights reserved.
//

#import "SessionMUIWelcomeViewController.h"

@interface SessionMUIWelcomeViewController ()

@end

@implementation SessionMUIWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.smWelcomeButton.enabled = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.view setAlpha:1.0];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

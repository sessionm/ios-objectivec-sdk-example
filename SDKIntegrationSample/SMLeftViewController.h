//
//  SMLeftViewController.h
//  SDKIntegrationSample
//
//  Created by Kevin Yarmosh on 10/3/14.
//  Copyright (c) 2014 sessionm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMContainerViewController.h"

@interface SMLeftViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) SMContainerViewController *containerVC;

@end

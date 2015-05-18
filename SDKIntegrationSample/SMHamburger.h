//
//  SMHamburger.h
//  SessionM
//
//  Created by Nachiket Gadre on 5/22/14.
//  Copyright (c) 2014 SessionM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionM.h"

@interface SMHamburger : UIViewController<SessionMDelegate>

@property(nonatomic, strong) UIView *circleView;
@property(nonatomic, strong) UILabel *achievementsLabel;
@property(nonatomic, strong) UIImageView *imageview;
@property (nonatomic) CGPoint myPoint;
-(void)animate;
-(void)update;
@end

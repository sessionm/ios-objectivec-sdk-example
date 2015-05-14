//
//  SMNavGiftBox.h
//  SDKIntegrationSample
//
//  Created by Nash Gadre on 5/14/15.
//  Copyright (c) 2015 sessionm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMNavGiftBox : UIViewController

@property(nonatomic, strong) UIView *circleView;
@property(nonatomic, strong) UILabel *achievementsLabel;
@property(nonatomic, strong) UIImageView *imageview;
@property (nonatomic) CGPoint myPoint;

-(void)animate;
-(void)update;
- (IBAction)touchGiftBox:(id)sender;

@end

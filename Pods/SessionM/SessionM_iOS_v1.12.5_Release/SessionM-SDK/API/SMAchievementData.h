//
//  SMAchievementData.h
//  SessionM 
//
//  Copyright (c) 2012 session M. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class Achievement data class.
 @abstract Defines information about achievement used to customize achievement alert presentation.
 */
@interface SMAchievementData : NSObject 
/*!
 @property name
 @abstract Achievement name.
 */
@property(nonatomic, copy, readonly) NSString *name;
/*!
 @property message
 @abstract Message describing the achievement.
 */
@property(nonatomic, copy, readonly) NSString *message;
/*!
 @property action
 @abstract Action name.
 */
@property(nonatomic, copy, readonly) NSString *action;
/*!
 @property mpointValue
 @abstract Achievement mPoint value.
 */
@property(nonatomic, readonly) NSUInteger mpointValue;
/*!
 @property achievementIconURL
 @abstract Icon URL.
 */
@property(nonatomic, copy, readonly) NSString *achievementIconURL;
/*!
 @property isCustom
 @abstract Boolean indicating if achievement presentation is custom.
 */
@property(nonatomic, readonly) BOOL isCustom;
/*!
 @property lastEarnedDate
 @abstract Date the unclaimed achievement was last earned.
 */
@property(nonatomic, readonly) NSDate *lastEarnedDate;
/*!
 @property distance
 @abstract Number of actions required to earn new achievement. -1 if achievment is unearnable in the current session. 
 */
@property(nonatomic, readonly) NSInteger distance;
@end

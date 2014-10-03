//
//  SessionM.h
//  session M
//
//  Copyright 2014 session M. All rights reserved.
//

#ifndef __SESSIONM__
#define __SESSIONM__
#define __SESSIONM_SDK_VERSION__ @"1.12.5"

#import <UIKit/UIKit.h>
#import "SMAchievementData.h"


/*!
 @defined SMStart
 @param appId Application identifier.
 @abstract Starts session.
 */
#define SMStart(appId) [[SessionM sharedInstance] startSessionWithAppID:appId];

/*!
 @defined SMAction
 @param action Action name.
 @abstract Logs action.
 */
#define SMAction(action) [[SessionM sharedInstance] logAction:action];



/*!
 @typedef SessionMState
 @abstract Session state enum.
 */
typedef enum SessionMState {
    /*! SessionM service is stopped. */
    SessionMStateStopped,
    /*! SessionM service is started and is working in online state, i.e. connected to the network. */
    SessionMStateStartedOnline,
    /*! SessionM is started and is working in offline state, i.e. without network connection. Unlike online state, some operations, e.g. activity display may not be available in this state. SessionM tries to reconnect automatically and will transition to SessionMStateStartedOnline state
     once it has successfully been able to do so. */
    SessionMStateStartedOffline
} SessionMState;



/*!
 @typedef SMActivityType
 @abstract Session M service UI activity type enum.
 */
typedef enum SMActivityType {
    /*! Achievement notification UI activity. */
    SMActivityTypeAchievement = 1,
    /*! User portal UI activity. */
    SMActivityTypePortal,
    /*! Deprecated. Session M service introduction UI activity.
     @deprecated Introduction type is deprecated. Use SMActivityTypePortal instead.
     */
    SMActivityTypeIntroduction  __attribute__((deprecated)),
    /*! Interstitial activity */
    SMActivityTypeInterstitial
} SMActivityType;



/*!
 @typedef SMActivityUserAction
 @abstract User action within Session M UI activity. Identifies events such as user engaging with achievement prompt, etc.
 */
typedef enum SMActivityUserAction {
    /*! User viewed an achievement. */
    SMAchievementViewAction = 100,
    /*! User engaged with achievement prompt. */
    SMAchievementEngagedAction = 101,
    /*! User dismissed an achievement. */
    SMAchievementDismissedAction = 102,
    /*! User viewed sponsored content. */
    SMSponsorContentViewedAction = 103,
    /*! User engaged with sponsored content. */
    SMSponsorContentEngagedAction = 104,
    /*! User dismissed sponsored content. */
    SMSponsorContentDismissedAction = 105,
    /*! User viewed a section of the user portal. */
    SMPortalViewedAction = 106,
    /*! User signed into the user portal. */
    SMSignInAction = 107,
    /*! User signed out of the user portal. */
    SMSignOutAction = 108,
    /*! User registered in the user portal. */
    SMRegisteredAction = 109,
    /*! User dismissed the portal. */
    SMPortalDismissedAction = 110,
    /*! User claimed a reward. */
    SMRedeemedRewardAction = 111,
    /*! User checked into a mPlaces location. Action dictionary data includes properties with the following keys: venue - venue name, lat - latitude, long - longitude, distance - distance from venue in meters. */
    SMCheckinCompletedAction = 112,
    /*! Virtual item reward. Action dictionary data includes properties with the following keys: name - reward name, # - reward amount, token - ad ID. */    
    SMVirtualItemRewardAction = 113
} SMActivityUserAction;



/*!
 @typedef SMActivityAutoDismissStyle
 @abstract Activity auto dismiss style.
 */
typedef enum SMActivityAutoDismissStyle {
    /*! Activity is automatically dismissed when application is backgrounded. This is the default. */
    SMActivityAutoDismissStyleBackground, 
    /*! Activity is automatically dismissed when application loses focus which may be due to temporary interruptions such as notification or system alert or application backgrounding. */ 
    SMActivityAutoDismissStyleResignActive
} SMActivityAutoDismissStyle;



/*!
 @typedef SMServiceRegion
 @abstract SessionM service region.
 */
typedef enum SMServiceRegion {
    SMServiceRegionJapan,
    SMServiceRegionUSA
} SMServiceRegion;



/*!
 @const SessionMErrorDomain
 @abstract SessionM error domain.
 */
extern NSString * const SessionMErrorDomain;

/*!
 @typedef SessionMSessionErrorType
 @abstract SessionM service error type.
 */
typedef enum SessionMSessionErrorType {
    /*! Indicates that Session M service is not available, i.e. denied by SessionM service. */
    SessionMServiceUnavailable = 100,
    /*! Deprecated. Indicates that user is ineligible for Session M service
     * NOTE: Deprecated. SessionMServiceUnavailable code should be used instead.
     */
    SessionMIneligibleError = 101,
    /*! Indicates invalid application ID */
    SessionMInvalidAppIdError = 102
} SessionMSessionErrorType;



@class SessionM;
@class SMActivity;
@class SMUser;

/*!
 @protocol SessionMDelegate
 @abstract @link SessionM @/link service delegate interface.
 @discussion Defines notifications about session state changes, UI activity and other @link SessionM @/link service events.
 */
@protocol SessionMDelegate <NSObject> 

@optional

/*!
 @abstract Notifies about @link SessionM @/link state transition.
 @param sessionM SessionM service object.
 @param state SessionM state.
 */
- (void)sessionM:(SessionM *)sessionM didTransitionToState:(SessionMState)state;
/*!
 @abstract Notifies that @link SessionM @/link service is permanently unavailable.
 @discussion This method indicates permanent failure to start SessionM service. This can be the case when invalid application ID is supplied by the application or when SessionM service is not available in current device locale or
 session has been refused for security or other reasons. Application should use this method to remove or disable SessionM related UI elements. 
 @param sessionM SessionM service object.
 @param error Error object.
 */
- (void)sessionM:(SessionM *)sessionM didFailWithError:(NSError *)error;
/*!
 @abstract Indicates if newly earned achievement UI activity should be presented.
 @discussion This method is called when achievement is earned and will occur when application calls @link logAction: @/link or starts a session.
 By default, SessionM displays the achievement UI immediately after it is earned. Application can customize this behavior to defer the display until appropriate application state is reached.
 @param sessionM SessionM service object.
 @param achievement Achievement data object.
 @result Boolean indicating if achievement activity should be presented.
 */
- (BOOL)sessionM:(SessionM *)sessionM shouldAutopresentAchievement:(SMAchievementData *)achievement;
/*!
 @abstract Returns UIView to use as a superview for SessionM view objects. 
 @param sessionM SessionM service object.
 @param type Activity type.
 @result UIView object.
 */
- (UIView *)sessionM:(SessionM *)session viewForActivity:(SMActivityType)type;
/*!
 @abstract Returns UIViewController to use as a presenting controller for SessionM view controller.
 @discussion This method is only called when application's root view controller is nil. In this case SessionM tries to determine appropriate view controller in the view hierarchy to use as a 'presenting controller'. 
 This method provides a mechanism for the application to explicitely specify which view controller should be used in this case. It is recommended that application implement this method when root view controller is not set.
 Note, that UIViewController based presentation is only applicable for full screen activities, e.g. user portal.
 @param sessionM SessionM service object.
 @param type Activity type.
 @result UIViewController object.
 */
 - (UIViewController *)sessionM:(SessionM *)session viewControllerForActivity:(SMActivityType)type;
/*!
 @abstract Notifies that UI activity will be presented.
 @param sessionM SessionM service object.
 @param activity Activity object.
 */
- (void)sessionM:(SessionM *)sessionM willPresentActivity:(SMActivity *)activity;
/*!
 @abstract Notifies that UI activity was presented.
 @param sessionM SessionM service object.
 @param activity Activity object.
 */
- (void)sessionM:(SessionM *)sessionM didPresentActivity:(SMActivity *)activity;
/*!
 @abstract Notifies that UI activity will be dismissed.
 @param sessionM SessionM service object.
 @param activity Activity object.
 */
- (void)sessionM:(SessionM *)sessionM willDismissActivity:(SMActivity *)activity;
/*!
 @abstract Notifies that UI activity was dismissed.
 @param sessionM SessionM service object.
 @param activity Activity object.
 */
- (void)sessionM:(SessionM *)sessionM didDismissActivity:(SMActivity *)activity;
/*!
 @abstract Notifies that user info was updated.
 @discussion User info is updated when earned achievement count, opt out status or other user relevant state changes. 
 @param sessionM SessionM service object.
 @param user User object.
 */
- (void)sessionM:(SessionM *)sessionM didUpdateUser:(SMUser *)user;
/*!
 @abstract Notifies that media (typically video) will start playing.
 @discussion Application should use this method to suspend its own media playback if any.
 @param sessionM SessionM service object.
 @param activity Activity object.
 */
- (void)sessionM:(SessionM *)sessionM willStartPlayingMediaForActivity:(SMActivity *)activity;
/*!
 @abstract Notifies that media (typically video) finished playing
 @discussion Application should use this method to resume its own media playback if any.
 @param sessionM SessionM service object.
 @param activity Activity object.
 */
- (void)sessionM:(SessionM *)sessionM didFinishPlayingMediaForActivity:(SMActivity *)activity;
/*!
 @abstract Notifies that user performed an action in currently presented UI activity.
 @param sessionM SessionM service object.
 @param user User object.
 @param action User action type. 
 @param activity Activity object.
 @param data NSDictionary object with action specific data.
 */
- (void)sessionM:(SessionM *)sessionM user:(SMUser *)user didPerformAction:(SMActivityUserAction)action forActivity:(SMActivity *)activity withData:(NSDictionary *)data;
/*!
 * @abstract Returns center point to use when presenting built-in achievement alert UIView.
 * @discussion Application can use this method to refine the positioning of achievement alert UIView. The default layout is specified in the developer portal as part of achievement configuration. 
 * However, this method provides additional flexibility if application interface is dynamic and requires adjustments to alert positioning in order to ensure it does not cover important UI elements. 
 * @param sessionM SessionM service object.
 * @param activity Activity object.
 * @param size Activity UIView size.
 * @result CGPoint UIView center.
 */
- (CGPoint)sessionM:(SessionM *)sessionM centerForActivity:(SMActivity *)activity withSize:(CGSize)size;



/*!
 @abstract Deprecated. Notifies that UI activity is not available for presentation.
 @discussion This method is called in response to @link presentActivity: @/link call when activity of specified type cannot be presented.
 @param sessionM SessionM service object.
 @param type Activity type.
 @deprecated This method is deprecated. Use boolean value returned from @link presentActivity: @/link as an indicator if activity will be presented or not.
 */
- (void)sessionM:(SessionM *)sessionM activityUnavailable:(SMActivityType)type __attribute__((deprecated));
/*!
 @abstract Deprecated. Notifies that unclaimed achievement is available or not, if nil, for presentation.
 @discussion This method should be used by application to customize an achievement presentation. SessionM service invokes this method when new achievement is earned or to notify about one of the previously earned
 unclaimed achievements. Achievement object supplied by this method is also available via SessionM @link unclaimedAchievement @/link property.
 This notification, in conjunction with @link unclaimedAchievement @/link property, allows application to present user achievements at convenient time during application lifecycle.
 @param sessionM SessionM service object.
 @param achievement Achievement data object or nil if no unclaimed achievement is available.
 @deprecated This method is deprecated. Use @link sessionM:shouldAutopresentAchievement: @/link to get notified about new achievements.
 */
- (void)sessionM:(SessionM *)sessionM didUpdateUnclaimedAchievement:(SMAchievementData *)achievement __attribute__((deprecated));
/*!
 @abstract Deprecated. Indicates if newly earned achievement UI activity should be presented.
 @param sessionM SessionM service object.
 @param type Activity type.
 @result Boolean indicating if achievement activity should be presented.
 @deprecated This method is deprecated - use @link sessionM:shouldAutopresentAchievement: @/link instead.
 */
- (BOOL)sessionM:(SessionM *)sessionM shouldAutopresentActivity:(SMActivityType)type __attribute__((deprecated));

@end



/*!
 @typedef SMLogLevel
 @abstract Log level.
 */
typedef enum SMLogLevel {
    /*! Disables logging. */
    SMLogLevelOff,
    /*! Enables logging of key API events such as action logging, achievement display, etc. */
    SMLogLevelInfo,
    /*! Enables logging of detailed information about SDK operations such as, for example, network activity in addition to basic API tracing. This level should be used when diagnosing SDK integration problems. */
    SMLogLevelDebug
} SMLogLevel;


/*!
 @typedef SMLogCategory
 @abstract Log category.
 */
typedef enum SMLogCategory {
    /*! All categories */
    SMLogCategoryAll = 0xFF,
    /*! API */
    SMLogCategoryAPI = 0x01,
    /*! UI */
    SMLogCategoryUI = 0x02,
    /*! Network */
    SMLogCategoryNetwork = 0x04,
    /*! Session */
    SMLogCategorySession = 0x08,
    /*! CPI */
    SMLogCategoryCPI = 0x10
} SMLogCategory;


/*!
 @typedef SMLocationCoordinate2D
 @abstract Location coordinate enum.
 */
typedef struct SMLocationCoordinate2D {
	double latitude;
	double longitude;
} SMLocationCoordinate2D; 



/*!
 @class SessionM
 @abstract Session M service interface. This is main class in Session M iOS SDK. It defines methods for all main operations such logging an action and displaying an achievement or a user portal, etc. 
 
 <b>Basic API usage</b>

 Following is the simplest way of integrating SessionM service within your application code. It assumes that you have registered your application in Session M developer portal and configured achievements. 
 <ol>
 <li>Start the service by calling @link SMStart @/link macro.</li>
 <li>Log action in appropriate places in your code log user action by calling @link SMAction @/link. When new achievement is earned it will be displayed automatically using the style chosen in the developer portal.</li>
 </ol>
 
 When minimal API described before is not sufficient application can obtain SessionM instance by calling @link sharedInstance @/link and, optionally, implementing and registering @link SessionMDelegate @/link instance. 
 
 For example, to override automatic achievement display do the following:
 <ol>
 <li>Implement @link SessionMDelegate @/link and, specifically, @link sessionM:shouldAutopresentAchievement: @/link method to get notified that new achievement is earned and is ready for display. Return NO to suppress achievement display.</li>
 <li>At appropriate place in your application call @link presentActivity: @/link to display the achievement UI.</li>
 </ol>
 
 <b>UI Activity</b>

 Application user engages with SessionM service via UI activity or flow. UI activity starts with an initial view which can be partial- (e.g. achievement alert) or full-screen (e.g. user portal). 
 A UI activity can be comprised on multiple views. Partial-screen view can transition to full-screen view.
 
 Application is notified by SessionM UI display by implementing the following methods of @link SessionMDelegate @/link: @link sessionM:willPresentActivity: @/link, @link sessionM:didPresentActivity: @/link, @link sessionM:willDismissActivity: @/link and @link sessionM:didDismissActivity: @/link.
 
 To present the UI SessionM adds its UIView and/or UIViewControllers to application's view and view controller hierarchy. By default, the following algorithm is to find appropriate superview or presenting controller:
 <ol>
 <li>Traverse UIViewController chain starting with root view controller and, if set, find top-most UIViewController object.</li>
 <li>If view controller cannot be determined in step 1, iterate through UIWindow subviews finding the top-most visible UIView. If not found, use key UIWindow object.</li>
 </ol>
 When SessionM presents a UIView it adds it to the UIView found in steps above. When SessionM presents a UIViewController it uses the controller found in step 1 or, if not available, adds its view to the view found in step 2.
 
 Application can instruct SessionM to use specific view and controller objects by implementing the following @link SessionMDelegate @/link methods: @link sessionM:viewForActivity: @/link and @link sessionM:viewControllerForActivity: @/link.

 Special consideration is taken when presenting SessionM UI activity when keyboard is displayed - the activity display is delayed until keyboard is dismissed. This applies to both when activity is auto-presented as a result of action logging or
 when application is explicitly presenting it by invoking @link presentActivity: @/link method.
 
 <b>Achievement UI Customization</b>
 
 Application can customize achievement presentation to suit its style and UI flow by implementing the following steps:
 <ol>
 <li>Configure achievements as "custom" in the development portal</li>
 <li>Obtain an achievement data object by calling @link unclaimedAchievement @/link property and, optionally, implementing @link sessionM:didUpdateUnclaimedAchievement: @/link delegate method to get notified about available achievements.</li>
 <li>Extend @link SMAchievementActivity @/link class or use its instance as a callback object in conjunction with @link SMAchievementData @/link object to present the achievement UI and notify SessionM about relevant lifecycle events.</li>
 </ol>
 
 For more information about using custom achievement API see Development Guide. 
 
 <b>Session state</b>

 SessionM service, once started, is operational regardless of whether network connection is available or not. In online (connected) state the activity UI is available for display.
 In offline (disconnected) state actions logged through the service are captured but UI is not available. Upon re-connection the actions are synchronized with SessionM service.
 Application can be notified by SessionM state transitions via @link sessionM:didTransitionToState: @/link delegate callbacks.
 SessionM service is stopped when application is backgrounded and re-started upon foregrounding.

 <b>Threading</b>

 Almost all SessionM API methods are asynchronous. Implement and register @link SessionMDelegate @/link to get notified about the outcome of the method calls and other SessionM service events.
 Delegate calls are made on the main thread.

 <b>Location capture</b>

 To capture the location information you will need to start CCLocationManager and register for its notifications as described in Apple Location Awareness Programming Guide.
 As part of location notification processing update SessionM @link locationCoordinate @/link property.

 <b>Logging</b>
 
 To diagnose problems and ensure proper SDK integration SessionM service implements basic logging which can be controlled using @link logLevel @/link property. For basic output capturing all major SDK events use @link SMLogLevelInfo @/link level. 
 For more detailed, low level output use @link SMLogLevelDebug @/link level. 
 It is highly recommended to capture and provide debug output when reporting a problem Session M technical support.
*/

@interface SessionM : NSObject 

/*!
 @property delegate
 @abstract SessionMDelegate object.
 */
@property(nonatomic, assign) id<SessionMDelegate> delegate;
/*!
 @property sessionState
 @abstract SessionM state.
 */
@property(nonatomic,readonly) SessionMState sessionState;
/*!
 @property currentActivity
 @abstract Current UI activity.
 */
@property(nonatomic, readonly) SMActivity *currentActivity;
/*!
 @property activityAutoDismissStyle
 @abstract Auto-dismiss style.
 */
@property(nonatomic) SMActivityAutoDismissStyle activityAutoDismissStyle;
/*!
 @property logLevel
 @abstract Log level.
 */
@property(nonatomic) SMLogLevel logLevel;
/*!
 @property logCategory
 @abstract Log category.
 */
@property(nonatomic) int logCategories;

/*!
 @property displayInAppWelcomeFlow
 @abstract when to display in-app welcome flow
 */
@property(nonatomic) NSInteger displayInAppWelcomeFlow;
/*!
 @property inAppPromotionTile
 @abstract in-app promotion tile.
 */
@property(nonatomic, retain, readwrite) NSDictionary *inAppPromotionTile;
/*!
 @property locationCoordinate
 @abstract Location coordinate info.
 */
@property(nonatomic) SMLocationCoordinate2D locationCoordinate;
/*!
 @property user
 @abstract User object.
 */
@property(nonatomic, readonly) SMUser *user;
/*!
 @property operationQueue
 @abstract Operation queue to use to perform SDK work on.
 @discussion By default SDK creates internal operation queue to perform its work on. Application can use this property to supply its own operation queue object. This can be useful in cases when application allocates
 a queue to perform certain types of background operations by its own components or 3rd party SDK in order to manage resources more efficiently. SessionM SDK sets maxConcurrentOperationCount property of supplied operation queue to 1. 
 Note that setting this property only takes effect when SDK is in SessionMStateStopped state.
 */
@property(nonatomic, retain) NSOperationQueue *operationQueue;
/*!
 @property unclaimedAchievement
 @abstract Last earned unclaimed achievement object or nil if not available.  
 */
@property(nonatomic, readonly) SMAchievementData *unclaimedAchievement;
/*!
 @property sessionCount
 @abstract Number of sessions started by the app.
 */
@property(nonatomic, readonly) NSInteger sessionCount;
/* *** Note: this is an experimental feauture subject to change ***

 An array of NSDictionary objects; the rewards that can be redeemed through the user portal

 Key - Value type:
 type - NSString
 id - NSNumber
 name - NSString
 points - NSNumber
 image - NSString
 url - NSString
 */
@property(nonatomic, readonly) NSArray *rewards;
/*!
 @abstract Returns singleton SessionM service instance. If the server is not supported on the current platform (as indicated by isSupportedPlatform method) nil is returned.
 @result SessionM service object.
 */
+ (SessionM *)sharedInstance;
/*!
 @abstract Returns YES if session M SDK supports this platform or OS version, NO - otherwise.
 @discussion Application can examine this property to determine if SessionM service is available on its platform. Currently, SessionM service is fully functional on iOS 6.0 and later.
 On older OS SessionM service is a no-op, i.e. methods can still safely be called but they do not do anything.
 @result Boolean indicating if platform is supported.
 */
+ (BOOL)isSupportedPlatform;
/*!
 @abstract Starts session with specified application ID. 
 @discussion This method is executed asynchronously with outcome communicated via @link sessionM:didTransitionToState: @/link or @link sessionM:didFailWithError: @/link delegate callbacks. 
 This method should be called as early as possible in the application lifecycle, typically in application:didFinishLaunchingWithOptions: method of UIApplicationDelegate, after setServiceRegion: has been called.
 @param appId Application identifier. The identifier is generated when application is registered in the developer portal.
 */
- (void)startSessionWithAppID:(NSString *)appId;
/*!
 @abstract Indicates if UI activity is available for presentation.
 @param type Activity type.
 @result Boolean indicating if activity available for presentation, false - otherwise
 */
- (BOOL)isActivityAvailable:(SMActivityType)type;
/*!
 @abstract Presents activity of specified type. e.g. user portal or achievement.
 @discussion If activity is not available the @link SessionMDelegate @/link method @link sessionM:activityUnavailable: @/link is called to notify the application. An activity may not be available for display when, for example, session is in @link SessionMStateStartedOffline @/link state or, in case of achievement, the new achievement has not been earned. 
 When presenting an achievement this should be used in conjunction with delegate method @link sessionM:shouldAutopresentAchievement: @/link returning NO to control the timing of achievement presentation.
 Activity is presented using UIViewController or UIView as determined by Session M service. If activity has already been presented at a time of this call this method does nothing.
 If an activity is already presented this method cancels new activity display, notifies application via @link sessionM:activityUnavailable: @/link and returns. 
 When new activity does get presented the delegate methods @link sessionM:willPresentActivity: @/link and @link sessionM:didPresentActivity: @/link will be invoked if implemented.
 @param type Activity type.
 @result Boolean indicating if activity will be presented, false - otherwise
 */
- (BOOL)presentActivity:(SMActivityType)type;
/*!
 @abstract Dismisses currently presented activity.
 @discussion Delegate methods @link sessionM:willDismissActivity: @/link and @link sessionM:didDismissActivity: @/link will be invoked if implemented.
 */
- (void)dismissActivity;
/*!
 @abstract Logs action and presents an achievement activity if new achievement is earned.
 @discussion If new achievement is earned as a result of the action delegate method @link sessionM:shouldAutopresentAchievement: @/link, if implemented, is called to determine if achievement alert should be presented.
 @param action Action name.
 */
- (void)logAction:(NSString *)action;
/*!
 @abstract Logs specified number of actions and presents an achievement activity if new achievement is earned.
 @discussion If activity becomes available as a result of the action delegate method @link sessionM:shouldAutopresentActivity: @/link, if implemented, is called to determine if activity should be presented.
 @param action Action name.
 @param count Number of actions
 */
- (void)logAction:(NSString *)action withCount:(NSUInteger)count;
/*!
 @abstract Sends meta data to SessionM. 
 @discussion Please refer to the documentation for more information on common keys. Data should only be supplied in accordance with your applications terms of service and privacy policy.
 @param data Meta data value.
 @param key Meta data key.
 */
- (void)setMetaData:(NSString *)data forKey:(NSString *)key;
/*!
 @abstract Sets the SessionM service region.
 @discussion This method should be called in the application:didFinishLaunchingWithOptions: method of UIApplicationDelegatethe, before calling startSessionWithAppID:.
 @param region The service region.
 */
- (void)setServiceRegion:(SMServiceRegion)region;
/*!
 @abstract Handles application launch URL.
 @discussion Application can be configured to launch SessionM portal using application URL scheme mechanism. In order to enable this follow the steps:
 <ol>
 <li>Add to your application configuration plist the URL scheme in the form 'sessionmYourAppId://portal' where YourAppId is your application ID</li>
 <li>In application delegate method @link application:openURL:sourceApplication:annotation: @/link add a call handleURL to SessionM instance and pass the URL the application delegate call</li>
 </ol>
 @param url App launch URL.
 @result Boolean indicating if URL was handled by SessionM
 */
- (BOOL)handleURL:(NSURL *)url;


/*!
 @abstract Deprecated. Logs application error and/or exception.
 @discussion This method should be used as part of application exception handling logic, for example, in uncaught exception handler implementation (see NSSetUncaughtExceptionHandler in Apple developer documentation).
 @param errorName Error name.
 @param message Error message.
 @param exception Exception object.
 @deprecated This method is deprecated. 
 */
- (void)logError:(NSString *)errorName message:(NSString *)message exception:(NSException *)exception __attribute__((deprecated));

/*!
 *** Note: this is an experimental feauture subject to change ***
 @abstract Enrolls user into SessionM rewards program with specified email and (optional) year of birth.
 @discussion This method should be used by a developer to enroll a user into the SessionM rewards program if the developer wants to require the user to have an account for their own service before being able to receive rewards.
 Application should call this method only after the user has created the required account.
 @param email User's login email.
 @param yob User's year of birth. Should be in the format XXXX (e.g. 1976). Years of birth that put the user's age below 14 or above 120 years old are considered invalid. This parameter is optional, so a nil value is valid.
 @result BOOL Returns NO if email or year of birth is invalid, and YES otherwise.
 */
- (BOOL)enrollWithEmail:(NSString *)email YOB:(NSString *)yob;

@end



/*!
 @class SMActivity
 @abstract UI activity presented by SessionM service such as achievement alert, user portal, etc.
 */
@interface SMActivity : NSObject

/*!
 @property activityType
 @abstract Activity type.
 */
@property(nonatomic, readonly) SMActivityType activityType;

@end



/*!
 @typedef SMAchievementDismissType
 @abstract Custom achievement dismiss type.
 */
typedef enum SMAchievementDismissType {
    /*! Achievement is claimed */
    SMAchievementDismissTypeClaimed,
    /*! Achievement is not claimed */
    SMAchievementDismissTypeCanceled
} SMAchievementDismissType;


/*!
 @class SMAchievementActivity
 @abstract Custom achievement activity.
 @discussion Custom achievement activity class should be used when customizing achievement alert presentation. 
 The class defines callback interface which application should use to communicate back to SessionM service events such as achievement presentation, claim and dismissal. Applications can subclass this class or use the instance directly as part of its custom achievement UI implementation.
 Application must observe the following rules when using this class:
 <ol>
 <li>This class can only be used for custom achievement presentation. Achievements are marked as 'custom' in the developer portal.</li>
 <li>Application can only present one achievement UI alert at a a time.</li>
 <li>Application must call @link notifyPresented @/link once achievement alert UI is displayed.</li>
 <li>Application must call @link notifyDismissed: @/link with argument @link SMAchievementDismissTypeCanceled @/link when user does not engage with the achievement</li>
 <li>Application must call @link notifyDismissed: @/link with argument @link SMAchievementDismissTypeClaimed @/link when user engages with the achievement. After calling this method application must remove an achievement alert and allow SessionM to display achievement claim UI flow.</li>
 </ol>
 */
@interface SMAchievementActivity : SMActivity

/*!
 @property data
 @abstract Achievement data object.
 */
@property(nonatomic, retain, readonly) SMAchievementData *data;
/*!
 @abstract Initializes achievement activity object with achievement data.
 @param data Custom achievement data object.
 */
- (id)initWithAchievmentData:(SMAchievementData *)data;
/*!
 @abstract Notifies that achievement alert has been presented.
 @result Boolean indicating if invocation was successful, YES, or not - NO.
 */
- (BOOL)notifyPresented;
/*!
 @abstract Notifies that achievement alert has been dismissed. 
 @param dismissType Reason for dismissal.
 @result Boolean indicating if invocation was successful, YES, or not - NO.
 */
- (BOOL)notifyDismissed:(SMAchievementDismissType)dismissType;

@end



/*!
 @class SMUser
 @abstract Provides information about user such as unclaimed achievement count, point balance, opt out status, etc.
 @discussion When user data is changed as a result of user earning a new achievement or opting out of the program @link SessionMDelegate @/link method @link sessionM:didUpdateUser: @/link is called to notify the application about this event.
 */
@interface SMUser : NSObject

/*!
 @property isOptedOut
 @abstract Returns or sets user opt out status.
 @discussion Use this property to programmatically opt-in or opt-out user or query for this status. When opted out tha application can still log actions
 but they would not trigger an achievement display. User portal can still be presented in opted out state and users can opt in into the propgram from it.
 */
@property(nonatomic) BOOL isOptedOut;
/*!
 @property pointBalance
 @abstract Returns user's current points balance.
 */
@property(nonatomic, readonly) NSUInteger pointBalance;
/*!
 @property unclaimedAchievementCount
 @abstract Returns user's unclaimed achievement count.
 */
@property(nonatomic, readonly) NSUInteger unclaimedAchievementCount;
/*!
 @property unclaimedAchievementValue
 @abstract Returns user's unclaimed achievement value.
 */
@property(nonatomic, readonly) NSUInteger unclaimedAchievementValue;
/*!
 @property achievements
 @abstract Returns an array of @link SMAchievementData @/link objects.
 */
@property(nonatomic, retain, readonly) NSArray *achievements;

@end



/*!
 @group Session M Notifications
 */

/*!
 @const SMSessionMDidTransitionToStateNotification
 @abstract This notification is sent when session changes its session state.
 */
extern NSString *const SMSessionMDidTransitionToStateNotification;
/*!
 @const SMSessionMStateNotificationKey
 @abstract Key for accessing the state in the userInfo dictionary. State is sent as an NSNumber.
 */
extern NSString *const SMSessionMStateNotificationKey;
/*!
 @const SMSessionMDidUpdateUserInfoNotification
 @abstract This notification is sent when the session m unclaimed achievement count changes.
 */
extern NSString *const SMSessionMDidUpdateUserInfoNotification;



/*!
 @group User action meta data keys
 */

/*!
 @const SMUserActionAchievementNameKey
 @abstract Achievement name key.
 */
extern NSString *const SMUserActionAchievementNameKey;
/*!
 @const SMUserActionSponsorContentNameKey
 @abstract Sponsor content name key.
 */
extern NSString *const SMUserActionSponsorContentNameKey;
/*!
 @const SMUserActionPageNameKey
 @abstract User portal page name key.
 */
extern NSString *const SMUserActionPageNameKey;
/*!
 @const SMUserActionRewardNameKey
 @abstract Reward name key.
 */
extern NSString *const SMUserActionRewardNameKey;


#endif /* __SESSIONM__ */

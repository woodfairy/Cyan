#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <MediaRemote/MediaRemote.h>

HBPreferences* preferences;

extern BOOL enabled;
extern BOOL enableLockscreenSection;
extern BOOL enableHomescreenSection;
extern BOOL enableControlCenterSection;

UIImage* currentArtwork;
UIImageView* lsArtworkBackgroundImageView;
UIImageView* hsArtworkBackgroundImageView;
UIImageView* lspArtworkBackgroundImageView;
UIImageView* ccArtworkBackgroundImageView;
UIImageView* ccmArtworkBackgroundImageView;
UIImageView* musicArtworkBackgroundImageView;
UIVisualEffectView* lsBlurView;
UIBlurEffect* lsBlur;
UIVisualEffectView* hsBlurView;
UIBlurEffect* hsBlur;
UIVisualEffectView* lspBlurView;
UIBlurEffect* lspBlur;
UIVisualEffectView* ccBlurView;
UIBlurEffect* ccBlur;

// Lockscreen
BOOL lockscreenArtworkBackgroundSwitch = NO;
NSString* lockscreenArtworkBlurMode = @"0";
NSString* lockscreenArtworkOpacityValue = @"1.0";
BOOL lockscreenPlayerArtworkBackgroundSwitch = NO;
NSString* lockscreenPlayerArtworkBlurMode = @"0";
NSString* lockscreenPlayerArtworkOpacityValue = @"1.0";
NSString* lockscreenPlayerArtworkCornerRadiusValue = @"10.0";
BOOL hideLockscreenPlayerBackgroundSwitch = NO;
BOOL roundLockScreenCompatibilitySwitch = NO;
BOOL hideXenHTMLWidgetsSwitch = NO;

// Homescreen
BOOL homescreenArtworkBackgroundSwitch = NO;
NSString* homescreenArtworkBlurMode = @"0";
NSString* homescreenArtworkOpacityValue = @"1.0";
BOOL zoomedViewSwitch = YES;

// Control Center
BOOL controlCenterArtworkBackgroundSwitch = NO;
NSString* controlCenterArtworkBlurMode = @"0";
NSString* controlCenterArtworkOpacityValue = @"1.0";
BOOL controlCenterModuleArtworkBackgroundSwitch = NO;
NSString* controlCenterModuleArtworkOpacityValue = @"1.0";
NSString* controlCenterModuleArtworkCornerRadiusValue = @"20.0";

@interface CSCoverSheetViewController : UIViewController
@end

@interface MRPlatterViewController : UIViewController
@property(nonatomic, copy)NSString* label;
- (void)setMaterialViewBackground;
- (void)clearMaterialViewBackground;
@end

@interface MTMaterialView : UIView
@end

@interface CABackdropLayer : CALayer
@property(assign)double scale;
- (void)mt_setColorMatrixDrivenOpacity:(double)arg1 removingIfIdentity:(BOOL)arg2;
@end

@interface MTMaterialLayer : CABackdropLayer
@end

@interface UIView (Violet)
@property(nonatomic, assign, readwrite)MTMaterialView* backgroundMaterialView;
@end

@interface SBIconController : UIViewController
@end

@interface CCUIModularControlCenterOverlayViewController : UIViewController
@end

@interface CCUIContentModuleContainerViewController : UIViewController
@property(nonatomic, retain)UIViewController* contentViewController;
- (NSString *)moduleIdentifier;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPaused;
- (BOOL)isPlaying;
@end

@interface XENHWidgetLayerContainerView : UIView
@end
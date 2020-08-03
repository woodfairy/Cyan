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
UIImageView* musicArtworkBackgroundImageView;
UIVisualEffectView* lsBlurView;
UIBlurEffect* lsBlur;
UIVisualEffectView* hsBlurView;
UIBlurEffect* hsBlur;
UIVisualEffectView* lspBlurView;
UIBlurEffect* lspBlur;

// Lockscreen
BOOL lockscreenArtworkBackgroundSwitch = NO;
NSString* lockscreenArtworkBlurMode = @"0";
NSString* lockscreenArtworkOpacityValue = @"1.0";
BOOL lockscreenPlayerArtworkBackgroundSwitch = NO;
NSString* lockscreenPlayerArtworkBlurMode = @"0";
NSString* lockscreenPlayerArtworkOpacityValue = @"1.0";
NSString* lockscreenPlayerArtworkCornerRadiusValue = @"10.0";
BOOL hideLockscreenPlayerBackgroundSwitch = NO;
BOOL roundLockScreenCompatibilitySwitch = YES;

// Homescreen
BOOL homescreenArtworkBackgroundSwitch = NO;
NSString* homescreenArtworkBlurMode = @"0";
NSString* homescreenArtworkOpacityValue = @"1.0";
BOOL coverEntireHomescreenSwitch = YES;

// Control Center
BOOL controlCenterArtworkBackgroundSwitch = NO;
NSString* controlCenterArtworkOpacityValue = @"1.0";
NSString* controlCenterArtworkCornerRadiusValue = @"20.0";

@interface TimeControl : UISlider
@end

@interface ContextualActionsButton : UIButton
@end

@interface _TtCC16MusicApplication32NowPlayingControlsViewController12VolumeSlider : UISlider
@end

@interface MusicNowPlayingControlsViewController : UIViewController
@end

@interface MPRouteButton : UIButton
@end

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

@interface CCUIContentModuleContainerViewController : UIViewController
- (NSString *)moduleIdentifier;
@property(nonatomic, retain)UIViewController* contentViewController;
@end
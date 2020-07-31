#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <MediaRemote/MediaRemote.h>

HBPreferences* preferences;

extern BOOL enabled;
extern BOOL enableMusicApplicationSection;
extern BOOL enableLockscreenSection;
extern BOOL enableHomescreenSection;
extern BOOL enableControlCenterSection;

UIImage* currentArtwork;
UIImageView* lsArtworkBackgroundImageView;
UIImageView* hsArtworkBackgroundImageView;
UIImageView* lspArtworkBackgroundImageView;
UIImageView* ccArtworkBackgroundImageView;
UIVisualEffectView* lsBlurView;
UIBlurEffect* lsBlur;
UIVisualEffectView* hsBlurView;
UIBlurEffect* hsBlur;
UIVisualEffectView* lspBlurView;
UIBlurEffect* lspBlur;

// Now Playing Elements
BOOL hideGrabberViewSwitch = NO;
BOOL hideArtworkViewSwitch = NO;
BOOL hideTimeControlSwitch = NO;
BOOL hideKnobViewSwitch = NO;
BOOL hideElapsedTimeLabelSwitch = NO;
BOOL hideRemainingTimeLabelSwitch = NO;
BOOL hideContextualActionsButtonSwitch = NO;
BOOL hideVolumeSliderSwitch = NO;
BOOL hideMinImageSwitch = NO;
BOOL hideMaxImageSwitch = NO;
BOOL hideTitleLabelSwitch = NO;
BOOL hideSubtitleButtonSwitch = NO;
BOOL hideLyricsButtonSwitch = NO;
BOOL hideRouteButtonSwitch = NO;
BOOL hideRouteLabelSwitch = NO;
BOOL hideQueueButtonSwitch = NO;

// Lockscreen
BOOL lockscreenArtworkBackgroundSwitch = NO;
NSString* lockscreenArtworkBlurMode = @"0";
NSString* lockscreenArtworkOpacityValue = @"1.0";
BOOL lockscreenPlayerArtworkBackgroundSwitch = NO;
NSString* lockscreenPlayerArtworkBlurMode = @"0";
NSString* lockscreenPlayerArtworkOpacityValue = @"1.0";
NSString* lockscreenPlayerArtworkCornerRadiusValue = @"0.0";
BOOL hideLockscreenPlayerBackgroundSwitch = NO;
BOOL hideCSRoutingButtonSwitch = NO;
BOOL hideCSTimeControlSwitch = NO;
BOOL hideCSElapsedTimeLabelSwitch = NO;
BOOL hideCSRemainingTimeLabelSwitch = NO;
BOOL hideCSMediaControlsSwitch = NO;
BOOL hideCSVolumeSliderSwitch = NO;
BOOL roundLockScreenCompatibilitySwitch = NO;

// Homescreen
BOOL homescreenArtworkBackgroundSwitch = NO;
NSString* homescreenArtworkBlurMode = @"0";
NSString* homescreenArtworkOpacityValue = @"1.0";
BOOL coverEntireHomescreenSwitch = NO;

// Control Center
BOOL controlCenterArtworkBackgroundSwitch = NO;
NSString* controlCenterArtworkBlurMode = @"0";
NSString* controlCenterArtworkCornerRadiusValue = @"0.0";

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

@interface SBDashBoardViewController : UIViewController
@end

@interface CSAdjunctItemView : UIView
@end

@interface MediaControlsRoutingButtonView : UIView
@end

@interface MediaControlsTimeControl : UISlider
@end

@interface MediaControlsTransportStackView : UIView
@end

@interface MediaControlsVolumeSlider : UISlider
@end

@interface MTMaterialView : UIView
@end

@interface UIView (Violet)
@property(nonatomic, assign, readwrite)MTMaterialView* backgroundMaterialView;
@end

@interface SBIconController : UIViewController
@end

@interface CCUIContentModuleContainerViewController : UIViewController
- (NSString *)moduleIdentifier;
@end
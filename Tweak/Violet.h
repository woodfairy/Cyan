#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <MediaRemote/MediaRemote.h>

HBPreferences* preferences;

extern BOOL enabled;
extern BOOL enableMusicApplicationSection;
extern BOOL enableLockscreenSection;
extern BOOL enableHomescreenSection;

UIImageView* lsArtworkBackgroundImageView;
UIImageView* hsArtworkBackgroundImageView;
UIImageView* musicArtworkBackgroundImageView;
UIImage* currentArtwork;
UIVisualEffectView* lsBlurView;
UIBlurEffect* lsBlur;
UIVisualEffectView* hsBlurView;
UIBlurEffect* hsBlur;

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
BOOL hideCSRoutingButtonSwitch = NO;
BOOL hideCSTimeControlSwitch = NO;
BOOL hideCSElapsedTimeLabelSwitch = NO;
BOOL hideCSRemainingTimeLabelSwitch = NO;
BOOL hideCSMediaControlsSwitch = NO;
BOOL hideCSVolumeSliderSwitch = NO;

// Homescreen
BOOL homescreenArtworkBackgroundSwitch = NO;
NSString* homescreenArtworkBlurMode = @"0";

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

@interface MediaControlsRoutingButtonView : UIView
@end

@interface MediaControlsTimeControl : UISlider
@end

@interface MediaControlsTransportStackView : UIView
@end

@interface MediaControlsVolumeSlider : UISlider
@end

@interface SBIconController : UIViewController
@end
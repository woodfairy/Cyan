#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <MediaRemote/MediaRemote.h>

HBPreferences* preferences;

extern BOOL enabled;
extern BOOL enableMusicApplicationSection;
extern BOOL enableLockscreenSection;

UIImageView* lsArtworkBackgroundImageView;
UIImageView* musicArtworkBackgroundImageView;
UIImage* currentArtwork;

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
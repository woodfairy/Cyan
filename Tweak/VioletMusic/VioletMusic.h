#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <MediaRemote/MediaRemote.h>

HBPreferences* preferences;

extern BOOL enabled;
extern BOOL enableMusicApplicationSection;

UIImage* currentArtwork;
UIImageView* musicArtworkBackgroundImageView;
UIVisualEffectView* musicBlurView;
UIBlurEffect* musicBlur;
UIView* musicDimView;

UIView* theTransportView;

// Music
BOOL musicArtworkBackgroundSwitch = NO;
NSString* musicArtworkBlurMode = @"0";
NSString* musicArtworkBlurAmountValue = @"1.0";
NSString* musicArtworkOpacityValue = @"1.0";
NSString* musicArtworkDimValue = @"0.0";
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

@interface MusicNowPlayingControlsViewController : UIViewController
- (void)setArtwork;
@end

@interface _TtCC16MusicApplication29NowPlayingQueueViewController14CollectionView : UIView
@end

@interface TimeControl : UISlider
@end

@interface ContextualActionsButton : UIButton
@end

@interface TransportView : UIView
@end

@interface _TtCC16MusicApplication32NowPlayingControlsViewController12VolumeSlider : UISlider
@end

@interface MPRouteButton : UIButton
@end
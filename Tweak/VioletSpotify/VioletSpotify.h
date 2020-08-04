#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <MediaRemote/MediaRemote.h>

HBPreferences* preferences;

extern BOOL enabled;
extern BOOL enableSpotifyApplicationSection;

UIImage* currentArtwork;
UIImageView* spotifyArtworkBackgroundImageView;
UIVisualEffectView* spotifyBlurView;
UIBlurEffect* spotifyBlur;

// Spotify
BOOL spotifyArtworkBackgroundSwitch = NO;
NSString* spotifyArtworkBlurMode = @"0";
NSString* spotifyArtworkOpacityValue = @"1.0";

@interface SPTNowPlayingBackgroundViewController : UIViewController
- (void)setArtwork;
@end
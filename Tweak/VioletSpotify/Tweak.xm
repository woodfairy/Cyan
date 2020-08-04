#import "VioletSpotify.h"

BOOL enabled;
BOOL enableSpotifyApplicationSection;

// Spotify Application

%group VioletSpotify

%hook SPTNowPlayingViewController

%new
- (void)setArtwork { // get and set the artwork

	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
		NSDictionary* dict = (__bridge NSDictionary *)information;
		if (dict) {
			if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
				currentArtwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
				if (currentArtwork) {
					if (spotifyArtworkBackgroundSwitch) {
						[spotifyArtworkBackgroundImageView setImage:currentArtwork];
						[spotifyArtworkBackgroundImageView setHidden:NO];
						if ([spotifyArtworkBlurMode intValue] != 0) [spotifyBlurView setHidden:NO];
					}
				}
			}
      	}
  	});

}

- (void)viewDidLoad { // add artwork background

	%orig;

	if (!spotifyArtworkBackgroundSwitch) return;
	if (!spotifyArtworkBackgroundImageView) spotifyArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	[spotifyArtworkBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[spotifyArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[spotifyArtworkBackgroundImageView setHidden:NO];
	[spotifyArtworkBackgroundImageView setClipsToBounds:YES];
	[spotifyArtworkBackgroundImageView setAlpha:[spotifyArtworkOpacityValue doubleValue]];

	if ([spotifyArtworkBlurMode intValue] != 0) {
		if (!spotifyBlur) {
			if ([spotifyArtworkBlurMode intValue] == 1)
				spotifyBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			else if ([spotifyArtworkBlurMode intValue] == 2)
				spotifyBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			spotifyBlurView = [[UIVisualEffectView alloc] initWithEffect:spotifyBlur];
			[spotifyBlurView setFrame:spotifyArtworkBackgroundImageView.bounds];
			[spotifyBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[spotifyBlurView setClipsToBounds:YES];
			[spotifyArtworkBackgroundImageView addSubview:spotifyBlurView];
		}
		[spotifyBlurView setHidden:NO];
	}

	if (![spotifyArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:spotifyArtworkBackgroundImageView atIndex:0];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setArtwork) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil]; // add notification to dynamically change artwork

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.violetpreferences"];

    [preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	[preferences registerBool:&enableSpotifyApplicationSection default:nil forKey:@"EnableSpotifyApplicationSection"];

	// Spotify
	[preferences registerBool:&spotifyArtworkBackgroundSwitch default:NO forKey:@"spotifyArtworkBackground"];
	[preferences registerObject:&spotifyArtworkBlurMode default:@"0" forKey:@"spotifyArtworkBlur"];
	[preferences registerObject:&spotifyArtworkOpacityValue default:@"1.0" forKey:@"spotifyArtworkOpacity"];

	if (enabled) {
		if (enableSpotifyApplicationSection) %init(VioletSpotify);
		return;
    }

}
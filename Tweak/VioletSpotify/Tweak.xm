#import "VioletSpotify.h"

BOOL enabled;
BOOL enableSpotifyApplicationSection;

// Spotify Application

%group VioletSpotify

%hook SPTNowPlayingViewController

%new
- (void)setArtwork { // get and set the artwork

	if (!spotifyArtworkBackgroundSwitch) return;
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
		NSDictionary* dict = (__bridge NSDictionary *)information;
		if (dict) {
			if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
				currentArtwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
				if (currentArtwork) {
					[spotifyArtworkBackgroundImageView setImage:currentArtwork];
					[spotifyArtworkBackgroundImageView setHidden:NO];
					if ([spotifyArtworkBlurMode intValue] != 0) [spotifyBlurView setHidden:NO];
				}
			}
      	}
  	});

}

- (void)viewDidLoad { // add artwork background

	%orig;

	if (!spotifyArtworkBackgroundSwitch) return;
	if (!spotifyArtworkBackgroundImageView) spotifyArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
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
			[spotifyBlurView setFrame:[spotifyArtworkBackgroundImageView bounds]];
			[spotifyBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[spotifyBlurView setClipsToBounds:YES];
			[spotifyArtworkBackgroundImageView addSubview:spotifyBlurView];
		}
		[spotifyBlurView setHidden:NO];
	}

	if (![spotifyArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:spotifyArtworkBackgroundImageView atIndex:0];

	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setArtwork) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil]; // add notification to dynamically change artwork

}

- (void)viewWillAppear:(BOOL)animated {

	%orig;

	[self setArtwork];

}

%end

%hook SPTNowPlayingCoverArtCell

- (void)didMoveToWindow { // hide artwork

	%orig;

	if (hideArtworkSwitch)
		[self setHidden:YES];

}

%end

%hook SPTNowPlayingNextTrackButton

- (void)didMoveToWindow { // hide next track button

	%orig;

	if (hideNextTrackButtonSwitch)
		[self setHidden:YES];

}

%end

%hook SPTNowPlayingPreviousTrackButton

- (void)didMoveToWindow { // hide previous track button

	%orig;

	if (hidePreviousTrackButtonSwitch)
		[self setHidden:YES];

}

%end

%hook SPTNowPlayingPlayButtonV2

- (void)didMoveToWindow { // hide play/pause button

	%orig;

	if (hidePlayButtonSwitch)
		[self setHidden:YES];

}

%end

%hook SPTNowPlayingShuffleButton

- (void)didMoveToWindow { // hide shuffle button

	%orig;

	if (hideShuffleButtonSwitch)
		[self setHidden:YES];

}

%end

%hook SPTNowPlayingRepeatButton

- (void)didMoveToWindow { // hide repeat button

	%orig;

	if (hideRepeatButtonSwitch)
		[self setHidden:YES];

}

%end

%hook SPTGaiaDevicesAvailableViewImplementation

- (void)didMoveToWindow { // hide devices button

	%orig;

	if (hideDevicesButtonSwitch)
		[self setHidden:YES];

}

%end

%hook SPTNowPlayingQueueButton

- (void)didMoveToWindow { // hide queue button

	%orig;

	if (hideDevicesButtonSwitch)
		[self setHidden:YES];

}

%end

%hook SPTNowPlayingSliderV2

- (void)didMoveToWindow { // hide time slider

	%orig;

	if (hideTimeSliderSwitch)
		[self setHidden:YES];

}

%end

%hook SPTNowPlayingDurationViewV2

- (void)didMoveToWindow { // hide remaining and elapsed time label

	%orig;

	if (hideRemainingTimeLabelSwitch) {
		UILabel* remainingTimeLabel = MSHookIvar<UILabel *>(self, "_timeRemainingLabel");
		[remainingTimeLabel setHidden:YES];
	}

	if (hideElapsedTimeLabelSwitch) {
		UILabel* elapsedTimeLabel = MSHookIvar<UILabel *>(self, "_timeTakenLabel");
		[elapsedTimeLabel setHidden:YES];
	}

}

%end

%hook SPTNowPlayingAnimatedLikeButton

- (void)didMoveToWindow { // hide like button

	%orig;

	if (hideLikeButtonSwitch)
		[self setHidden:YES];

}

%end

%hook SPTNowPlayingTitleButton

- (void)didMoveToWindow { // hide back button

	%orig;

	if (hideBackButtonSwitch)
		[self setHidden:YES];

}

%end

%hook SPTContextMenuAccessoryButton

- (void)didMoveToWindow { // hide context button

	%orig;

	if (hideContextButtonSwitch)
		[self setHidden:YES];

}

%end

%hook SPTNowPlayingNavigationBarViewV2

- (void)didMoveToWindow { // hide playlist title

	%orig;

	if (hidePlaylistTitleSwitch) {
		SPTNowPlayingMarqueeLabel* title = MSHookIvar<SPTNowPlayingMarqueeLabel *>(self, "_titleLabel");
		[title setHidden:YES];
	}

}

%end

%hook SPTNowPlayingMarqueeLabel

- (void)didMoveToWindow { // hide song title, artist name, playlist title

	%orig;

	if (hideSongTitleSwitch) {
		UILabel* songTitle = MSHookIvar<UILabel *>(self, "_label");
		[songTitle setHidden:YES];
	}

}

%end

%hook SPTCanvasNowPlayingContentLayerCellCollectionViewCell

- (void)didMoveToWindow { // hide canvas

	%orig;

	if (hideCanvasSwitch)
		[self setHidden:YES];

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
	[preferences registerBool:&hideArtworkSwitch default:NO forKey:@"hideArtwork"];
	[preferences registerBool:&hideNextTrackButtonSwitch default:NO forKey:@"hideNextTrackButton"];
	[preferences registerBool:&hidePreviousTrackButtonSwitch default:NO forKey:@"hidePreviousTrackButton"];
	[preferences registerBool:&hidePlayButtonSwitch default:NO forKey:@"hidePlayButton"];
	[preferences registerBool:&hideShuffleButtonSwitch default:NO forKey:@"hideShuffleButton"];
	[preferences registerBool:&hideRepeatButtonSwitch default:NO forKey:@"hideRepeatButton"];
	[preferences registerBool:&hideDevicesButtonSwitch default:NO forKey:@"hideDevicesButton"];
	[preferences registerBool:&hideQueueButtonSwitch default:NO forKey:@"hideQueueButton"];
	[preferences registerBool:&hideSongTitleSwitch default:NO forKey:@"hideSongTitle"];
	[preferences registerBool:&hideTimeSliderSwitch default:NO forKey:@"hideTimeSlider"];
	[preferences registerBool:&hideRemainingTimeLabelSwitch default:NO forKey:@"hideRemainingTimeLabel"];
	[preferences registerBool:&hideElapsedTimeLabelSwitch default:NO forKey:@"hideElapsedTimeLabel"];
	[preferences registerBool:&hideLikeButtonSwitch default:NO forKey:@"hideLikeButton"];
	[preferences registerBool:&hideBackButtonSwitch default:NO forKey:@"hideBackButton"];
	[preferences registerBool:&hideContextButtonSwitch default:NO forKey:@"hideContextButton"];
	[preferences registerBool:&hidePlaylistTitleSwitch default:NO forKey:@"hidePlaylistTitle"];
	[preferences registerBool:&hideCanvasSwitch default:NO forKey:@"hideCanvas"];

	if (enabled) {
		if (enableSpotifyApplicationSection) %init(VioletSpotify);
		return;
    }

}
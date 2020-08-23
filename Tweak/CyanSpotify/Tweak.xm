#import "CyanSpotify.h"

BOOL enabled;
BOOL enableSpotifyApplicationSection;

// Spotify Application

%group CyanSpotify

%hook MPNowPlayingInfoCenter

- (void)setNowPlayingInfo:(id)arg1 { // post notification to dynamically change artwork
	
	%orig;

	[[NSNotificationCenter defaultCenter] postNotificationName:@"Cyan-setSpotifyArtwork" object:nil];

}

%end

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
					spotifyArtworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];
					if(spotifyMetalBackgroundView && spotifyArtworkCatalog) [spotifyMetalBackgroundView setBackgroundArtworkCatalog:spotifyArtworkCatalog];
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

	// Metal Lyrics Background
	NSString *path = @"/Library/Frameworks/CyanFrameworks/MusicApplication.framework";
	NSLog(@"%@", path);
	//[[NSBundle bundleWithPath:path] load];

	if(currentArtwork && !spotifyArtworkCatalog)
		spotifyArtworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];
			
	if(!spotifyMetalBackgroundView)
		spotifyMetalBackgroundView = [%c(MusicLyricsBackgroundView) new];

	if(spotifyArtworkCatalog)
		[spotifyMetalBackgroundView setBackgroundArtworkCatalog:spotifyArtworkCatalog];

	[spotifyMetalBackgroundView setFrame:[spotifyArtworkBackgroundImageView bounds]];
	[spotifyMetalBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[spotifyMetalBackgroundView setClipsToBounds:YES];

	// add metal background as subview
	if(![spotifyMetalBackgroundView isDescendantOfView:spotifyArtworkBackgroundImageView])
		[spotifyArtworkBackgroundImageView addSubview:spotifyMetalBackgroundView];

	if (![spotifyArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:spotifyArtworkBackgroundImageView atIndex:0];

	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setArtwork) name:@"Cyan-setSpotifyArtwork" object:nil]; // add notification observer to dynamically change artwork

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

	preferences = [[HBPreferences alloc] initWithIdentifier:@"0xcc.woodfairy.cyanpreferences"];

    [preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	[preferences registerBool:&enableSpotifyApplicationSection default:nil forKey:@"EnableSpotifyApplicationSection"];

	// Spotify
	[preferences registerBool:&spotifyArtworkBackgroundSwitch default:NO forKey:@"spotifyArtworkBackground"];
	[preferences registerObject:&spotifyArtworkBlurMode default:@"0" forKey:@"spotifyArtworkBlur"];
	[preferences registerObject:&spotifyArtworkBlurAmountValue default:@"1.0" forKey:@"spotifyArtworkBlurAmount"];
	[preferences registerObject:&spotifyArtworkOpacityValue default:@"1.0" forKey:@"spotifyArtworkOpacity"];
	[preferences registerObject:&spotifyArtworkDimValue default:@"0.0" forKey:@"spotifyArtworkDim"];
	[preferences registerBool:&hideArtworkSwitch default:NO forKey:@"spotifyHideArtwork"];
	[preferences registerBool:&hideNextTrackButtonSwitch default:NO forKey:@"spotifyHideNextTrackButton"];
	[preferences registerBool:&hidePreviousTrackButtonSwitch default:NO forKey:@"spotifyHidePreviousTrackButton"];
	[preferences registerBool:&hidePlayButtonSwitch default:NO forKey:@"spotifyHidePlayButton"];
	[preferences registerBool:&hideShuffleButtonSwitch default:NO forKey:@"spotifyHideShuffleButton"];
	[preferences registerBool:&hideRepeatButtonSwitch default:NO forKey:@"spotifyHideRepeatButton"];
	[preferences registerBool:&hideDevicesButtonSwitch default:NO forKey:@"spotifyHideDevicesButton"];
	[preferences registerBool:&hideQueueButtonSwitch default:NO forKey:@"spotifyHideQueueButton"];
	[preferences registerBool:&hideSongTitleSwitch default:NO forKey:@"spotifyHideSongTitle"];
	[preferences registerBool:&hideTimeSliderSwitch default:NO forKey:@"spotifyHideTimeSlider"];
	[preferences registerBool:&hideRemainingTimeLabelSwitch default:NO forKey:@"spotifyHideRemainingTimeLabel"];
	[preferences registerBool:&hideElapsedTimeLabelSwitch default:NO forKey:@"spotifyHideElapsedTimeLabel"];
	[preferences registerBool:&hideLikeButtonSwitch default:NO forKey:@"spotifyHideLikeButton"];
	[preferences registerBool:&hideBackButtonSwitch default:NO forKey:@"spotifyHideBackButton"];
	[preferences registerBool:&hideContextButtonSwitch default:NO forKey:@"spotifyHideContextButton"];
	[preferences registerBool:&hidePlaylistTitleSwitch default:NO forKey:@"spotifyHidePlaylistTitle"];
	[preferences registerBool:&hideCanvasSwitch default:NO forKey:@"spotifyHideCanvas"];

	if (enabled) {
		if (enableSpotifyApplicationSection) %init(CyanSpotify);
		return;
    }

}
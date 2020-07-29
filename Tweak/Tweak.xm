#import "Violet.h"

BOOL enabled;
BOOL enableMusicApplicationSection;
BOOL enableLockscreenSection;
BOOL enableHomescreenSection;

// Music Application

%group VioletMusicApplication

%hook ArtworkView

- (void)didMoveToWindow { // hide artwork

	%orig;

	if (hideArtworkViewSwitch)
		[self setHidden:YES];

}

%end

%hook TimeControl

- (void)didMoveToWindow { // hide time slider elements

	%orig;

	if (hideTimeControlSwitch)
		[self setHidden:YES];

	UIView* knob = MSHookIvar<UIView *>(self, "knobView");
	UILabel* elapsedLabel = MSHookIvar<UILabel *>(self, "elapsedTimeLabel");
	UILabel* remainingLabel = MSHookIvar<UILabel *>(self, "remainingTimeLabel");

	if (hideKnobViewSwitch)
		[knob setHidden:YES];

	if (hideElapsedTimeLabelSwitch)
		[elapsedLabel setHidden:YES];
		
	if (hideRemainingTimeLabelSwitch)
		[remainingLabel setHidden:YES];

}

%end

%hook ContextualActionsButton

- (void)didMoveToWindow { // hide airplay button

	%orig;

	if (hideContextualActionsButtonSwitch)
		[self setHidden:YES];

}

%end

%hook _TtCC16MusicApplication32NowPlayingControlsViewController12VolumeSlider

- (void)didMoveToWindow { // hide volume slider elements

	%orig;

	if (hideVolumeSliderSwitch)
		[self setHidden:YES];
	
	UIImageView* minImage = MSHookIvar<UIImageView *>(self, "_minValueImageView");
	UIImageView* maxImage = MSHookIvar<UIImageView *>(self, "_maxValueImageView");

	if (hideMinImageSwitch)
		[minImage setHidden:YES];

	if (hideMaxImageSwitch)
		[maxImage setHidden:YES];

}

%end

%hook MusicNowPlayingControlsViewController

- (void)viewDidLoad { // hide other elements and add artwork background (broken)

	%orig;

	UIView* grabber = MSHookIvar<UIView *>(self, "grabberView");
	UILabel* titleLabel = MSHookIvar<UILabel *>(self, "titleLabel");
	UIButton* subtitleButton = MSHookIvar<UIButton *>(self, "subtitleButton");
	MPRouteButton* lyricsButton = MSHookIvar<MPRouteButton *>(self, "lyricsButton");
	MPRouteButton* routeButton = MSHookIvar<MPRouteButton *>(self, "routeButton");
	UILabel* routeLabel = MSHookIvar<UILabel *>(self, "routeLabel");
	MPRouteButton* queueButton = MSHookIvar<MPRouteButton *>(self, "queueButton");

	if (hideLyricsButtonSwitch)
		[lyricsButton setHidden:YES];

	if (hideRouteButtonSwitch)
		[routeButton setHidden:YES];

	if (hideRouteLabelSwitch)
		[routeLabel setHidden:YES];

	if (hideQueueButtonSwitch)
		[queueButton setHidden:YES];

	if (hideTitleLabelSwitch)
		[titleLabel setHidden:YES];
	
	if (hideSubtitleButtonSwitch)
		[subtitleButton setHidden:YES];

	if (hideGrabberViewSwitch)
		[grabber setHidden:YES];

	// if (!musicArtworkBackgroundImageView) musicArtworkBackgroundImageView = [[UIImageView alloc] init];
	// [musicArtworkBackgroundImageView setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
	// [musicArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	// [musicArtworkBackgroundImageView setHidden:NO];

	// if (![musicArtworkBackgroundImageView isDescendantOfView:[self view]])
	// 	[[self view] insertSubview:musicArtworkBackgroundImageView atIndex:4];

}

%end

%end

// Lockscreen

%group VioletLockscreen

%hook CSCoverSheetViewController

- (void)viewDidLoad { // add artwork background view

	%orig;

	if (!lockscreenArtworkBackgroundSwitch) return;
	if (!lsArtworkBackgroundImageView) lsArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
	[lsArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[lsArtworkBackgroundImageView setHidden:YES];

	if ([lockscreenArtworkBlurMode intValue] != 0) {
		UIBlurEffect* blur;
		if ([lockscreenArtworkBlurMode intValue] == 1)
			blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		else if ([lockscreenArtworkBlurMode intValue] == 2)
			blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		UIVisualEffectView* blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
		[blurView setFrame:lsArtworkBackgroundImageView.bounds];
		[lsArtworkBackgroundImageView addSubview:blurView];
	}

	if (![lsArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:lsArtworkBackgroundImageView atIndex:0];

}

%end

%hook MediaControlsRoutingButtonView

- (void)didMoveToWindow { // hide airplay button

	%orig;

	if (hideCSRoutingButtonSwitch)
		[self setHidden:YES];

}

%end

%hook MediaControlsTimeControl

- (void)didMoveToWindow { // hide time slider

	%orig;

	if (hideCSTimeControlSwitch)
		[self setHidden:YES];

}

- (void)layoutSubviews { // hide timer slider elements

	%orig;

	UILabel* csElapsedTimeLabel = MSHookIvar<UILabel *>(self, "_elapsedTimeLabel");
	UILabel* csRemainingTimeLabel = MSHookIvar<UILabel *>(self, "_remainingTimeLabel");

	if (hideCSElapsedTimeLabelSwitch)
		[csElapsedTimeLabel setHidden:YES];
	
	if (hideCSRemainingTimeLabelSwitch)
		[csRemainingTimeLabel setHidden:YES];

}

%end

%hook MediaControlsContainerView

- (void)didMoveToWindow {// hide media controls

	%orig;

	MediaControlsTransportStackView* mediaControls = MSHookIvar<MediaControlsTransportStackView *>(self, "_transportStackView");

	if (hideCSMediaControlsSwitch)
		[mediaControls setHidden:YES];

}

%end

%hook MediaControlsVolumeSlider

- (void)didMoveToWindow { // hide volume slider

	%orig;

	if (hideCSVolumeSliderSwitch)
		[self setHidden:YES];

}

%end

%end

%group VioletHomescreen

%hook SBIconController

- (void)viewWillAppear:(BOOL)animated {

	%orig;

	if (!homescreenArtworkBackgroundSwitch) return;
	if (!hsArtworkBackgroundImageView) hsArtworkBackgroundImageView = [[UIImageView alloc] init];
	[hsArtworkBackgroundImageView setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
	[hsArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	if ([[%c(SBMediaController) sharedInstance] isPlaying])
		[hsArtworkBackgroundImageView setHidden:NO];
	else
		[hsArtworkBackgroundImageView setHidden:YES];

	if ([homescreenArtworkBlurMode intValue] != 0) {
		UIBlurEffect* blur;
		if ([homescreenArtworkBlurMode intValue] == 1)
			blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		else if ([homescreenArtworkBlurMode intValue] == 2)
			blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
		UIVisualEffectView* blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
		[blurView setFrame:hsArtworkBackgroundImageView.bounds];
		[hsArtworkBackgroundImageView addSubview:blurView];
	}

	if (![hsArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:hsArtworkBackgroundImageView atIndex:0];

}

%end

%end

// Others

%group VioletOthers

%hook SBMediaController

- (void)setNowPlayingInfo:(id)arg1 { // get and set the artwork

    %orig;

	// if (!lockscreenArtworkBackgroundSwitch) return;
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        NSDictionary* dict = (__bridge NSDictionary *)information;
        if (dict) {
            if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
				currentArtwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
				if (currentArtwork) {
					[lsArtworkBackgroundImageView setImage:currentArtwork];
					[lsArtworkBackgroundImageView setHidden:NO];
					[musicArtworkBackgroundImageView setImage:currentArtwork];
					[musicArtworkBackgroundImageView setHidden:NO];
					[hsArtworkBackgroundImageView setImage:currentArtwork];
					[hsArtworkBackgroundImageView setHidden:NO];
				}
			}
        }
    });
    
}

- (void)_setNowPlayingApplication:(id)arg1 { // hide background artwork when now playing app was closed

	%orig;

	[lsArtworkBackgroundImageView setHidden:YES];
	[hsArtworkBackgroundImageView setHidden:YES];
	[musicArtworkBackgroundImageView setHidden:YES];

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.violetpreferences"];

    [preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	[preferences registerBool:&enableMusicApplicationSection default:nil forKey:@"EnableMusicApplicationSection"];
	[preferences registerBool:&enableLockscreenSection default:nil forKey:@"EnableLockscreenSection"];
	[preferences registerBool:&enableHomescreenSection default:nil forKey:@"EnableHomescreenSection"];

	// Now Playing Elements
	[preferences registerBool:&hideGrabberViewSwitch default:NO forKey:@"hideGrabberView"];
	[preferences registerBool:&hideArtworkViewSwitch default:NO forKey:@"hideArtworkView"];
	[preferences registerBool:&hideTimeControlSwitch default:NO forKey:@"hideTimeControl"];
	[preferences registerBool:&hideKnobViewSwitch default:NO forKey:@"hideKnobView"];
	[preferences registerBool:&hideElapsedTimeLabelSwitch default:NO forKey:@"hideElapsedTimeLabel"];
	[preferences registerBool:&hideRemainingTimeLabelSwitch default:NO forKey:@"hideRemainingTimeLabel"];
	[preferences registerBool:&hideContextualActionsButtonSwitch default:NO forKey:@"hideContextualActionsButton"];
	[preferences registerBool:&hideVolumeSliderSwitch default:NO forKey:@"hideVolumeSlider"];
	[preferences registerBool:&hideMinImageSwitch default:NO forKey:@"hideMinImage"];
	[preferences registerBool:&hideMaxImageSwitch default:NO forKey:@"hideMaxImage"];
	[preferences registerBool:&hideTitleLabelSwitch default:NO forKey:@"hideTitleLabel"];
	[preferences registerBool:&hideSubtitleButtonSwitch default:NO forKey:@"hideSubtitleButton"];
	[preferences registerBool:&hideLyricsButtonSwitch default:NO forKey:@"hideLyricsButton"];
	[preferences registerBool:&hideRouteButtonSwitch default:NO forKey:@"hideRouteButton"];
	[preferences registerBool:&hideRouteLabelSwitch default:NO forKey:@"hideRouteLabel"];
	[preferences registerBool:&hideQueueButtonSwitch default:NO forKey:@"hideQueueButton"];

	// Lockscreen
	[preferences registerBool:&lockscreenArtworkBackgroundSwitch default:NO forKey:@"lockscreenArtworkBackground"];
	[preferences registerObject:&lockscreenArtworkBlurMode default:@"0" forKey:@"lockscreenArtworkBlur"];
	[preferences registerBool:&hideCSRoutingButtonSwitch default:NO forKey:@"hideCSRoutingButton"];
	[preferences registerBool:&hideCSTimeControlSwitch default:NO forKey:@"hideCSTimeControl"];
	[preferences registerBool:&hideCSElapsedTimeLabelSwitch default:NO forKey:@"hideCSElapsedTimeLabel"];
	[preferences registerBool:&hideCSRemainingTimeLabelSwitch default:NO forKey:@"hideCSRemainingTimeLabel"];
	[preferences registerBool:&hideCSMediaControlsSwitch default:NO forKey:@"hideCSMediaControls"];
	[preferences registerBool:&hideCSVolumeSliderSwitch default:NO forKey:@"hideCSVolumeSlider"];

	// Homescreen
	[preferences registerBool:&homescreenArtworkBackgroundSwitch default:NO forKey:@"homescreenArtworkBackground"];
	[preferences registerObject:&homescreenArtworkBlurMode default:@"0" forKey:@"homescreenArtworkBlur"];

	if (enabled) {
		if (enableMusicApplicationSection) %init(VioletMusicApplication, ArtworkView=objc_getClass("MusicApplication.NowPlayingContentView"), TimeControl=objc_getClass("MusicApplication.PlayerTimeControl"), ContextualActionsButton=objc_getClass("MusicApplication.ContextualActionsButton"));
		if (enableLockscreenSection) %init(VioletLockscreen);
		if (enableHomescreenSection) %init(VioletHomescreen);
		if (enableLockscreenSection || enableHomescreenSection) %init(VioletOthers);
        return;
    }

}
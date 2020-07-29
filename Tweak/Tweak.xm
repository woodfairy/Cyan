#import "Violet.h"

BOOL enabled;
BOOL enableMusicApplicationSection;
BOOL enableLockscreenSection;

// Music Application

%group VioletMusicApplication

%hook ArtworkView

- (void)didMoveToWindow {

	%orig;

	if (hideArtworkViewSwitch)
		[self setHidden:YES];

}

%end

%hook TimeControl

- (void)didMoveToWindow {

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

- (void)didMoveToWindow {

	%orig;

	if (hideContextualActionsButtonSwitch)
		[self setHidden:YES];

}

%end

%hook _TtCC16MusicApplication32NowPlayingControlsViewController12VolumeSlider

- (void)didMoveToWindow {

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

- (void)viewDidLoad {

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

	// if (!musicArtworkBackgroundImageView) 
	musicArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
	[musicArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[musicArtworkBackgroundImageView setHidden:NO];

	// if (![musicArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:musicArtworkBackgroundImageView atIndex:4];

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
				}
			}
        }
    });
    
}

- (void)_setNowPlayingApplication:(id)arg1 { // hide background artwork when now playing app was closed

	%orig;

	[lsArtworkBackgroundImageView setHidden:YES];

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.violetpreferences"];

    [preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	[preferences registerBool:&enableMusicApplicationSection default:nil forKey:@"EnableMusicApplicationSection"];
	[preferences registerBool:&enableLockscreenSection default:nil forKey:@"EnableLockscreenSection"];

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

	if (enabled) {
		if (enableMusicApplicationSection) %init(VioletMusicApplication, ArtworkView=objc_getClass("MusicApplication.NowPlayingContentView"), TimeControl=objc_getClass("MusicApplication.PlayerTimeControl"), ContextualActionsButton=objc_getClass("MusicApplication.ContextualActionsButton"));
		if (enableLockscreenSection) %init(VioletLockscreen);
		if (enableMusicApplicationSection || enableLockscreenSection) %init(VioletOthers);
        return;
    }

}
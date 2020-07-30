#import "../Violet.h"

BOOL enabled;
BOOL enableMusicApplicationSection;

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

- (void)setHidden:(BOOL)hidden { // hide airplay button

	%orig;

	if (hideContextualActionsButtonSwitch)
		%orig(YES);

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

	if (!musicArtworkBackgroundImageView) musicArtworkBackgroundImageView = [[UIImageView alloc] init];
	[musicArtworkBackgroundImageView setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
	[musicArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[musicArtworkBackgroundImageView setHidden:NO];
	[musicArtworkBackgroundImageView setClipsToBounds:YES];
	// [musicArtworkBackgroundImageView setBackgroundColor:[UIColor purpleColor]];

	if (![musicArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:musicArtworkBackgroundImageView atIndex:0];

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.violetpreferences"];

    [preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	[preferences registerBool:&enableMusicApplicationSection default:nil forKey:@"EnableMusicApplicationSection"];

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

	if (enabled) {
		if (enableMusicApplicationSection) %init(VioletMusicApplication, ArtworkView=objc_getClass("MusicApplication.NowPlayingContentView"), TimeControl=objc_getClass("MusicApplication.PlayerTimeControl"), ContextualActionsButton=objc_getClass("MusicApplication.ContextualActionsButton"));
        return;
    }

}
#import "Violet.h"

BOOL enabled;
BOOL enableLockscreenSection;
BOOL enableHomescreenSection;

// Lockscreen

%group VioletLockscreen

%hook CSCoverSheetViewController // iOS 13

- (void)viewDidLoad { // add artwork background view

	%orig;

	if (!lockscreenArtworkBackgroundSwitch) return;
	if (!lsArtworkBackgroundImageView) lsArtworkBackgroundImageView = [[UIImageView alloc] init];
	[lsArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[lsArtworkBackgroundImageView setHidden:YES];
	[lsArtworkBackgroundImageView setClipsToBounds:YES];

	if ([lockscreenArtworkBlurMode intValue] != 0) {
		if (!lsBlur) {
			if ([lockscreenArtworkBlurMode intValue] == 1)
				lsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			else if ([lockscreenArtworkBlurMode intValue] == 2)
				lsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			lsBlurView = [[UIVisualEffectView alloc] initWithEffect:lsBlur];
			[lsBlurView setClipsToBounds:YES];
			[lsArtworkBackgroundImageView addSubview:lsBlurView];
		}
		[lsBlurView setHidden:NO];
	}

	if (![lsArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:lsArtworkBackgroundImageView atIndex:0];

}

- (void)viewWillAppear:(BOOL)animated {

	%orig;

	[lsArtworkBackgroundImageView setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
	[lsBlurView setFrame:lsArtworkBackgroundImageView.bounds];
	[lsBlurView setHidden:NO];

}

%end

%hook SBDashBoardViewController // iOS 12

- (void)viewDidLoad { // add artwork background view

	%orig;

	if (!lockscreenArtworkBackgroundSwitch) return;
	if (!lsArtworkBackgroundImageView) lsArtworkBackgroundImageView = [[UIImageView alloc] init];
	[lsArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[lsArtworkBackgroundImageView setHidden:YES];
	[lsArtworkBackgroundImageView setClipsToBounds:YES];

	if ([lockscreenArtworkBlurMode intValue] != 0) {
		if (!lsBlur) {
			if ([lockscreenArtworkBlurMode intValue] == 1)
				lsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			else if ([lockscreenArtworkBlurMode intValue] == 2)
				lsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			lsBlurView = [[UIVisualEffectView alloc] initWithEffect:lsBlur];
			[lsBlurView setClipsToBounds:YES];
			[lsArtworkBackgroundImageView addSubview:lsBlurView];
		}
		[lsBlurView setHidden:NO];
	}

	if (![lsArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:lsArtworkBackgroundImageView atIndex:0];

}

- (void)viewWillAppear:(BOOL)animated {

	%orig;

	[lsArtworkBackgroundImageView setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
	[lsBlurView setFrame:lsArtworkBackgroundImageView.bounds];
	[lsBlurView setHidden:NO];

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

- (void)viewDidLoad { // add artwork background view

	%orig;

	if (!homescreenArtworkBackgroundSwitch) return;
	if (!hsArtworkBackgroundImageView) hsArtworkBackgroundImageView = [[UIImageView alloc] init];
	[hsArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[hsArtworkBackgroundImageView setHidden:YES];
	[hsArtworkBackgroundImageView setClipsToBounds:YES];

	if ([homescreenArtworkBlurMode intValue] != 0) {
		if (!hsBlur) {
			if ([homescreenArtworkBlurMode intValue] == 1)
				hsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			else if ([homescreenArtworkBlurMode intValue] == 2)
				hsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			hsBlurView = [[UIVisualEffectView alloc] initWithEffect:hsBlur];
			[hsBlurView setClipsToBounds:YES];
			[hsArtworkBackgroundImageView addSubview:hsBlurView];
		}
		[hsBlurView setHidden:NO];
	}

	if (![hsArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:hsArtworkBackgroundImageView atIndex:0];

}

- (void)viewWillAppear:(BOOL)animated {

	%orig;

	[hsArtworkBackgroundImageView setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
	[hsBlurView setFrame:hsArtworkBackgroundImageView.bounds];
	[hsBlurView setHidden:NO];

}

%end

%end

// Data

%group VioletData

%hook SBMediaController

- (void)setNowPlayingInfo:(id)arg1 { // get and set the artwork

    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        NSDictionary* dict = (__bridge NSDictionary *)information;
        if (dict) {
            if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
				currentArtwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
				if (currentArtwork) {
					if (lockscreenArtworkBackgroundSwitch) {
						[lsArtworkBackgroundImageView setImage:currentArtwork];
						[lsArtworkBackgroundImageView setHidden:NO];
					}
					if (homescreenArtworkBackgroundSwitch) {
						[hsArtworkBackgroundImageView setImage:currentArtwork];
						[hsArtworkBackgroundImageView setHidden:NO];
					}
				}
			}
        }
    });
    
}

- (void)_setNowPlayingApplication:(id)arg1 { // hide background artwork when now playing app was closed

	%orig;

	[lsArtworkBackgroundImageView setHidden:YES];
	[hsArtworkBackgroundImageView setHidden:YES];
	[lsBlurView setHidden:YES];
	[hsBlurView setHidden:YES];
	currentArtwork = nil;
	lsArtworkBackgroundImageView.image = nil;
	hsArtworkBackgroundImageView.image = nil;

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.violetpreferences"];

    [preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	[preferences registerBool:&enableLockscreenSection default:nil forKey:@"EnableLockscreenSection"];
	[preferences registerBool:&enableHomescreenSection default:nil forKey:@"EnableHomescreenSection"];

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
		if (enableLockscreenSection) %init(VioletLockscreen);
		if (enableHomescreenSection) %init(VioletHomescreen);
		if (lockscreenArtworkBackgroundSwitch || homescreenArtworkBackgroundSwitch) %init(VioletData);
        return;
    }

}
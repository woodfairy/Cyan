#import "Violet.h"

BOOL enabled;
BOOL enableLockscreenSection;
BOOL enableHomescreenSection;
BOOL enableControlCenterSection;

// Lockscreen

%group VioletLockscreen

%hook CSCoverSheetViewController

- (void)viewDidLoad { // add artwork background view

	%orig;

	if (!lockscreenArtworkBackgroundSwitch) return;
	if (!lsArtworkBackgroundImageView) lsArtworkBackgroundImageView = [[UIImageView alloc] init];
	[lsArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[lsArtworkBackgroundImageView setHidden:YES];
	[lsArtworkBackgroundImageView setClipsToBounds:YES];
	[lsArtworkBackgroundImageView setAlpha:[lockscreenArtworkOpacityValue doubleValue]];

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

	if (roundLockScreenCompatibilitySwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/RoundLockScreen.dylib"])
		[[lsArtworkBackgroundImageView layer] setCornerRadius:38];

}

- (void)viewWillDisappear:(BOOL)animated {

	%orig;

	if (roundLockScreenCompatibilitySwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/RoundLockScreen.dylib"])
		[[lsArtworkBackgroundImageView layer] setCornerRadius:38];

}

- (void)viewDidAppear:(BOOL)animated {

	%orig;

	if (roundLockScreenCompatibilitySwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/RoundLockScreen.dylib"])
		[[lsArtworkBackgroundImageView layer] setCornerRadius:0];

}

%end

%hook CSAdjunctItemView

- (void)didMoveToWindow { // add artwork to lockscreen player

	if (lockscreenPlayerArtworkBackgroundSwitch || hideLockscreenPlayerBackgroundSwitch) {
		UIView* platterView = MSHookIvar<UIView *>(self, "_platterView");
		[[platterView backgroundMaterialView] setHidden:YES];
	}

	if (!lockscreenPlayerArtworkBackgroundSwitch) return;
	if (!lspArtworkBackgroundImageView) lspArtworkBackgroundImageView = [[UIImageView alloc] init];
	[lspArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[lspArtworkBackgroundImageView setHidden:NO];
	[lspArtworkBackgroundImageView setClipsToBounds:YES];
	[lspArtworkBackgroundImageView setAlpha:[lockscreenPlayerArtworkOpacityValue doubleValue]];
	[[lspArtworkBackgroundImageView layer] setCornerRadius:[lockscreenPlayerArtworkCornerRadiusValue doubleValue]];

	if ([lockscreenPlayerArtworkBlurMode intValue] != 0) {
		if (!lspBlur) {
			if ([lockscreenPlayerArtworkBlurMode intValue] == 1)
				lspBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			else if ([lockscreenPlayerArtworkBlurMode intValue] == 2)
				lspBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			lspBlurView = [[UIVisualEffectView alloc] initWithEffect:lsBlur];
			[lspBlurView setFrame:lspArtworkBackgroundImageView.bounds];
			[lspBlurView setClipsToBounds:YES];
			[lspArtworkBackgroundImageView addSubview:lspBlurView];
		}
		[lspBlurView setHidden:NO];
	}

	if (![lspArtworkBackgroundImageView isDescendantOfView:self])
		[self insertSubview:lspArtworkBackgroundImageView atIndex:0];

}

- (void)willMoveToWindow:(id)arg1 {

	%orig;

	[lspArtworkBackgroundImageView setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height)];
	[lspBlurView setFrame:lspArtworkBackgroundImageView.bounds];
	[lspBlurView setHidden:NO];

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
	[hsArtworkBackgroundImageView setAlpha:[homescreenArtworkOpacityValue doubleValue]];

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
	if (coverEntireHomescreenSwitch) hsArtworkBackgroundImageView.bounds = CGRectInset(hsArtworkBackgroundImageView.frame, -50, -50);
	[hsBlurView setFrame:hsArtworkBackgroundImageView.bounds];
	[hsBlurView setHidden:NO];

}

%end

%end

%group ControlCenter

%hook CCUIContentModuleContainerViewController

- (void)viewWillAppear:(BOOL)animated {

	%orig;
	
	if (!controlCenterArtworkBackgroundSwitch) return;
	if ([[self moduleIdentifier] isEqual:@"com.apple.mediaremote.controlcenter.nowplaying"]) {
		if (!ccArtworkBackgroundImageView) ccArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:self.contentViewController.view.bounds];
		[ccArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
		[ccArtworkBackgroundImageView setHidden:NO];
		[ccArtworkBackgroundImageView setClipsToBounds:YES];
		[ccArtworkBackgroundImageView setAlpha:[controlCenterArtworkOpacityValue doubleValue]];
		[[ccArtworkBackgroundImageView layer] setCornerRadius:[controlCenterArtworkCornerRadiusValue doubleValue]];
		[ccArtworkBackgroundImageView setImage:currentArtwork];

		if (![ccArtworkBackgroundImageView isDescendantOfView:[self view]])
			[[self view] insertSubview:ccArtworkBackgroundImageView atIndex:0];
	}

}

- (void)setExpanded:(BOOL)arg1 {

	%orig;

	if (arg1 && [[self moduleIdentifier] isEqual:@"com.apple.mediaremote.controlcenter.nowplaying"])
		[ccArtworkBackgroundImageView setHidden:YES];

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
						if ([lockscreenArtworkBlurMode intValue] != 0) [lsBlurView setHidden:NO];
					}
					if (lockscreenPlayerArtworkBackgroundSwitch) {
						[lspArtworkBackgroundImageView setImage:currentArtwork];
						[lspArtworkBackgroundImageView setHidden:NO];
						if ([lockscreenPlayerArtworkBlurMode intValue] != 0) [lspBlurView setHidden:NO];
					}
					if (homescreenArtworkBackgroundSwitch) {
						[hsArtworkBackgroundImageView setImage:currentArtwork];
						[hsArtworkBackgroundImageView setHidden:NO];
						if ([homescreenArtworkBlurMode intValue] != 0) [hsBlurView setHidden:NO];
					}
					if (controlCenterArtworkBackgroundSwitch) {
						[ccArtworkBackgroundImageView setImage:currentArtwork];
						[ccArtworkBackgroundImageView setHidden:NO];
					}
				}
			}
        }
    });
    
}

- (void)_setNowPlayingApplication:(id)arg1 { // hide background artwork when now playing app was closed

	%orig;

	[lsArtworkBackgroundImageView setHidden:YES];
	[lspArtworkBackgroundImageView setHidden:YES];
	[hsArtworkBackgroundImageView setHidden:YES];
	[ccArtworkBackgroundImageView setHidden:YES];
	[lsBlurView setHidden:YES];
	[lspBlurView setHidden:YES];
	[hsBlurView setHidden:YES];
	currentArtwork = nil;
	lsArtworkBackgroundImageView.image = nil;
	lspArtworkBackgroundImageView.image = nil;
	hsArtworkBackgroundImageView.image = nil;
	ccArtworkBackgroundImageView.image = nil;

}

%end

%end

%ctor {

	preferences = [[HBPreferences alloc] initWithIdentifier:@"love.litten.violetpreferences"];

    [preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	[preferences registerBool:&enableLockscreenSection default:nil forKey:@"EnableLockscreenSection"];
	[preferences registerBool:&enableHomescreenSection default:nil forKey:@"EnableHomescreenSection"];
	[preferences registerBool:&enableControlCenterSection default:nil forKey:@"EnableControlCenterSection"];

	// Lockscreen
	if (enableLockscreenSection) {
		[preferences registerBool:&lockscreenArtworkBackgroundSwitch default:NO forKey:@"lockscreenArtworkBackground"];
		[preferences registerObject:&lockscreenArtworkBlurMode default:@"0" forKey:@"lockscreenArtworkBlur"];
		[preferences registerObject:&lockscreenArtworkOpacityValue default:@"1.0" forKey:@"lockscreenArtworkOpacity"];
		[preferences registerBool:&lockscreenPlayerArtworkBackgroundSwitch default:NO forKey:@"lockscreenPlayerArtworkBackground"];
		[preferences registerObject:&lockscreenPlayerArtworkBlurMode default:@"0" forKey:@"lockscreenPlayerArtworkBlur"];
		[preferences registerObject:&lockscreenPlayerArtworkOpacityValue default:@"1.0" forKey:@"lockscreenPlayerArtworkOpacity"];
		[preferences registerObject:&lockscreenPlayerArtworkCornerRadiusValue default:@"10.0" forKey:@"lockscreenPlayerArtworkCornerRadius"];
		[preferences registerBool:&hideLockscreenPlayerBackgroundSwitch default:NO forKey:@"hideLockscreenPlayerBackground"];
		[preferences registerBool:&roundLockScreenCompatibilitySwitch default:YES forKey:@"roundLockScreenCompatibility"];
	}

	// Homescreen
	if (enableHomescreenSection) {
		[preferences registerBool:&homescreenArtworkBackgroundSwitch default:NO forKey:@"homescreenArtworkBackground"];
		[preferences registerObject:&homescreenArtworkBlurMode default:@"0" forKey:@"homescreenArtworkBlur"];
		[preferences registerObject:&homescreenArtworkOpacityValue default:@"1.0" forKey:@"homescreenArtworkOpacity"];
		[preferences registerBool:&coverEntireHomescreenSwitch default:YES forKey:@"coverEntireHomescreen"];
	}

	// Control Center
	if (enableControlCenterSection) {
		[preferences registerBool:&controlCenterArtworkBackgroundSwitch default:NO forKey:@"controlCenterArtworkBackground"];
		[preferences registerObject:&controlCenterArtworkOpacityValue default:@"1.0" forKey:@"controlCenterArtworkOpacity"];
		[preferences registerObject:&controlCenterArtworkCornerRadiusValue default:@"20.0" forKey:@"controlCenterArtworkCornerRadius"];
	}

	if (enabled) {
		if (enableLockscreenSection) %init(VioletLockscreen);
		if (enableHomescreenSection) %init(VioletHomescreen);
		if (enableControlCenterSection) %init(ControlCenter);
		%init(VioletData);
        return;
    }

}
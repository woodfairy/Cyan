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
	if (!lsArtworkBackgroundImageView) lsArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	[lsArtworkBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
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
			[lsBlurView setFrame:lsArtworkBackgroundImageView.bounds];
			[lsBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[lsBlurView setClipsToBounds:YES];
			[lsArtworkBackgroundImageView addSubview:lsBlurView];
		}
		[lsBlurView setHidden:NO];
	}

	if (![lsArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:lsArtworkBackgroundImageView atIndex:0];

}

- (void)viewWillAppear:(BOOL)animated { // roundlockscreen compatibility

	%orig;

	if (roundLockScreenCompatibilitySwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/RoundLockScreen.dylib"])
		[[lsArtworkBackgroundImageView layer] setCornerRadius:38];

}

- (void)viewWillDisappear:(BOOL)animated { // roundlockscreen compatibility

	%orig;

	if (roundLockScreenCompatibilitySwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/RoundLockScreen.dylib"])
		[[lsArtworkBackgroundImageView layer] setCornerRadius:38];

}

- (void)viewDidAppear:(BOOL)animated { // roundlockscreen compatibility

	%orig;

	if (roundLockScreenCompatibilitySwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/RoundLockScreen.dylib"])
		[[lsArtworkBackgroundImageView layer] setCornerRadius:0];

}

%end

%hook MRPlatterViewController

- (void)viewDidLayoutSubviews {

	%orig;

	if ([self.label isEqualToString:@"MRPlatter-CoverSheet"]) {
		UIView *AdjunctItemView = self.view.superview.superview.superview.superview;

		if (hideLockscreenPlayerBackgroundSwitch) {
			UIView* platterView = MSHookIvar<UIView *>(AdjunctItemView, "_platterView");
			[[platterView backgroundMaterialView] setHidden:YES];
		}

		if (!lockscreenPlayerArtworkBackgroundSwitch) return;
		[self clearMaterialViewBackground];
		if (!lspArtworkBackgroundImageView) {
			lspArtworkBackgroundImageView = [[UIImageView alloc] init];
			[lspArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
			[lspArtworkBackgroundImageView setHidden:NO];
			[lspArtworkBackgroundImageView setClipsToBounds:YES];
		}
		[lspArtworkBackgroundImageView setFrame:AdjunctItemView.bounds];
		[lspArtworkBackgroundImageView setAlpha:[lockscreenPlayerArtworkOpacityValue doubleValue]];
		[[lspArtworkBackgroundImageView layer] setCornerRadius:[lockscreenPlayerArtworkCornerRadiusValue doubleValue]];
		[lspArtworkBackgroundImageView setImage:currentArtwork];

		if ([lockscreenPlayerArtworkBlurMode intValue] != 0) {
			if (!lspBlur) {
				if ([lockscreenPlayerArtworkBlurMode intValue] == 1)
					lspBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
				else if ([lockscreenPlayerArtworkBlurMode intValue] == 2)
					lspBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
				lspBlurView = [[UIVisualEffectView alloc] initWithEffect:lsBlur];
				[lspBlurView setFrame:lspArtworkBackgroundImageView.bounds];
				[lspBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
				[lspBlurView setClipsToBounds:YES];
				[lspArtworkBackgroundImageView addSubview:lspBlurView];
			}
			[lspBlurView setHidden:NO];
		}

		if (![lspArtworkBackgroundImageView isDescendantOfView:AdjunctItemView])
			[AdjunctItemView insertSubview:lspArtworkBackgroundImageView atIndex:0];		
	}
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection { // fix for the MTView resetting when switching between light and dark mode

	%orig;

	if ([self.label isEqualToString:@"MRPlatter-CoverSheet"] && self.traitCollection.userInterfaceStyle != previousTraitCollection.userInterfaceStyle)
		[self performSelector:@selector(clearMaterialViewBackground) withObject:nil afterDelay:0.2];

}

%new
- (void)clearMaterialViewBackground {

	UIView *AdjunctItemView = self.view.superview.superview.superview.superview;

	UIView* platterView = MSHookIvar<UIView *>(AdjunctItemView, "_platterView");
	MTMaterialView* MTView = MSHookIvar<MTMaterialView *>(platterView, "_backgroundView");
	MTMaterialLayer* MTLayer = (MTMaterialLayer *)MTView.layer;
	[MTLayer setScale:0];
	[MTLayer mt_setColorMatrixDrivenOpacity:0 removingIfIdentity:false];
	[MTView setBackgroundColor:[UIColor clearColor]];

}

%end

%end

%group VioletHomescreen

%hook SBIconController

- (void)viewDidLoad { // add artwork background view

	%orig;

	if (!homescreenArtworkBackgroundSwitch) return;
	if (!hsArtworkBackgroundImageView) hsArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	if (coverEntireHomescreenSwitch) hsArtworkBackgroundImageView.bounds = CGRectInset(hsArtworkBackgroundImageView.frame, -50, -50);
	[hsArtworkBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
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
			[hsBlurView setFrame:hsArtworkBackgroundImageView.bounds];
			[hsBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[hsBlurView setClipsToBounds:YES];
			[hsArtworkBackgroundImageView addSubview:hsBlurView];
		}
		[hsBlurView setHidden:NO];
	}

	if (![hsArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:hsArtworkBackgroundImageView atIndex:0];

}

%end

%end

%group ControlCenter

%hook CCUIContentModuleContainerViewController

- (void)viewWillAppear:(BOOL)animated { // add artwork background view

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

- (void)setExpanded:(BOOL)arg1 { // hide artwork when expanded

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
			if (information) {
				NSDictionary* dict = (__bridge NSDictionary *)information;
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
      } else {
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
  });
    
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
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
	if (!lsArtworkBackgroundImageView) lsArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
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
			else if ([lockscreenArtworkBlurMode intValue] == 3)
				lsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
			lsBlurView = [[UIVisualEffectView alloc] initWithEffect:lsBlur];
			[lsBlurView setFrame:[lsArtworkBackgroundImageView bounds]];
			[lsBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[lsBlurView setClipsToBounds:YES];
			[lsBlurView setAlpha:[lockscreenArtworkBlurAmountValue doubleValue]];
			[lsArtworkBackgroundImageView addSubview:lsBlurView];
		}
		[lsBlurView setHidden:NO];
	}

	if ([lockscreenArtworkDimValue doubleValue] != 0.0) {
		if (!lsDimView) lsDimView = [[UIView alloc] init];
		[lsDimView setFrame:[lsArtworkBackgroundImageView bounds]];
		[lsDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[lsDimView setClipsToBounds:YES];
		[lsDimView setBackgroundColor:[UIColor blackColor]];
		[lsDimView setAlpha:[lockscreenArtworkDimValue doubleValue]];
		[lsDimView setHidden:NO];

		if (![lsDimView isDescendantOfView:lsArtworkBackgroundImageView])
			[lsArtworkBackgroundImageView addSubview:lsDimView];
	}

	if (![lsArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:lsArtworkBackgroundImageView atIndex:0];

}

%end

%hook MRPlatterViewController

- (void)viewDidAppear:(BOOL)animated { // add artwork background view

	%orig;

	if ([[self label] isEqualToString:@"MRPlatter-CoverSheet"]) {
		UIView* AdjunctItemView = [[[[[self view] superview] superview] superview] superview];

		if (hideLockscreenPlayerBackgroundSwitch) {
			UIView* platterView = MSHookIvar<UIView *>(AdjunctItemView, "_platterView");
			[[platterView backgroundMaterialView] setHidden:YES];
		}

		if (!lockscreenPlayerArtworkBackgroundSwitch) return;
		if (currentArtwork)
			[self clearMaterialViewBackground];
		else
			[self setMaterialViewBackground];
		if (!lspArtworkBackgroundImageView) {
			lspArtworkBackgroundImageView = [[UIImageView alloc] init];
			[lspArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
			[lspArtworkBackgroundImageView setHidden:NO];
			[lspArtworkBackgroundImageView setClipsToBounds:YES];
		}
		[lspArtworkBackgroundImageView setFrame:[AdjunctItemView bounds]];
		[lspArtworkBackgroundImageView setAlpha:[lockscreenPlayerArtworkOpacityValue doubleValue]];
		[[lspArtworkBackgroundImageView layer] setCornerRadius:[lockscreenPlayerArtworkCornerRadiusValue doubleValue]];
		[lspArtworkBackgroundImageView setImage:currentArtwork];

		if ([lockscreenPlayerArtworkBlurMode intValue] != 0) {
			if (!lspBlur) {
				if ([lockscreenPlayerArtworkBlurMode intValue] == 1)
					lspBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
				else if ([lockscreenPlayerArtworkBlurMode intValue] == 2)
					lspBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
				else if ([lockscreenPlayerArtworkBlurMode intValue] == 3)
					lspBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
				lspBlurView = [[UIVisualEffectView alloc] initWithEffect:lsBlur];
				[lspBlurView setFrame:[lspArtworkBackgroundImageView bounds]];
				[lspBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
				[lspBlurView setClipsToBounds:YES];
				[lspBlurView setAlpha:[lockscreenPlayerArtworkBlurAmountValue doubleValue]];
				[lspArtworkBackgroundImageView addSubview:lspBlurView];
			}
			[lspBlurView setHidden:NO];
		}

		if ([lockscreenPlayerArtworkDimValue doubleValue] != 0.0) {
			if (!lspDimView) lspDimView = [[UIView alloc] init];
			[lspDimView setFrame:[lspArtworkBackgroundImageView bounds]];
			[lspDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[lspDimView setClipsToBounds:YES];
			[lspDimView setBackgroundColor:[UIColor blackColor]];
			[lspDimView setAlpha:[lockscreenPlayerArtworkDimValue doubleValue]];
			[lspDimView setHidden:NO];

			if (![lspDimView isDescendantOfView:lspArtworkBackgroundImageView])
				[lspArtworkBackgroundImageView addSubview:lspDimView];
		}

		if (![lspArtworkBackgroundImageView isDescendantOfView:AdjunctItemView])
			[AdjunctItemView insertSubview:lspArtworkBackgroundImageView atIndex:0];		
	}
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection { // fix for the MTView resetting when switching between light and dark mode

	%orig;

	if ([[self label] isEqualToString:@"MRPlatter-CoverSheet"] && [[self traitCollection] userInterfaceStyle] != [previousTraitCollection userInterfaceStyle]) {
		if (currentArtwork) [self performSelector:@selector(clearMaterialViewBackground) withObject:nil afterDelay:0.2];
		else [self performSelector:@selector(setMaterialViewBackground) withObject:nil afterDelay:0.2];
	}

}

%new
- (void)clearMaterialViewBackground {

	UIView* AdjunctItemView = [[[[[self view] superview] superview] superview] superview];

	UIView* platterView = MSHookIvar<UIView *>(AdjunctItemView, "_platterView");
	MTMaterialView* MTView = MSHookIvar<MTMaterialView *>(platterView, "_backgroundView");
	MTMaterialLayer* MTLayer = (MTMaterialLayer *)[MTView layer];
	[MTLayer setScale:0];
	[MTLayer mt_setColorMatrixDrivenOpacity:0 removingIfIdentity:false];
	[MTView setBackgroundColor:[UIColor clearColor]];

}

%new
- (void)setMaterialViewBackground {

	UIView* AdjunctItemView = [[[[[self view] superview] superview] superview] superview];

	UIView* platterView = MSHookIvar<UIView *>(AdjunctItemView, "_platterView");
	MTMaterialView* MTView = MSHookIvar<MTMaterialView *>(platterView, "_backgroundView");
	MTMaterialLayer* MTLayer = (MTMaterialLayer *)[MTView layer];
	[MTLayer setScale:1];
	[MTLayer mt_setColorMatrixDrivenOpacity:1 removingIfIdentity:false];

}

%end

%end

%group VioletHomescreen

%hook SBIconController

- (void)viewDidLoad { // add artwork background view

	%orig;

	if (!homescreenArtworkBackgroundSwitch) return;
	if (!hsArtworkBackgroundImageView) hsArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
	if (zoomedViewSwitch) hsArtworkBackgroundImageView.bounds = CGRectInset(hsArtworkBackgroundImageView.frame, -50, -50);
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
			else if ([homescreenArtworkBlurMode intValue] == 3)
				hsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
			hsBlurView = [[UIVisualEffectView alloc] initWithEffect:hsBlur];
			[hsBlurView setFrame:[hsArtworkBackgroundImageView bounds]];
			[hsBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[hsBlurView setClipsToBounds:YES];
			[hsBlurView setAlpha:[homescreenArtworkBlurAmountValue doubleValue]];
			[hsArtworkBackgroundImageView addSubview:hsBlurView];
		}
		[hsBlurView setHidden:NO];
	}

	if ([homescreenArtworkDimValue doubleValue] != 0.0) {
		if (!hsDimView) hsDimView = [[UIView alloc] init];
		[hsDimView setFrame:[hsArtworkBackgroundImageView bounds]];
		[hsDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[hsDimView setClipsToBounds:YES];
		[hsDimView setBackgroundColor:[UIColor blackColor]];
		[hsDimView setAlpha:[homescreenArtworkDimValue doubleValue]];
		[hsDimView setHidden:NO];

		if (![hsDimView isDescendantOfView:hsArtworkBackgroundImageView])
			[hsArtworkBackgroundImageView addSubview:hsDimView];
	}

	if (![hsArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:hsArtworkBackgroundImageView atIndex:0];

}

%end

%end

%group ControlCenter

%hook CCUIModularControlCenterOverlayViewController

- (void)viewWillAppear:(BOOL)animated { // add artwork background view

	%orig;

	if (!controlCenterArtworkBackgroundSwitch) return;
	if (!ccArtworkBackgroundImageView) ccArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
	[ccArtworkBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[ccArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[ccArtworkBackgroundImageView setHidden:NO];
	[ccArtworkBackgroundImageView setClipsToBounds:YES];
	[ccArtworkBackgroundImageView setAlpha:[controlCenterArtworkOpacityValue doubleValue]];

	if ([controlCenterArtworkBlurMode intValue] != 0) {
		if (!ccBlur) {
			if ([controlCenterArtworkBlurMode intValue] == 1)
				ccBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			else if ([controlCenterArtworkBlurMode intValue] == 2)
				ccBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			else if ([controlCenterArtworkBlurMode intValue] == 3)
				ccBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
			ccBlurView = [[UIVisualEffectView alloc] initWithEffect:ccBlur];
			[ccBlurView setFrame:[ccArtworkBackgroundImageView bounds]];
			[ccBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[ccBlurView setClipsToBounds:YES];
			[ccBlurView setAlpha:[controlCenterArtworkBlurAmountValue doubleValue]];
			[ccArtworkBackgroundImageView addSubview:ccBlurView];
		}
		[ccBlurView setHidden:NO];
	}

	if ([controlCenterArtworkDimValue doubleValue] != 0.0) {
		if (!ccDimView) ccDimView = [[UIView alloc] init];
		[ccDimView setFrame:[ccArtworkBackgroundImageView bounds]];
		[ccDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[ccDimView setClipsToBounds:YES];
		[ccDimView setBackgroundColor:[UIColor blackColor]];
		[ccDimView setAlpha:[controlCenterArtworkDimValue doubleValue]];
		[ccDimView setHidden:NO];

		if (![ccDimView isDescendantOfView:ccArtworkBackgroundImageView])
			[ccArtworkBackgroundImageView addSubview:ccDimView];
	}

	if (![ccArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:ccArtworkBackgroundImageView atIndex:1];

}

- (void)dismissAnimated:(BOOL)arg1 withCompletionHandler:(id)arg2 { // hide cc background earlier than it would otherwise

	%orig;

	[ccArtworkBackgroundImageView setHidden:YES];

}

%end

%hook CCUIContentModuleContainerViewController

- (void)viewWillAppear:(BOOL)animated { // add artwork background view

	%orig;
	
	if (!controlCenterModuleArtworkBackgroundSwitch) return;
	if ([[self moduleIdentifier] isEqual:@"com.apple.mediaremote.controlcenter.nowplaying"]) {
		if (!ccmArtworkBackgroundImageView) ccmArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[[self contentViewController] view] bounds]];
		[ccmArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
		[ccmArtworkBackgroundImageView setHidden:NO];
		[ccmArtworkBackgroundImageView setClipsToBounds:YES];
		[ccmArtworkBackgroundImageView setAlpha:[controlCenterModuleArtworkOpacityValue doubleValue]];
		[[ccmArtworkBackgroundImageView layer] setCornerRadius:[controlCenterModuleArtworkCornerRadiusValue doubleValue]];
		[ccmArtworkBackgroundImageView setImage:currentArtwork];

		if (![ccmArtworkBackgroundImageView isDescendantOfView:[self view]])
			[[self view] insertSubview:ccmArtworkBackgroundImageView atIndex:0];
	}

}

- (void)setExpanded:(BOOL)arg1 { // hide artwork when expanded

	%orig;

	if (arg1 && [[self moduleIdentifier] isEqual:@"com.apple.mediaremote.controlcenter.nowplaying"])
		[ccmArtworkBackgroundImageView setHidden:YES];

}

%end

%end

// Data

%group VioletSpringBoardData

%hook SBMediaController

- (void)setNowPlayingInfo:(id)arg1 { // get and set the artwork

    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
		if (information) {
			NSDictionary* dict = (__bridge NSDictionary *)information;
			currentArtwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
			if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
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
					if (controlCenterModuleArtworkBackgroundSwitch) {
						[ccmArtworkBackgroundImageView setImage:currentArtwork];
					}
				}
			}
		} else {
			[lsArtworkBackgroundImageView setHidden:YES];
			[lspArtworkBackgroundImageView setHidden:YES];
			[hsArtworkBackgroundImageView setHidden:YES];
			[ccArtworkBackgroundImageView setHidden:YES];
			[ccmArtworkBackgroundImageView setHidden:YES];
			[lsBlurView setHidden:YES];
			[lspBlurView setHidden:YES];
			[hsBlurView setHidden:YES];
			[ccBlurView setHidden:YES];
			currentArtwork = nil;
			[lsArtworkBackgroundImageView setImage:nil];
			[lspArtworkBackgroundImageView setImage:nil];
			[hsArtworkBackgroundImageView setImage:nil];
			[ccArtworkBackgroundImageView setImage:nil];
			[ccmArtworkBackgroundImageView setImage:nil];
		}
  	});
    
}

%end

%end

// Tweak Compatibility

%group TweakCompatibility

%hook CSCoverSheetViewController

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

%hook XENHWidgetLayerContainerView

- (void)didMoveToWindow { // hide xen html widgets

	%orig;

	if (hideXenHTMLWidgetsSwitch && ([[%c(SBMediaController) sharedInstance] isPlaying] || [[%c(SBMediaController) sharedInstance] isPaused]))
		[self setHidden:YES];

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
		[preferences registerObject:&lockscreenArtworkBlurAmountValue default:@"1.0" forKey:@"lockscreenArtworkBlurAmount"];
		[preferences registerObject:&lockscreenArtworkOpacityValue default:@"1.0" forKey:@"lockscreenArtworkOpacity"];
		[preferences registerObject:&lockscreenArtworkDimValue default:@"0.0" forKey:@"lockscreenArtworkDim"];
		[preferences registerBool:&lockscreenPlayerArtworkBackgroundSwitch default:NO forKey:@"lockscreenPlayerArtworkBackground"];
		[preferences registerObject:&lockscreenPlayerArtworkBlurMode default:@"0" forKey:@"lockscreenPlayerArtworkBlur"];
		[preferences registerObject:&lockscreenPlayerArtworkBlurAmountValue default:@"1.0" forKey:@"lockscreenPlayerArtworkBlurAmount"];
		[preferences registerObject:&lockscreenPlayerArtworkOpacityValue default:@"1.0" forKey:@"lockscreenPlayerArtworkOpacity"];
		[preferences registerObject:&lockscreenPlayerArtworkCornerRadiusValue default:@"10.0" forKey:@"lockscreenPlayerArtworkCornerRadius"];
		[preferences registerObject:&lockscreenPlayerArtworkDimValue default:@"0.0" forKey:@"lockscreenPlayerArtworkDim"];
		[preferences registerBool:&hideLockscreenPlayerBackgroundSwitch default:NO forKey:@"hideLockscreenPlayerBackground"];
		[preferences registerBool:&roundLockScreenCompatibilitySwitch default:NO forKey:@"roundLockScreenCompatibility"];
		[preferences registerBool:&hideXenHTMLWidgetsSwitch default:NO forKey:@"hideXenHTMLWidgets"];
	}

	// Homescreen
	if (enableHomescreenSection) {
		[preferences registerBool:&homescreenArtworkBackgroundSwitch default:NO forKey:@"homescreenArtworkBackground"];
		[preferences registerObject:&homescreenArtworkBlurMode default:@"0" forKey:@"homescreenArtworkBlur"];
		[preferences registerObject:&homescreenArtworkBlurAmountValue default:@"1.0" forKey:@"homescreenArtworkBlurAmount"];
		[preferences registerObject:&homescreenArtworkOpacityValue default:@"1.0" forKey:@"homescreenArtworkOpacity"];
		[preferences registerObject:&homescreenArtworkDimValue default:@"0.0" forKey:@"homescreenArtworkDim"];
		[preferences registerBool:&zoomedViewSwitch default:YES forKey:@"zoomedView"];
	}

	// Control Center
	if (enableControlCenterSection) {
		[preferences registerBool:&controlCenterArtworkBackgroundSwitch default:NO forKey:@"controlCenterArtworkBackground"];
		[preferences registerObject:&controlCenterArtworkBlurMode default:@"0" forKey:@"controlCenterArtworkBlur"];
		[preferences registerObject:&controlCenterArtworkBlurAmountValue default:@"1.0" forKey:@"controlCenterArtworkBlurAmount"];
		[preferences registerObject:&controlCenterArtworkOpacityValue default:@"1.0" forKey:@"controlCenterArtworkOpacity"];
		[preferences registerObject:&controlCenterArtworkDimValue default:@"0.0" forKey:@"controlCenterArtworkDim"];
		[preferences registerBool:&controlCenterModuleArtworkBackgroundSwitch default:NO forKey:@"controlCenterModuleArtworkBackground"];
		[preferences registerObject:&controlCenterModuleArtworkOpacityValue default:@"1.0" forKey:@"controlCenterModuleArtworkOpacity"];
		[preferences registerObject:&controlCenterModuleArtworkCornerRadiusValue default:@"20.0" forKey:@"controlCenterModuleArtworkCornerRadius"];
	}

	if (enabled) {
		if (enableLockscreenSection) %init(VioletLockscreen);
		if (enableHomescreenSection) %init(VioletHomescreen);
		if (enableControlCenterSection) %init(ControlCenter);
		%init(VioletSpringBoardData);
		if (roundLockScreenCompatibilitySwitch || hideXenHTMLWidgetsSwitch) %init(TweakCompatibility);
        return;
    }

}
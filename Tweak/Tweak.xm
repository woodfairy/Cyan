#import "Cyan.h"
#import "MusicLyricsBackgroundView.h"

BOOL enabled;
BOOL enableLockscreenSection;
BOOL enableHomescreenSection;
BOOL enableControlCenterSection;
BOOL ccWorkaround;

// Lockscreen
BOOL lockscreenArtworkBackgroundSwitch = NO;
NSString* lockscreenArtworkBlurMode = @"0";
NSString* lockscreenArtworkBlurAmountValue = @"0.99";
NSString* lockscreenArtworkOpacityValue = @"1.0";
NSString* lockscreenArtworkDimValue = @"0.0";
BOOL lockscreenPlayerArtworkBackgroundSwitch = NO;
NSString* lockscreenPlayerArtworkBlurMode = @"0";
NSString* lockscreenPlayerArtworkBlurAmountValue = @"1.0";
NSString* lockscreenPlayerArtworkOpacityValue = @"1.0";
NSString* lockscreenPlayerArtworkCornerRadiusValue = @"10.0";
NSString* lockscreenPlayerArtworkDimValue = @"0.0";
BOOL hideLockscreenPlayerBackgroundSwitch = NO;
BOOL roundLockScreenCompatibilitySwitch = NO;
BOOL hideXenHTMLWidgetsSwitch = NO;

// Homescreen
BOOL homescreenArtworkBackgroundSwitch = NO;
NSString* homescreenArtworkBlurMode = @"0";
NSString* homescreenArtworkBlurAmountValue = @"1.0";
NSString* homescreenArtworkOpacityValue = @"1.0";
NSString* homescreenArtworkDimValue = @"0.0";
BOOL zoomedViewSwitch = YES;

// Control Center
BOOL controlCenterArtworkBackgroundSwitch = NO;
NSString* controlCenterArtworkBlurMode = @"0";
NSString* controlCenterArtworkBlurAmountValue = @"1.0";
NSString* controlCenterArtworkOpacityValue = @"1.0";
NSString* controlCenterArtworkDimValue = @"1.0";
BOOL controlCenterModuleArtworkBackgroundSwitch = NO;
NSString* controlCenterModuleArtworkBlurMode = @"0";
NSString* controlCenterModuleArtworkBlurAmountValue = @"1.0";
NSString* controlCenterModuleArtworkOpacityValue = @"1.0";
NSString* controlCenterModuleArtworkDimValue = @"1.0";
NSString* controlCenterModuleArtworkCornerRadiusValue = @"20.0";

// Lockscreen

%group CyanLockscreen

%hook MTLTextureDescriptorInternal
-(BOOL)validateWithDevice:(id)arg1 {
	//NSLog(@"validateWithDevice %@", arg1);
	return %orig;
}
%end

%hook CSCoverSheetViewController

- (void)viewDidLoad { // add artwork background view
	%orig;

	if (!lockscreenArtworkBackgroundSwitch) 
		return;

	if (!lsArtworkBackgroundView) 
		lsArtworkBackgroundView = [[UIView alloc] initWithFrame:[[self view] bounds]];

	[lsArtworkBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[lsArtworkBackgroundView setContentMode:UIViewContentModeScaleAspectFill];
	[lsArtworkBackgroundView setHidden:YES];
	[lsArtworkBackgroundView setClipsToBounds:YES];
	[lsArtworkBackgroundView setAlpha:[lockscreenArtworkOpacityValue doubleValue]];

	if ([lockscreenArtworkBlurMode intValue] != 0) {
		if (!lsBlur) {
			if ([lockscreenArtworkBlurMode intValue] == 1)
				lsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			else if ([lockscreenArtworkBlurMode intValue] == 2)
				lsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			else if ([lockscreenArtworkBlurMode intValue] == 3)
				lsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
			lsBlurView = [[UIVisualEffectView alloc] initWithEffect:lsBlur];
			[lsBlurView setFrame:[lsArtworkBackgroundView bounds]];
			[lsBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[lsBlurView setClipsToBounds:YES];
			[lsBlurView setAlpha:[lockscreenArtworkBlurAmountValue doubleValue]];
			[lsArtworkBackgroundView addSubview:lsBlurView];
		}
		[lsBlurView setHidden:NO];
	}

	if ([lockscreenArtworkDimValue doubleValue] != 0.0) {
		if (!lsDimView) lsDimView = [[UIView alloc] init];
		[lsDimView setFrame:[lsArtworkBackgroundView bounds]];
		[lsDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[lsDimView setClipsToBounds:YES];
		[lsDimView setBackgroundColor:[UIColor blackColor]];
		[lsDimView setAlpha:[lockscreenArtworkDimValue doubleValue]];
		[lsDimView setHidden:NO];

		if (![lsDimView isDescendantOfView:lsArtworkBackgroundView])
			[lsArtworkBackgroundView addSubview:lsDimView];
	}

	// Metal Lyrics Background
	[musicAppBundle load];

	if(currentArtwork && !artworkCatalog)
		artworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];

	if(!lsMetalBackgroundView)
		lsMetalBackgroundView = [%c(MusicLyricsBackgroundView) new];

	if(artworkCatalog)
		[lsMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];

	[lsMetalBackgroundView setFrame:[lsArtworkBackgroundView bounds]];
	[lsMetalBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[lsMetalBackgroundView setClipsToBounds:YES];

	// add metal background as subview
	if(![lsMetalBackgroundView isDescendantOfView:lsArtworkBackgroundView])
		[lsArtworkBackgroundView addSubview:lsMetalBackgroundView];

	[lsArtworkBackgroundView setHidden:YES];

	if (![lsArtworkBackgroundView isDescendantOfView:[self view]])
		[[self view] insertSubview:lsArtworkBackgroundView atIndex:0];
		// hide the view (else it will show up after respring even if nothing is playing)
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

		if (!lockscreenPlayerArtworkBackgroundSwitch) 
			return;
		if (currentArtwork)
			[self clearMaterialViewBackground];
		else
			[self setMaterialViewBackground];
		if (!lspArtworkBackgroundView) {
			lspArtworkBackgroundView = [[UIView alloc] init];
			[lspArtworkBackgroundView setContentMode:UIViewContentModeScaleAspectFill];
			[lspArtworkBackgroundView setHidden:NO];
			[lspArtworkBackgroundView setClipsToBounds:YES];
		}
		
		[lspArtworkBackgroundView setFrame:[AdjunctItemView bounds]];
		lockscreenPlayerArtworkOpacityValue = [lockscreenPlayerArtworkOpacityValue doubleValue] == 1 ? @"0.99" : lockscreenPlayerArtworkOpacityValue;
		[lspArtworkBackgroundView setAlpha:[lockscreenPlayerArtworkOpacityValue doubleValue]];
		[[lspArtworkBackgroundView layer] setCornerRadius:[lockscreenPlayerArtworkCornerRadiusValue doubleValue]];
		
		// Metal Lyrics Background
		[musicAppBundle load];

		if(currentArtwork && !artworkCatalog)
			artworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];
			
		if(!lspMetalBackgroundView)
			lspMetalBackgroundView = [%c(MusicLyricsBackgroundView) new];

		if(artworkCatalog)
			[lspMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];

		[lspMetalBackgroundView setFrame:[lspArtworkBackgroundView bounds]];
		[lspMetalBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[lspMetalBackgroundView setClipsToBounds:YES];

		// add metal background as subview
		if(![lspMetalBackgroundView isDescendantOfView:lspArtworkBackgroundView])
			[lspArtworkBackgroundView addSubview:lspMetalBackgroundView];

		if (![lspArtworkBackgroundView isDescendantOfView:AdjunctItemView])
			[AdjunctItemView insertSubview:lspArtworkBackgroundView atIndex:0];		
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
	return;
	UIView* AdjunctItemView = [[[[[self view] superview] superview] superview] superview];

	UIView* platterView = MSHookIvar<UIView *>(AdjunctItemView, "_platterView");
	MTMaterialView* MTView = MSHookIvar<MTMaterialView *>(platterView, "_backgroundView");
	MTMaterialLayer* MTLayer = (MTMaterialLayer *)[MTView layer];
	[MTLayer setScale:1];
	[MTLayer mt_setColorMatrixDrivenOpacity:1 removingIfIdentity:false];

}

%end

%end

%group CyanHomescreen

%hook SBIconController

- (void)viewDidLoad { // add artwork background view

	%orig;

	if (!homescreenArtworkBackgroundSwitch)
		return;
	if (!hsArtworkBackgroundView)
		hsArtworkBackgroundView = [[UIView alloc] initWithFrame:[[self view] bounds]];
	if (zoomedViewSwitch)
		hsArtworkBackgroundView.bounds = CGRectInset(hsArtworkBackgroundView.frame, -50, -50);
	[hsArtworkBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[hsArtworkBackgroundView setContentMode:UIViewContentModeScaleAspectFill];
	[hsArtworkBackgroundView setHidden:YES];
	[hsArtworkBackgroundView setClipsToBounds:YES];
	[hsArtworkBackgroundView setAlpha:[homescreenArtworkOpacityValue doubleValue]];

	if ([homescreenArtworkBlurMode intValue] != 0) {
		if (!hsBlur) {
			if ([homescreenArtworkBlurMode intValue] == 1)
				hsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			else if ([homescreenArtworkBlurMode intValue] == 2)
				hsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			else if ([homescreenArtworkBlurMode intValue] == 3)
				hsBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
			hsBlurView = [[UIVisualEffectView alloc] initWithEffect:hsBlur];
			[hsBlurView setFrame:[hsArtworkBackgroundView bounds]];
			[hsBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[hsBlurView setClipsToBounds:YES];
			[hsBlurView setAlpha:[homescreenArtworkBlurAmountValue doubleValue]];
			[hsArtworkBackgroundView addSubview:hsBlurView];
		}
		[hsBlurView setHidden:NO];
	}

	if ([homescreenArtworkDimValue doubleValue] != 0.0) {
		if (!hsDimView) hsDimView = [[UIView alloc] init];
		[hsDimView setFrame:[hsArtworkBackgroundView bounds]];
		[hsDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[hsDimView setClipsToBounds:YES];
		[hsDimView setBackgroundColor:[UIColor blackColor]];
		[hsDimView setAlpha:[homescreenArtworkDimValue doubleValue]];
		[hsDimView setHidden:NO];

		if (![hsDimView isDescendantOfView:hsArtworkBackgroundView])
			[hsArtworkBackgroundView addSubview:hsDimView];
	}

	// Metal Lyrics Background
	[musicAppBundle load];

	if(currentArtwork && !artworkCatalog)
		artworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];

	if(!hsMetalBackgroundView)
		hsMetalBackgroundView = [%c(MusicLyricsBackgroundView) new];

	if(artworkCatalog)
		[hsMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];

	[hsMetalBackgroundView setFrame:[hsArtworkBackgroundView bounds]];
    [hsMetalBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [hsMetalBackgroundView setClipsToBounds:YES];

	// add metal background as subview
	if(![hsMetalBackgroundView isDescendantOfView:hsArtworkBackgroundView])
		[hsArtworkBackgroundView addSubview:hsMetalBackgroundView];

	if (![hsArtworkBackgroundView isDescendantOfView:[self view]])
		[[self view] insertSubview:hsArtworkBackgroundView atIndex:0];

}

%end

%end

%group ControlCenter

%hook CCUIModularControlCenterOverlayViewController

- (void)viewWillAppear:(BOOL)animated { // add artwork background view

	%orig;

	if (!controlCenterArtworkBackgroundSwitch) return;
	if (!ccArtworkBackgroundView) ccArtworkBackgroundView = [[UIView alloc] initWithFrame:[[self view] bounds]];
	[ccArtworkBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[ccArtworkBackgroundView setContentMode:UIViewContentModeScaleAspectFill];
	[ccArtworkBackgroundView setClipsToBounds:YES];
	[ccArtworkBackgroundView setAlpha:[controlCenterArtworkOpacityValue doubleValue]];

	if ([controlCenterArtworkBlurMode intValue] != 0) {
		if (!ccBlur) {
			if ([controlCenterArtworkBlurMode intValue] == 1)
				ccBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
			else if ([controlCenterArtworkBlurMode intValue] == 2)
				ccBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
			else if ([controlCenterArtworkBlurMode intValue] == 3)
				ccBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
			ccBlurView = [[UIVisualEffectView alloc] initWithEffect:ccBlur];
			[ccBlurView setFrame:[ccArtworkBackgroundView bounds]];
			[ccBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[ccBlurView setClipsToBounds:YES];
			[ccBlurView setAlpha:[controlCenterArtworkBlurAmountValue doubleValue]];
			[ccArtworkBackgroundView addSubview:ccBlurView];
		}
		[ccBlurView setHidden:NO];
	}

	if ([controlCenterArtworkDimValue doubleValue] != 0.0) {
		if (!ccDimView) ccDimView = [[UIView alloc] init];
		[ccDimView setFrame:[ccArtworkBackgroundView bounds]];
		[ccDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[ccDimView setClipsToBounds:YES];
		[ccDimView setBackgroundColor:[UIColor blackColor]];
		[ccDimView setAlpha:[controlCenterArtworkDimValue doubleValue]];
		[ccDimView setHidden:NO];

		if (![ccDimView isDescendantOfView:ccArtworkBackgroundView])
			[ccArtworkBackgroundView addSubview:ccDimView];
	}

	// Metal Lyrics Background
	[musicAppBundle load];

	if(currentArtwork && !artworkCatalog) 
		artworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];

	if(!ccMetalBackgroundView)
		ccMetalBackgroundView = [%c(MusicLyricsBackgroundView) new];

	if(artworkCatalog)
		[ccMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];

	[ccMetalBackgroundView setFrame:[ccArtworkBackgroundView bounds]];
    [ccMetalBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [ccMetalBackgroundView setClipsToBounds:YES];

	// add metal background as subview
	if(![ccMetalBackgroundView isDescendantOfView:ccArtworkBackgroundView])
		[ccArtworkBackgroundView addSubview:ccMetalBackgroundView];

	if (![ccArtworkBackgroundView isDescendantOfView:[self view]])
		[[self view] insertSubview:ccArtworkBackgroundView atIndex:1];
	
	[ccArtworkBackgroundView setHidden:!currentArtwork];

}

- (void)dismissAnimated:(BOOL)arg1 withCompletionHandler:(id)arg2 { // hide cc background earlier than it would otherwise

	%orig;
	
	[ccArtworkBackgroundView setHidden:YES];

}

%end

%hook CCUIContentModuleContainerViewController

- (void)viewWillAppear:(BOOL)animated { // add artwork background view

	%orig;
	
	if (!controlCenterModuleArtworkBackgroundSwitch) return;
	if ([[self moduleIdentifier] isEqual:@"com.apple.mediaremote.controlcenter.nowplaying"]) {
		if (!ccmArtworkBackgroundView) ccmArtworkBackgroundView = [[UIView alloc] initWithFrame:[[[self contentViewController] view] bounds]];
		[ccmArtworkBackgroundView setContentMode:UIViewContentModeScaleAspectFill];
		[ccmArtworkBackgroundView setHidden:NO];
		[ccmArtworkBackgroundView setClipsToBounds:YES];
		[ccmArtworkBackgroundView setAlpha:[controlCenterModuleArtworkOpacityValue doubleValue]];
		[[ccmArtworkBackgroundView layer] setCornerRadius:[[self moduleContentView] compactContinuousCornerRadius]];

		if ([controlCenterModuleArtworkBlurMode intValue] != 0) {
			if (!ccmBlur) {
				if ([controlCenterModuleArtworkBlurMode intValue] == 1)
					ccmBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
				else if ([controlCenterModuleArtworkBlurMode intValue] == 2)
					ccmBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
				else if ([controlCenterModuleArtworkBlurMode intValue] == 3)
					ccmBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
				ccmBlurView = [[UIVisualEffectView alloc] initWithEffect:ccmBlur];
				[ccmBlurView setFrame:[ccmArtworkBackgroundView bounds]];
				[ccmBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
				[ccmBlurView setClipsToBounds:YES];
				[ccmBlurView setAlpha:[controlCenterModuleArtworkBlurAmountValue doubleValue]];
				[ccmArtworkBackgroundView addSubview:ccmBlurView];
			}
			[ccmBlurView setHidden:NO];
		}

		if ([controlCenterModuleArtworkDimValue doubleValue] != 0.0) {
			if (!ccmDimView) ccmDimView = [[UIView alloc] init];
			[ccmDimView setFrame:[ccmArtworkBackgroundView bounds]];
			[ccmDimView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[ccmDimView setClipsToBounds:YES];
			[ccmDimView setBackgroundColor:[UIColor blackColor]];
			[ccmDimView setAlpha:[controlCenterModuleArtworkDimValue doubleValue]];
			[ccmDimView setHidden:NO];

			if (![ccmDimView isDescendantOfView:ccmArtworkBackgroundView])
				[ccmArtworkBackgroundView addSubview:ccmDimView];
		}

		// Metal Lyrics Background
		[musicAppBundle load];

		if(currentArtwork) {
			if(!artworkCatalog)
				artworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];
		} else {
			[ccmArtworkBackgroundView setHidden:YES];
		}

		if(!ccmMetalBackgroundView)
			ccmMetalBackgroundView = [%c(MusicLyricsBackgroundView) new];

		if(artworkCatalog)
			[ccmMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];

		[ccmMetalBackgroundView setFrame:[ccmArtworkBackgroundView bounds]];
    	[ccmMetalBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    	[ccmMetalBackgroundView setClipsToBounds:YES];

		// add metal background as subview
		if(![ccmMetalBackgroundView isDescendantOfView:ccmArtworkBackgroundView])
			[ccmArtworkBackgroundView addSubview:ccmMetalBackgroundView];

		if (![ccmArtworkBackgroundView isDescendantOfView:[self view]])
			[[self view] insertSubview:ccmArtworkBackgroundView atIndex:0];
	}

}

- (void)setExpanded:(BOOL)arg1 { // hide artwork when expanded

	%orig;

	if (arg1 && [[self moduleIdentifier] isEqual:@"com.apple.mediaremote.controlcenter.nowplaying"])
		[ccmArtworkBackgroundView setHidden:YES];

}

%end

%end

// Data

%group CyanSpringBoardData

%hook SBMediaController

- (void)setNowPlayingInfo:(id)arg1 { // get and set the artwork

    %orig;

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
		if (information) {
			NSDictionary* dict = (__bridge NSDictionary *)information;
			currentArtwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
			if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
				if (currentArtwork) {
					artworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];
					if (lockscreenArtworkBackgroundSwitch) {
						if(lsMetalBackgroundView && artworkCatalog) [lsMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];
						[lsArtworkBackgroundView setHidden:NO];
					}
					if (lockscreenPlayerArtworkBackgroundSwitch) {
						if(lspMetalBackgroundView && artworkCatalog) [lspMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];
						[lspArtworkBackgroundView setHidden:NO];
					}
					if (homescreenArtworkBackgroundSwitch) {
						if(hsMetalBackgroundView && artworkCatalog) [hsMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];
						[hsArtworkBackgroundView setHidden:NO];
					}
					if (controlCenterArtworkBackgroundSwitch) {
						if(ccMetalBackgroundView && artworkCatalog) [ccMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];
						[ccArtworkBackgroundView setHidden:NO];
					}
					if (controlCenterModuleArtworkBackgroundSwitch) {
						if(ccmMetalBackgroundView && artworkCatalog) [ccmMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];
						[ccmArtworkBackgroundView setHidden:NO];
					}
				}
			}
		} else {
			// this works around an issue which leads to safe mode if playback is stopped (still testing if it is true)
			if([lspMetalBackgroundView isDescendantOfView:lspArtworkBackgroundView] && lspMetalBackgroundView)
				[lspMetalBackgroundView removeFromSuperview];
			[lsArtworkBackgroundView setHidden:YES];
			[lspArtworkBackgroundView setHidden:YES];
			[hsArtworkBackgroundView setHidden:YES];
			[ccArtworkBackgroundView setHidden:YES];
			[ccmArtworkBackgroundView setHidden:YES];
			[ccBlurView setHidden:YES];
			currentArtwork = nil;
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
		[[lsArtworkBackgroundView layer] setCornerRadius:38];

}

- (void)viewWillDisappear:(BOOL)animated { // roundlockscreen compatibility

	%orig;
	if (roundLockScreenCompatibilitySwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/RoundLockScreen.dylib"])
		[[lsArtworkBackgroundView layer] setCornerRadius:38];

}

- (void)viewDidAppear:(BOOL)animated { // roundlockscreen compatibility

	%orig;

	if (roundLockScreenCompatibilitySwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/RoundLockScreen.dylib"])
		[[lsArtworkBackgroundView layer] setCornerRadius:0];

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
	preferences = [[HBPreferences alloc] initWithIdentifier:@"0xcc.woodfairy.cyanpreferences"];

    [preferences registerBool:&enabled default:nil forKey:@"Enabled"];
	[preferences registerBool:&enableLockscreenSection default:nil forKey:@"EnableLockscreenSection"];
	[preferences registerBool:&enableHomescreenSection default:nil forKey:@"EnableHomescreenSection"];
	[preferences registerBool:&enableControlCenterSection default:nil forKey:@"EnableControlCenterSection"];

	NSString *path = [%c(LSApplicationProxy) applicationProxyForIdentifier:@"com.apple.Music"].bundleURL.resourceSpecifier;
	path = [path stringByAppendingPathComponent:@"Frameworks/MusicApplication.framework/"];
	musicAppBundle = [NSBundle bundleWithPath:path];

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
		[preferences registerObject:&controlCenterModuleArtworkBlurMode default:@"0" forKey:@"controlCenterModuleArtworkBlur"];
		[preferences registerObject:&controlCenterModuleArtworkBlurAmountValue default:@"1.0" forKey:@"controlCenterModuleArtworkBlurAmount"];
		[preferences registerObject:&controlCenterModuleArtworkOpacityValue default:@"1.0" forKey:@"controlCenterModuleArtworkOpacity"];
		[preferences registerObject:&controlCenterModuleArtworkDimValue default:@"0.0" forKey:@"controlCenterModuleArtworkDim"];
	}

	if (enabled) {
		if (enableLockscreenSection) %init(CyanLockscreen);
		if (enableHomescreenSection) %init(CyanHomescreen);
		if (enableControlCenterSection) %init(ControlCenter);
		%init(CyanSpringBoardData);
		if (roundLockScreenCompatibilitySwitch || hideXenHTMLWidgetsSwitch) %init(TweakCompatibility);
        return;
    }

}
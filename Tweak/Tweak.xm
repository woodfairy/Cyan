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
CSCoverSheetViewController *lockScreen;

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

UIImage *wallpaperImage;

@interface SBFStaticWallpaperImageView : UIImageView
@property (nonatomic,retain) UIImage *image; 
@end

%hook SBFStaticWallpaperImageView
-(id)initWithImage:(UIImage *)image {
	wallpaperImage = image;
	return %orig(image);
}
-(void)setImage:(UIImage *)image {
	wallpaperImage = image;
	%orig(image);
}
%end

%hook CSCoverSheetView
-(void)updateUIForAuthenticated:(BOOL)arg1 { // request to install Music app if not installed
	%orig;

	if (arg1) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			NSString *path = [%c(LSApplicationProxy) applicationProxyForIdentifier:@"com.apple.Music"].bundleURL.resourceSpecifier;
			path = [path stringByAppendingPathComponent:@"Frameworks/MusicApplication.framework/"];
			if (!path) {
				UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cyan"
											message:@"Apple Music application is not installed on your device.\n Please install it in order to use Cyan."
											preferredStyle:UIAlertControllerStyleAlert];

				UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Install" style:UIAlertActionStyleDefault
				handler:^(UIAlertAction * action) {
					NSURL *URL = [NSURL URLWithString:@"https://apps.apple.com/us/app/apple-music/id1108187390"];
					[[UIApplication sharedApplication] openURL:URL];
					[[objc_getClass("SBLockScreenManager") sharedInstance] lockScreenViewControllerRequestsUnlock];
				}];

				UIAlertAction* dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault
				handler:^(UIAlertAction * action) {}];

				[alert addAction:defaultAction];
				[alert addAction:dismissAction];
				[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
				return;
			}
		});
	}
}
%end

%hook CSCoverSheetViewController
- (void)viewDidLoad { // add artwork background view
	%orig;
	
	lockScreen = self;
	
	if (!lockscreenArtworkBackgroundSwitch)
    return;

	if (!lsArtworkBackgroundImageView)
    lsArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];

	// Metal Lyrics Background
	NSString *path = [%c(LSApplicationProxy) applicationProxyForIdentifier:@"com.apple.Music"].bundleURL.resourceSpecifier;
	path = [path stringByAppendingPathComponent:@"Frameworks/MusicApplication.framework/"];
	if (!path) return; // return if Music app is not installed
	[[NSBundle bundleWithPath:path] load];

	if (!currentArtwork && ![[%c(SBMediaController) sharedInstance] isPlaying])
		currentArtwork = wallpaperImage;

	if(currentArtwork && !artworkCatalog)
		artworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];

	if(!lsMetalBackgroundView) {
		lsMetalBackgroundView = [%c(MusicLyricsBackgroundView) new];
		[lsMetalBackgroundView.layer setOpaque:NO];
		MTKView *view = [lsMetalBackgroundView subviews][0];
		[(CAMetalLayer*)[view layer] setLowLatency:NO];
	}

	if(artworkCatalog)
		[lsMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];

	[lsMetalBackgroundView setFrame:[lsArtworkBackgroundImageView bounds]];
	[lsMetalBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[lsMetalBackgroundView setClipsToBounds:YES];

	// add metal background as subview
	if(![lsMetalBackgroundView isDescendantOfView:lsArtworkBackgroundImageView])
		[lsArtworkBackgroundImageView addSubview:lsMetalBackgroundView];

	[lsArtworkBackgroundImageView setHidden:YES];
	[lsArtworkBackgroundImageView setImage:nil];

	if (![lsArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:lsArtworkBackgroundImageView atIndex:0];
		// hide the view (else it will show up after respring even if nothing is playing)
}

%new
-(void)updatePlaybackState {
    MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_get_main_queue(), ^(Boolean isPlayingNow){
		MTKView *view = [lsMetalBackgroundView subviews][0];
        [view setPaused:!isPlayingNow];
    });
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
		if (!lspArtworkBackgroundImageView) {
			lspArtworkBackgroundImageView = [[UIImageView alloc] init];
			[lspArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
			[lspArtworkBackgroundImageView setHidden:NO];
			[lspArtworkBackgroundImageView setClipsToBounds:YES];
		}
		
		[lspArtworkBackgroundImageView setFrame:[AdjunctItemView bounds]];
		[lspArtworkBackgroundImageView setAlpha:[@"0.99" doubleValue]];
		[[lspArtworkBackgroundImageView layer] setCornerRadius:[lockscreenPlayerArtworkCornerRadiusValue doubleValue]];
		
		// Metal Lyrics Background
		NSString *path = [%c(LSApplicationProxy) applicationProxyForIdentifier:@"com.apple.Music"].bundleURL.resourceSpecifier;
		path = [path stringByAppendingPathComponent:@"Frameworks/MusicApplication.framework/"];
		[[NSBundle bundleWithPath:path] load];

		if(currentArtwork && !artworkCatalog)
			artworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];
			
		if(!lspMetalBackgroundView)
			lspMetalBackgroundView = [%c(MusicLyricsBackgroundView) new];

		if(artworkCatalog)
			[lspMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];

		[lspMetalBackgroundView setFrame:[lspArtworkBackgroundImageView bounds]];
		[lspMetalBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[lspMetalBackgroundView setClipsToBounds:YES];

		// add metal background as subview
		if(![lspMetalBackgroundView isDescendantOfView:lspArtworkBackgroundImageView])
			[lspArtworkBackgroundImageView addSubview:lspMetalBackgroundView];

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
	if (!hsArtworkBackgroundImageView)
		hsArtworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
	if (zoomedViewSwitch)
		hsArtworkBackgroundImageView.bounds = CGRectInset(hsArtworkBackgroundImageView.frame, -50, -50);
	[hsArtworkBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[hsArtworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
	[hsArtworkBackgroundImageView setHidden:YES];
	[hsArtworkBackgroundImageView setClipsToBounds:YES];
	[hsArtworkBackgroundImageView setAlpha:[homescreenArtworkOpacityValue doubleValue]];

	// Metal Lyrics Background
	NSString *path = [%c(LSApplicationProxy) applicationProxyForIdentifier:@"com.apple.Music"].bundleURL.resourceSpecifier;
	path = [path stringByAppendingPathComponent:@"Frameworks/MusicApplication.framework/"];
	[[NSBundle bundleWithPath:path] load];

	if(currentArtwork && !artworkCatalog)
		artworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];

	if(!hsMetalBackgroundView)
		hsMetalBackgroundView = [%c(MusicLyricsBackgroundView) new];

	if(artworkCatalog)
		[hsMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];

	[hsMetalBackgroundView setFrame:[hsArtworkBackgroundImageView bounds]];
    [hsMetalBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [hsMetalBackgroundView setClipsToBounds:YES];

	// add metal background as subview
	if(![hsMetalBackgroundView isDescendantOfView:hsArtworkBackgroundImageView])
		[hsArtworkBackgroundImageView addSubview:hsMetalBackgroundView];

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

	// Metal Lyrics Background
	NSString *path = [%c(LSApplicationProxy) applicationProxyForIdentifier:@"com.apple.Music"].bundleURL.resourceSpecifier;
	path = [path stringByAppendingPathComponent:@"Frameworks/MusicApplication.framework/"];
	[[NSBundle bundleWithPath:path] load];

	if(currentArtwork && !artworkCatalog) 
		artworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];

	if(!ccMetalBackgroundView)
		ccMetalBackgroundView = [%c(MusicLyricsBackgroundView) new];

	if(artworkCatalog)
		[ccMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];

	[ccMetalBackgroundView setFrame:[ccArtworkBackgroundImageView bounds]];
    [ccMetalBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [ccMetalBackgroundView setClipsToBounds:YES];

	// add metal background as subview
	if(![ccMetalBackgroundView isDescendantOfView:ccArtworkBackgroundImageView])
		[ccArtworkBackgroundImageView addSubview:ccMetalBackgroundView];

	if (![ccArtworkBackgroundImageView isDescendantOfView:[self view]])
		[[self view] insertSubview:ccArtworkBackgroundImageView atIndex:1];
	
	[ccArtworkBackgroundImageView setHidden:!currentArtwork];

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
		[[ccmArtworkBackgroundImageView layer] setCornerRadius:[[self moduleContentView] compactContinuousCornerRadius]];

		// Metal Lyrics Background
		NSString *path = [%c(LSApplicationProxy) applicationProxyForIdentifier:@"com.apple.Music"].bundleURL.resourceSpecifier;
		path = [path stringByAppendingPathComponent:@"Frameworks/MusicApplication.framework/"];
		[[NSBundle bundleWithPath:path] load];

		if(currentArtwork) {
			if(!artworkCatalog)
				artworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];
		} else {
			[ccmArtworkBackgroundImageView setHidden:YES];
		}

		if(!ccmMetalBackgroundView)
			ccmMetalBackgroundView = [%c(MusicLyricsBackgroundView) new];

		if(artworkCatalog)
			[ccmMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];

		[ccmMetalBackgroundView setFrame:[ccmArtworkBackgroundImageView bounds]];
    	[ccmMetalBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    	[ccmMetalBackgroundView setClipsToBounds:YES];

		// add metal background as subview
		if(![ccmMetalBackgroundView isDescendantOfView:ccmArtworkBackgroundImageView])
			[ccmArtworkBackgroundImageView addSubview:ccmMetalBackgroundView];

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

%group CyanSpringBoardData

%hook SBMediaController

- (void)setNowPlayingInfo:(id)arg1 { // get and set the artwork

    %orig;

	MRMediaRemoteRegisterForNowPlayingNotifications(dispatch_get_main_queue());
	[[NSNotificationCenter defaultCenter] addObserver:lockScreen selector:@selector(updatePlaybackState) name:(__bridge NSString *)kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification object:nil];

    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
		if (information) {
			NSDictionary* dict = (__bridge NSDictionary *)information;
			currentArtwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
			if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
				if (currentArtwork) {
					artworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];
					if (lockscreenArtworkBackgroundSwitch) {
						//artWorkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];
						if(lsMetalBackgroundView && artworkCatalog) [lsMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];
						[lsArtworkBackgroundImageView setHidden:NO];
					}
					if (lockscreenPlayerArtworkBackgroundSwitch) {
						//lspArtworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];
						if(lspMetalBackgroundView && artworkCatalog) [lspMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];
						[lspArtworkBackgroundImageView setHidden:NO];
					}
					if (homescreenArtworkBackgroundSwitch) {
						//hsArtworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];
						if(hsMetalBackgroundView && artworkCatalog) [hsMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];
						[hsArtworkBackgroundImageView setHidden:NO];
					}
					if (controlCenterArtworkBackgroundSwitch) {
						//ccArtworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];
						if(ccMetalBackgroundView && artworkCatalog) [ccMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];
						//NSLog(@"SHOW in notif");
						[ccArtworkBackgroundImageView setHidden:NO];
					}
					if (controlCenterModuleArtworkBackgroundSwitch) {
						//ccmArtworkCatalog = [%c(MPArtworkCatalog) staticArtworkCatalogWithImage:currentArtwork];
						if(ccmMetalBackgroundView && artworkCatalog) [ccmMetalBackgroundView setBackgroundArtworkCatalog:artworkCatalog];
						[ccmArtworkBackgroundImageView setHidden:NO];
					}
				}
			}
		} else {
			//[lsMetalBackgroundView setHidden:YES];
			[lspArtworkBackgroundImageView setHidden:YES];
			[hsArtworkBackgroundImageView setHidden:YES];
			NSLog(@"HIDE in notif");
			[ccArtworkBackgroundImageView setHidden:YES];
			[ccmArtworkBackgroundImageView setHidden:YES];
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
	preferences = [[HBPreferences alloc] initWithIdentifier:@"0xcc.woodfairy.cyanpreferences"];

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
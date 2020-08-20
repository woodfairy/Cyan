#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <MediaRemote/MediaRemote.h>
#import "MusicLyricsBackgroundView.h"

HBPreferences* preferences;

extern BOOL enabled;
extern BOOL enableLockscreenSection;
extern BOOL enableHomescreenSection;
extern BOOL enableControlCenterSection;

MPArtworkCatalog* artworkCatalog;

MusicLyricsBackgroundView* lsMetalBackgroundView;
MusicLyricsBackgroundView* lspMetalBackgroundView;
MusicLyricsBackgroundView* hsMetalBackgroundView;
MusicLyricsBackgroundView* ccMetalBackgroundView;
MusicLyricsBackgroundView* ccmMetalBackgroundView;

UIImage* currentArtwork;
UIImageView* lsArtworkBackgroundImageView;
UIImageView* lspArtworkBackgroundImageView;
UIImageView* hsArtworkBackgroundImageView;
UIImageView* ccArtworkBackgroundImageView;
UIImageView* ccmArtworkBackgroundImageView;
UIImageView* musicArtworkBackgroundImageView;
UIVisualEffectView* ccBlurView;
UIBlurEffect* ccBlur;
UIVisualEffectView* ccmBlurView;
UIBlurEffect* ccmBlur;
UIView* lsDimView;
UIView* lspDimView;
UIView* hsDimView;
UIView* ccDimView;
UIView* ccmDimView;

@interface CSCoverSheetView : UIView
-(BOOL)scrollToPageAtIndex:(unsigned long long)arg1 animated:(BOOL)arg2 withCompletion:(/*^block*/id)arg3 ;
@end

@interface SBLockScreenManager : NSObject
-(void)lockScreenViewControllerRequestsUnlock;
@end

@interface CSCoverSheetViewController : UIViewController
@end

@interface MRPlatterViewController : UIViewController
@property(nonatomic, copy)NSString* label;
- (void)setMaterialViewBackground;
- (void)clearMaterialViewBackground;
@end

@interface MTMaterialView : UIView
@end

@interface CABackdropLayer : CALayer
@property(assign)double scale;
- (void)mt_setColorMatrixDrivenOpacity:(double)arg1 removingIfIdentity:(BOOL)arg2;
@end

@interface MTMaterialLayer : CABackdropLayer
@end

@interface UIView (Cyan)
@property(nonatomic, assign, readwrite)MTMaterialView* backgroundMaterialView;
@end

@interface SBIconController : UIViewController
@end

@interface CCUIModularControlCenterOverlayViewController : UIViewController
@end

@interface CCUIContentModuleContentContainerView : UIView
@property(assign, nonatomic)double compactContinuousCornerRadius;
@end

@interface CCUIContentModuleContainerViewController : UIViewController
@property(nonatomic, retain)UIViewController* contentViewController;
@property(nonatomic, readonly)CCUIContentModuleContentContainerView* moduleContentView;
- (NSString *)moduleIdentifier;
@end

@interface XENHWidgetLayerContainerView : UIView
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPaused;
- (BOOL)isPlaying;
@end
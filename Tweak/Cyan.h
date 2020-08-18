#import <UIKit/UIKit.h>
#import <Cephei/HBPreferences.h>
#import <MediaRemote/MediaRemote.h>

HBPreferences* preferences;

extern BOOL enabled;
extern BOOL enableLockscreenSection;
extern BOOL enableHomescreenSection;
extern BOOL enableControlCenterSection;

UIImage* currentArtwork;
UIImageView* lsArtworkBackgroundImageView;
UIImageView* lspArtworkBackgroundImageView;
UIImageView* hsArtworkBackgroundImageView;
UIImageView* ccArtworkBackgroundImageView;
UIImageView* ccmArtworkBackgroundImageView;
UIImageView* musicArtworkBackgroundImageView;
UIVisualEffectView* lsBlurView;
UIBlurEffect* lsBlur;
UIVisualEffectView* lspBlurView;
UIBlurEffect* lspBlur;
UIVisualEffectView* hsBlurView;
UIBlurEffect* hsBlur;
UIVisualEffectView* ccBlurView;
UIBlurEffect* ccBlur;
UIVisualEffectView* ccmBlurView;
UIBlurEffect* ccmBlur;
UIView* lsDimView;
UIView* lspDimView;
UIView* hsDimView;
UIView* ccDimView;
UIView* ccmDimView;

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

@interface CCUIContentModuleContainerViewController : UIViewController
@property(nonatomic, retain)UIViewController* contentViewController;
- (NSString *)moduleIdentifier;
@end

@interface XENHWidgetLayerContainerView : UIView
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPaused;
- (BOOL)isPlaying;
@end
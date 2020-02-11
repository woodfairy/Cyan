#line 1 "Tweak.x"
#import <UIKit/UIKit.h>



#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class UIView; @class UISlider; @class UIImageView; @class UIViewController; 
static void (*_logos_orig$_ungrouped$UIViewController$didMoveToWindow)(_LOGOS_SELF_TYPE_NORMAL UIViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$UIViewController$didMoveToWindow(_LOGOS_SELF_TYPE_NORMAL UIViewController* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$UIImageView$didMoveToWindow)(_LOGOS_SELF_TYPE_NORMAL UIImageView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$UIImageView$didMoveToWindow(_LOGOS_SELF_TYPE_NORMAL UIImageView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$UIView$didMoveToWindow)(_LOGOS_SELF_TYPE_NORMAL UIView* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$UIView$didMoveToWindow(_LOGOS_SELF_TYPE_NORMAL UIView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$UISlider$didMoveToWindow)(_LOGOS_SELF_TYPE_NORMAL UISlider* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$UISlider$didMoveToWindow(_LOGOS_SELF_TYPE_NORMAL UISlider* _LOGOS_SELF_CONST, SEL); 

#line 4 "Tweak.x"


static void _logos_method$_ungrouped$UIViewController$didMoveToWindow(_LOGOS_SELF_TYPE_NORMAL UIViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	self.view.backgroundColor = [UIColor redColor];

}





static void _logos_method$_ungrouped$UIImageView$didMoveToWindow(_LOGOS_SELF_TYPE_NORMAL UIImageView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	if ([NSStringFromClass([self.superview class]) isEqualToString:@"MusicApplication.NowPlayingTransportButton"] ||
		[NSStringFromClass([self.superview class]) isEqualToString:@"MPButton"] ||
		[NSStringFromClass([self.superview class]) isEqualToString:@"MPRouteButton"]) {
		self.tintColor = [UIColor redColor];

	}
	
}





static void _logos_method$_ungrouped$UIView$didMoveToWindow(_LOGOS_SELF_TYPE_NORMAL UIView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	if ([NSStringFromClass([self.superview class]) isEqualToString:@"MusicApplication.ContextualActionsButton"]) {
		self.tintColor = [UIColor redColor];

	}








}





static void _logos_method$_ungrouped$UISlider$didMoveToWindow(_LOGOS_SELF_TYPE_NORMAL UISlider* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

	self.tintColor = [UIColor redColor];

}

















static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$UIViewController = objc_getClass("UIViewController"); MSHookMessageEx(_logos_class$_ungrouped$UIViewController, @selector(didMoveToWindow), (IMP)&_logos_method$_ungrouped$UIViewController$didMoveToWindow, (IMP*)&_logos_orig$_ungrouped$UIViewController$didMoveToWindow);Class _logos_class$_ungrouped$UIImageView = objc_getClass("UIImageView"); MSHookMessageEx(_logos_class$_ungrouped$UIImageView, @selector(didMoveToWindow), (IMP)&_logos_method$_ungrouped$UIImageView$didMoveToWindow, (IMP*)&_logos_orig$_ungrouped$UIImageView$didMoveToWindow);Class _logos_class$_ungrouped$UIView = objc_getClass("UIView"); MSHookMessageEx(_logos_class$_ungrouped$UIView, @selector(didMoveToWindow), (IMP)&_logos_method$_ungrouped$UIView$didMoveToWindow, (IMP*)&_logos_orig$_ungrouped$UIView$didMoveToWindow);Class _logos_class$_ungrouped$UISlider = objc_getClass("UISlider"); MSHookMessageEx(_logos_class$_ungrouped$UISlider, @selector(didMoveToWindow), (IMP)&_logos_method$_ungrouped$UISlider$didMoveToWindow, (IMP*)&_logos_orig$_ungrouped$UISlider$didMoveToWindow);} }
#line 73 "Tweak.x"

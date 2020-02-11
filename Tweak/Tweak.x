#import <UIKit/UIKit.h>

// First try to color the now playing view
/*
%hook UIViewController

- (void)didMoveToWindow {

	self.view.backgroundColor = [UIColor redColor];

}

%end
*/
%hook UIImageView

- (void)didMoveToWindow {

	if ([NSStringFromClass([self.superview class]) isEqualToString:@"MusicApplication.NowPlayingTransportButton"] ||
		[NSStringFromClass([self.superview class]) isEqualToString:@"MPButton"] ||
		[NSStringFromClass([self.superview class]) isEqualToString:@"MPRouteButton"]) {
		self.tintColor = [UIColor redColor];

	}
	
}

%end

%hook UIView

- (void)didMoveToWindow {

	if ([NSStringFromClass([self.superview class]) isEqualToString:@"MusicApplication.ContextualActionsButton"]) {
		self.tintColor = [UIColor redColor];

	}

// Second try to color the now playing view
/*
	if ([NSStringFromClass([self.superview class]) isEqualToString:@"MusicApplication.NowPlayingViewController"]) {
		self.backgroundColor = [UIColor redColor];

	}
*/
}

%end

%hook UISlider

- (void)didMoveToWindow {

	self.tintColor = [UIColor redColor];

}

%end
// Fix later, supposed to color the song name label
/*
%hook UILabel

- (void)didMoveToWindow {

	if ([NSStringFromClass([self.superview class]) isEqualToString:@"MusicApplication.NowPlayingViewController"]) {
		self.textColor = [UIColor redColor];

	}

}

%end
*/
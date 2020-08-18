#import "VIORootListController.h"

@implementation VIOAppearanceSettings

- (UIColor *)tintColor {

    return [UIColor colorWithRed:0.00 green:1.00 blue:1.00 alpha:1.00];

}

- (UIColor *)statusBarTintColor {

    return [UIColor whiteColor];

}

- (UIColor *)navigationBarTitleColor {

    return [UIColor whiteColor];

}

- (UIColor *)navigationBarTintColor {

    return [UIColor whiteColor];

}

- (UIColor *)tableViewCellSeparatorColor {

    return [UIColor colorWithWhite:0 alpha:0];

}

- (UIColor *)navigationBarBackgroundColor {

    return [UIColor colorWithRed:0.00 green:1.00 blue:1.00 alpha:1.00];

}

- (BOOL)translucentNavigationBar {

    return YES;

}

- (NSUInteger)largeTitleStyle {

    return 2;
    
}

@end
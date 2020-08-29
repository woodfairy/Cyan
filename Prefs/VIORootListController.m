#include "VIORootListController.h"

BOOL enabled = NO;

UIBlurEffect* blur;
UIVisualEffectView* blurView;
UIImage* currentArtwork;
UIImageView* artworkBackgroundImageView;

@implementation VIORootListController

- (instancetype)init {

    self = [super init];

    if (self) {
        VIOAppearanceSettings* appearanceSettings = [[VIOAppearanceSettings alloc] init];
        self.hb_appearanceSettings = appearanceSettings;
        self.enableSwitch = [[UISwitch alloc] init];
        self.enableSwitch.onTintColor = [UIColor colorWithRed:0.57 green:0.90 blue:0.90 alpha:1.00];
        [self.enableSwitch addTarget:self action:@selector(toggleState) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* switchy = [[UIBarButtonItem alloc] initWithCustomView: self.enableSwitch];
        self.navigationItem.rightBarButtonItem = switchy;

        self.navigationItem.titleView = [UIView new];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,10,10)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.text = @"Cyan";
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.navigationItem.titleView addSubview:self.titleLabel];

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,10,10)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/CyanPrefs.bundle/icon@2x.png"];
        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconView.alpha = 0.0;
        [self.navigationItem.titleView addSubview:self.iconView];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
            [self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
        ]];
    }

    return self;

}

-(NSArray *)specifiers {

	if (_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    tableView.tableHeaderView = self.headerView;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;

    for (UIView* subview in [[self view] subviews]) {
        [subview setBackgroundColor:[UIColor clearColor]];
	}

    if (!artworkBackgroundImageView) artworkBackgroundImageView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
    [artworkBackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [artworkBackgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [artworkBackgroundImageView setHidden:YES];
    [artworkBackgroundImageView setClipsToBounds:YES];
    [artworkBackgroundImageView setAlpha:0.4];
    [[self view] insertSubview:artworkBackgroundImageView atIndex:0];
    [self setArtwork];

    self.navigationController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: 0.76 green: 0.67 blue: 1.00 alpha: 1.00];
    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationController.navigationBar.translucent = YES;

    blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    [blurView setFrame:[[self view] bounds]];
    [blurView setAlpha:1.0];
    [[self view] addSubview:blurView];

    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [blurView setAlpha:0.0];
    } completion:nil];

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    [self setEnableSwitchState];

}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];

    [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 200) {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 1.0;
            self.titleLabel.alpha = 0.0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 0.0;
            self.titleLabel.alpha = 1.0;
        }];
    }

}

- (void)toggleState {

    [[self enableSwitch] setEnabled:NO];

    NSString* path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/0xcc.woodfairy.cyanpreferences.plist"];
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSSet* allKeys = [NSSet setWithArray:[dictionary allKeys]];
    HBPreferences *preferences = [[HBPreferences alloc] initWithIdentifier: @"0xcc.woodfairy.cyanpreferences"];
    
    if (!([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/0xcc.woodfairy.cyanpreferences.plist"])) {
        enabled = YES;
        [preferences setBool:enabled forKey:@"Enabled"];
        [self respring];
    } else if (!([allKeys containsObject:@"Enabled"])) {
        enabled = YES;
        [preferences setBool:enabled forKey:@"Enabled"];
        [self respring];
    } else if ([[preferences objectForKey:@"Enabled"] isEqual:@(NO)]) {
        enabled = YES;
        [preferences setBool:enabled forKey:@"Enabled"];
        [self respring];
    } else if ([[preferences objectForKey:@"Enabled"] isEqual:@(YES)]) {
        enabled = NO;
        [preferences setBool:enabled forKey:@"Enabled"];
        [self respring];
    }

}

- (void)setEnableSwitchState {

    NSString* path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/0xcc.woodfairy.cyanpreferences.plist"];
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSSet* allKeys = [NSSet setWithArray:[dictionary allKeys]];
    HBPreferences* preferences = [[HBPreferences alloc] initWithIdentifier: @"0xcc.woodfairy.cyanpreferences"];
    
    if (!([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/0xcc.woodfairy.cyanpreferences.plist"]))
        [[self enableSwitch] setOn:NO animated:YES];
    else if (!([allKeys containsObject:@"Enabled"]))
        [[self enableSwitch] setOn:NO animated:YES];
    else if ([[preferences objectForKey:@"Enabled"] isEqual:@(YES)])
        [[self enableSwitch] setOn:YES animated:YES];
    else if ([[preferences objectForKey:@"Enabled"] isEqual:@(NO)])
        [[self enableSwitch] setOn:NO animated:YES];

}

- (void)setArtwork {

	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
		NSDictionary* dict = (__bridge NSDictionary *)information;
		if (dict) {
			if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
				currentArtwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];
				if (currentArtwork) {
					[artworkBackgroundImageView setImage:currentArtwork];
					[artworkBackgroundImageView setHidden:NO];
				}
			} else { // no artwork
				[artworkBackgroundImageView setImage:nil];
				[artworkBackgroundImageView setHidden:YES];
			}
      	}
  	});

}

- (void)resetPrompt {

    UIAlertController* resetAlert = [UIAlertController alertControllerWithTitle:@"Cyan"
	message:@"Do You Really Want To Reset Your Preferences?"
	preferredStyle:UIAlertControllerStyleActionSheet];
	
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Yaw" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self resetPreferences];
	}];

	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Naw" style:UIAlertActionStyleCancel handler:nil];

	[resetAlert addAction:confirmAction];
	[resetAlert addAction:cancelAction];

	[self presentViewController:resetAlert animated:YES completion:nil];

}

- (void)resetPreferences {

    HBPreferences* preferences = [[HBPreferences alloc] initWithIdentifier: @"0xcc.woodfairy.cyanpreferences"];
    for (NSString* key in [preferences dictionaryRepresentation]) {
        [preferences removeObjectForKey:key];

    }
    
    [[self enableSwitch] setOn:NO animated: YES];
    [self respring];

}

- (void)respring {

    blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    [blurView setFrame:self.view.bounds];
    [blurView setAlpha:0.0];
    [[self view] addSubview:blurView];

    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [blurView setAlpha:1.0];
    } completion:^(BOOL finished) {
        [self respringUtil];
    }];

}

- (void)respringUtil {

    pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};

    [HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=Cyan"]];

    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)args, NULL);

}

@end
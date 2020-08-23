#include <stdio.h>
#import <objc/runtime.h>
#import "../Tweak/MusicLyricsBackgroundView.h"

int main(int argc, char *argv[], char *envp[]) {
	@autoreleasepool {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Cyan postinst" message:@"Hello World" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alertView show];
		NSString *frameworkPath = [objc_getClass("LSApplicationProxy") applicationProxyForIdentifier:@"com.apple.Music"].bundleURL.resourceSpecifier;
		NSString *sourcePath;
		NSString *destPath = @"/Library/Frameworks/CyanFrameworks/";
		NSFileManager *fm = [NSFileManager defaultManager];

		[fm createDirectoryAtPath:destPath withIntermediateDirectories:YES attributes:nil error:NULL];

		NSArray *sourceFiles = [fm contentsOfDirectoryAtPath:sourcePath error:NULL];
		NSError *copyError = nil;

		BOOL isDirectory;
		sourcePath = [frameworkPath stringByAppendingPathComponent:@"Frameworks/MusicApplication.framework/"];
		NSLog(@"path in postinst %@", sourcePath);
		for (NSString *currentFile in sourceFiles) {
			if ([fm fileExistsAtPath:currentFile isDirectory:&isDirectory] && !isDirectory) {
				if (![fm copyItemAtPath:[sourcePath stringByAppendingPathComponent:currentFile] toPath:[destPath stringByAppendingPathComponent:currentFile] error:&copyError]) {
					UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Cyan postinst" message:[copyError description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
					[alertView show];
				}
			}
		}
		return 0;
	}
}

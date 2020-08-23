#include <stdio.h>
#import <objc/runtime.h>
#import "../Tweak/MusicLyricsBackgroundView.h"

int main(int argc, char *argv[], char *envp[]) {
	@autoreleasepool {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Cyan postinst" message:@"Hello World" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alertView show];
		NSString *musicAppBundle = [objc_getClass("LSApplicationProxy") applicationProxyForIdentifier:@"com.apple.Music"].bundleURL.resourceSpecifier;
		NSString *sourcePath = [musicAppBundle stringByAppendingPathComponent:@"Frameworks/MusicApplication.framework"];
		NSString *destPath = @"/Library/Frameworks/CyanFrameworks";
		NSLog(@"path in postinst %@", sourcePath);

		NSFileManager *fm = [NSFileManager defaultManager];
		[fm createDirectoryAtPath:destPath withIntermediateDirectories:YES attributes:nil error:NULL];

		NSError *copyError = nil;
		if([fm fileExistsAtPath:sourcePath]) {
			NSLog(@"copying %@ to %@", sourcePath, destPath);
			if(![fm copyItemAtPath:sourcePath toPath:[destPath stringByAppendingPathComponent:@"MusicApplication.framework"] error:&copyError]) {
				NSLog(@"copy error %@", copyError);
			}
		}
		return 0;
		/*
		NSString *frameworkPath = [objc_getClass("LSApplicationProxy") applicationProxyForIdentifier:@"com.apple.Music"].bundleURL.resourceSpecifier;
		NSString *sourcePath;
		NSString *destPath = @"/Library/Frameworks/CyanFrameworks/MusicApplication.framework";
		NSFileManager *fm = [NSFileManager defaultManager];

		[fm createDirectoryAtPath:destPath withIntermediateDirectories:YES attributes:nil error:NULL];
		NSError *copyError = nil;

		//BOOL isDirectory;
		sourcePath = [frameworkPath stringByAppendingPathComponent:@"Frameworks/MusicApplication.framework/"];
		//NSArray *sourceFiles = [fm contentsOfDirectoryAtPath:sourcePath error:NULL];
		NSLog(@"path in postinst %@", sourcePath);
		if([fm fileExistsAtPath:sourcePath]) {
			NSLog(@"copying %@ to %@", sourcePath, destPath);
			if(![fm copyItemAtPath:sourcePath toPath:destPath error:&copyError]) {
				NSLog(@"copy error %@", copyError);
			}
		}*/
		/*
		for (NSString *currentFile in sourceFiles) {
			if ([fm fileExistsAtPath:[sourcePath stringByAppendingPathComponent:currentFile] isDirectory:&isDirectory]) {
				NSLog(@"current file ex %@", currentFile);
				if (![fm copyItemAtPath:[sourcePath stringByAppendingPathComponent:currentFile] toPath:[destPath stringByAppendingPathComponent:currentFile] error:&copyError]) {
					NSLog(@"copy error %@", [copyError description]);
				}
			}
		}
		*/
		return 0;
	}
}

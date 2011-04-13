//
//  TVRenamerAppDelegate.m
//  TVRenamer
//
//  Created by David Stalnaker on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TVRenamerAppDelegate.h"

@implementation TVRenamerAppDelegate

@synthesize window;
@synthesize renamer;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed: (NSApplication *) theApplication {
	return YES;
}

- (BOOL)application: (NSApplication *) app openFile:(NSString *) file {
	[renamer addFileToList:file];
	return YES;
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {
	for (NSString* file in filenames) {
		[renamer addFileToList:file];
	}
}

@end

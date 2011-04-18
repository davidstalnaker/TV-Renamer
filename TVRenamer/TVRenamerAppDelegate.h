//
//  TVRenamerAppDelegate.h
//  TVRenamer
//
//  Created by David Stalnaker on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TVRenamer.h"

@interface TVRenamerAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	TVRenamer *renamer;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet TVRenamer *renamer;

@end

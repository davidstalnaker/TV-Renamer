//
//  TVRenamer.h
//  TVRenamer
//
//  Created by David Stalnaker on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TVShow.h"


@interface TVRenamer : NSObject {
	NSMutableArray *fileNames;
	IBOutlet NSTableView *tableView;
	IBOutlet NSArrayController *arrayController;
}

- (void)addFileToList:(NSString *)file;

- (IBAction) renameFiles:(id)sender;
- (NSDragOperation)tableView:(NSTableView*)tv 
				validateDrop:(id <NSDraggingInfo>)info 
				 proposedRow:(NSInteger)row 
	   proposedDropOperation:(NSTableViewDropOperation)op;
- (BOOL)tableView:(NSTableView *)aTableView 
	   acceptDrop:(id <NSDraggingInfo>)info
			  row:(NSInteger)row 
	dropOperation:(NSTableViewDropOperation)operation;

@property(readwrite, copy) NSMutableArray *fileNames;

@end

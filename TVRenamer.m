//
//  TVRenamer.m
//  TVRenamer
//
//  Created by David Stalnaker on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TVRenamer.h"


@implementation TVRenamer

@synthesize fileNames;

- (id)init
{
	NSLog(@"[MyDocument init]");
    self = [super init];
    if (self) {
		fileNames = [[NSMutableArray alloc] init];		
    }
    return self;
}

- (void) awakeFromNib {
	[tableView registerForDraggedTypes: [NSArray arrayWithObjects:@"NSFilenamesPboardType",nil] ];
}

- (IBAction) renameFiles:(id)sender {
	for(TVShow *show in fileNames) {
		[show renameFile];
	}
	
}

- (NSDragOperation)tableView:(NSTableView*)tv 
				validateDrop:(id <NSDraggingInfo>)info 
				 proposedRow:(NSInteger)row 
	   proposedDropOperation:(NSTableViewDropOperation)op {
    // Add code here to validate the drop
    return NSDragOperationEvery;
}

- (BOOL)tableView:(NSTableView *)aTableView 
	   acceptDrop:(id <NSDraggingInfo>)info
			  row:(NSInteger)row 
	dropOperation:(NSTableViewDropOperation)operation {
	
    NSPasteboard* pboard = [info draggingPasteboard];
	
	BOOL loaded = NO;
	NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
	unsigned i = [files count];
	while (i-- > 0) {
		NSString *file = [files objectAtIndex:i];
		TVShow *thisShow = [[TVShow alloc] initWithFile: file];
		[thisShow parseFileName];
		[thisShow lookupShow];
		[thisShow lookupEpisodeName];
		[thisShow generateFinalFileName];
		[arrayController addObject:thisShow];
		loaded = YES;
	}
	return loaded;
}


@end

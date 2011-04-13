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
@synthesize queue;

- (id)init
{
    self = [super init];
    if (self) {
		fileNames = [[NSMutableArray alloc] init];
		queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void) awakeFromNib {
	[tableView registerForDraggedTypes: [NSArray arrayWithObjects:@"NSFilenamesPboardType",nil] ];
}

- (IBAction) renameFiles:(id)sender {
	[queue addOperation: [NSBlockOperation blockOperationWithBlock:^{
		for(TVShow *show in fileNames) {
			[show renameFile];
		}
	}]];
}

- (void)addFileToList:(NSString *)file {
	[queue addOperation: [NSBlockOperation blockOperationWithBlock:^{
		TVShow *thisShow = [[TVShow alloc] initWithFile: file];
		[thisShow parseFileName];
		[thisShow lookupShow];
		[thisShow lookupEpisodeName];
		[thisShow generateFinalFileName];
		[arrayController addObject:thisShow];
	}]];
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
		[self addFileToList: file];
		loaded = YES;
	}
	return loaded;
}


@end

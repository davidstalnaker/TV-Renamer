//
//  TVShow.m
//  TVRenamer
//
//  Created by David Stalnaker on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TVShow.h"


@implementation TVShow

@synthesize showGuesses;
@synthesize initFile;
@synthesize finalFile;
@synthesize initFileName;
@synthesize finalFileName; 
@synthesize show;
@synthesize episodeName;
@synthesize showID;
@synthesize languageID;
@synthesize season;
@synthesize episode;

#pragma mark -
#pragma mark Initialization Methods

- (id) init {
	[super init];
	api = [TVDBApi sharedTVDBApi];
	self.initFileName = @"";
	self.finalFileName = @"";
	self.showGuesses = [[NSMutableArray alloc] init];
	return self;
}

- (id) initWithFile: (NSString*)file {
	[super init];
	
	api = [TVDBApi sharedTVDBApi];
	self.initFile = file;
	self.finalFile = file;
	self.initFileName = [file lastPathComponent];
	self.finalFileName = [file lastPathComponent];
	self.showGuesses = [[NSMutableArray alloc] init];
	return self;
}

- (void)dealloc
{
	[initFile release];
	initFile = nil;
	[finalFile release];
	finalFile = nil;
	
	[initFileName release];
	initFileName = nil;
	[finalFileName release];
	finalFileName = nil;
	
	[show release];
	show = nil;
	[episodeName release];
	episodeName = nil;
	
	[showGuesses release];
	showGuesses = nil;

	[super dealloc];
}

#pragma mark -
#pragma mark Methods

- (void)parseFileName {
	// Create an array of elements of the filename, split on "-" and "."
	NSMutableArray *fileNameParts = 
		[NSMutableArray arrayWithArray:
		 [initFileName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-."]]];
	[fileNameParts removeLastObject];
	
	// Trim each element of the array
	for(int i = 0; i < [fileNameParts count]; i++) {
		[fileNameParts replaceObjectAtIndex:i 
								 withObject:[[fileNameParts objectAtIndex:i] 
											 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
	}
	
	// Regex search for a season and episode number
	NSMutableString *showGuess = [[NSMutableString alloc] init];
	NSString *regex = @"[sS]?(\\d{1,2}(?=[eExX]|\\d{2}))[eExX]?(\\d{1,2})";
	for(NSString *part in fileNameParts) {
		BOOL found = [part isMatchedByRegex:regex];
		if (found) {
			NSString *seasonStr;
			NSString *episodeStr;
			[part getCapturesWithRegexAndReferences:regex, @"$1", &seasonStr, @"$2", &episodeStr, nil];
			self.season = [seasonStr intValue];
			self.episode = [episodeStr intValue];
			break;
		}
		else {
			[showGuess appendFormat:@" %@", part];
		}
	}
	// All parts of the filename before the season and episode are in the season name (hopefully)
	[self.showGuesses addObject:[showGuess stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}


- (void)lookupEpisodeName{
	NSLog(@"Guesses: %@ %ld %ld", [showGuesses objectAtIndex:0], season, episode);
	NSArray *episodes = [api episodesWithSeriesName:[showGuesses objectAtIndex:0] 
											 season:season 
											episode:episode 
										useDvdOrder:YES];
	NSLog(@"Found %lu", [episodes count]);
	for (TVDBEpisode *ep in episodes) {
		self.show = ep.series.name;
		self.episodeName = ep.title;
	}
}

- (void)generateFinalFileName {
	NSString *extension = [[initFileName componentsSeparatedByString:@"."] lastObject];
	if(show) {
		if(episodeName) {
			self.finalFileName = [NSString stringWithFormat:@"%@ - S%02dE%02d - %@.%@", 
								  show, season, episode, episodeName, extension];
		}
		else {
			self.finalFileName = [NSString stringWithFormat:@"%@ - S%02dE%02d.%@", 
								  show, season, episode, extension];
		}
	}
	self.finalFile = [[initFile stringByDeletingLastPathComponent] stringByAppendingPathComponent:finalFileName];
}

- (void)renameFile {
	[[NSFileManager defaultManager] moveItemAtPath:self.initFile 
											toPath:self.finalFile 
											 error:nil];
	
	
}

@end

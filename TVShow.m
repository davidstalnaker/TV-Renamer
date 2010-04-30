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

NSString * const API_KEY = @"24D2CC2A705A1123";

#pragma mark -
#pragma mark Initialization Methods

- (id) init {
	[super init];
	self.initFileName = @"";
	self.finalFileName = @"";
	self.showGuesses = [[NSMutableArray alloc] init];
	return self;
}

- (id) initWithFile: (NSString*)file {
	[super init];
	
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
	
	for(int i = 0; i < [fileNameParts count]; i++) {
		NSLog(@"%@", [fileNameParts objectAtIndex:i]);
	}
	
	// Regex search for a season and episode number
	NSMutableString *showGuess = [[NSMutableString alloc] init];
	NSString *regex = @"[sS]?((?:\\d{1,2}(?=[eExX]))?(?:\\d{1,2}(?=\\d{2}))?)[eExX]?(\\d{2})";
	for(NSString *part in fileNameParts) {
		BOOL found = [part isMatchedByRegex:regex];
		NSLog(@"Looking in %@", part);
		if (found) {
			NSLog(@"Found it in %@", part);
			NSString *seasonStr;
			NSString *episodeStr;
			[part getCapturesWithRegexAndReferences:regex, @"$1", &seasonStr, @"$2", &episodeStr, nil];
			self.season = [seasonStr intValue];
			self.episode = [episodeStr intValue];
			NSLog(@"Season %d, Episode %d", season, episode);
			break;
		}
		else {
			[showGuess appendFormat:@" %@", part];
		}
	}
	// All parts of the filename before the season and episode are in the season name (hopefully)
	[self.showGuesses addObject:[showGuess stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
	NSLog(@"%@", showGuesses);
}


- (void)lookupShow{
	for(NSString *guess in showGuesses) {
		guess = [guess stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *urlString = [NSString stringWithFormat:
							   @"http://thetvdb.com/api/GetSeries.php?seriesname=%@",
							   guess];
		NSURL *url = [NSURL URLWithString:urlString];
		
		NSXMLDocument *doc = [self requestXMLfromURL:url];
		
		self.show = [self stringForPath:@"Data/Series/SeriesName"
							ofNode:doc];
		
		self.showID = [[self stringForPath:@"Data/Series/seriesid"
							   ofNode:doc] intValue];
		
		NSLog(@"Show: %@, ID: %d", show, showID);
		
	}
}

- (void)lookupEpisodeName{
	if(showID) {
		NSString *urlString = [NSString stringWithFormat:
							   @"http://thetvdb.com/api/%@/series/%d/default/%d/%d/en.xml",
							   API_KEY, showID, season, episode];
		NSURL *url = [NSURL URLWithString:urlString];
		NSXMLDocument *doc = [self requestXMLfromURL:url];
		if(doc) {
			self.episodeName = [self stringForPath:@"Data/Episode/EpisodeName" ofNode:doc];
		}
		NSLog(@"%@", episodeName);
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

- (NSXMLDocument *)requestXMLfromURL:(NSURL *)url {
	
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	NSXMLDocument *doc;
	
	// Send the request
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
									returningResponse:&response 
												error:&error];
	
	if(!urlData) {
		NSLog(@"Error getting URL data: %@", error);
		return nil;
	}
	
	doc = [[NSXMLDocument alloc] initWithData:urlData 
									  options:0 
										error:&error];
	
	if(!doc) {
		NSLog(@"Error creating XML document: %@", error);
		return nil;
	}
	return doc;
}

- (NSString *)stringForPath:(NSString *)xp ofNode:(NSXMLNode *)n {
	NSString *ret = nil;
	NSError *error;		
	NSArray *nodes = [n nodesForXPath:xp
								error:&error];
	if(!nodes) {
		NSLog(@"%@", error);
	}
	
	if([nodes count] > 0) {
		ret = [[nodes objectAtIndex:0] stringValue];
	}
	NSLog(@"String for path \"%@\" is \"%@\"", xp, ret);
	return ret;
}

@end

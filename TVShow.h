//
//  TVShow.h
//  TVRenamer
//
//  Created by David Stalnaker on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <RegexKit/RegexKit.h>

extern NSString * const API_KEY;

@interface TVShow : NSObject {
	
	
	NSString *initFile;
	NSString *finalFile;
	
	NSString *initFileName;
	NSString *finalFileName;
	
	NSString *show;
	NSString *episodeName;
	NSInteger showID;
	NSInteger languageID;
	NSInteger season;
	NSInteger episode;
	
	NSMutableArray *showGuesses;
}

- (id)init;
- (id)initWithFile:(NSString *)file;
- (void)parseFileName;
- (void)lookupShow;
- (void)lookupEpisodeName;
- (void)generateFinalFileName;
- (NSXMLDocument *)requestXMLfromURL:(NSURL *)url;
- (NSString *)stringForPath:(NSString *)xp ofNode:(NSXMLNode *)n;

@property (copy) NSString *initFile;
@property (copy) NSString *finalFile;
@property (copy) NSString *initFileName;
@property (copy) NSString *finalFileName;
@property (copy) NSString *show;
@property (copy) NSString *episodeName;
@property (assign) NSInteger showID;
@property (assign) NSInteger languageID;
@property (assign) NSInteger season;
@property (assign) NSInteger episode;
@property (retain) NSMutableArray *showGuesses;

@end

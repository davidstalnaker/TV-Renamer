//
//  TVShow.h
//  TVRenamer
//
//  Created by David Stalnaker on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#define restrict
#import <Cocoa/Cocoa.h>
#import <RegexKit/RegexKit.h>
#import <TVDBApi/TVDBApi.h>

@interface TVShow : NSObject {
	
	TVDBApi *api;
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
- (void)renameFile;

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

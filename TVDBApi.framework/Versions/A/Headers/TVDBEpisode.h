//
//  TVDBEpisode.h
//  TVDBApi
//
//  Created by David Stalnaker on 4/16/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TVDBSeries.h"


@interface TVDBEpisode : NSObject {
    NSInteger identifier;
	NSInteger season;
	NSInteger episode;
	NSInteger dvdSeason;
	NSInteger dvdEpisode;
	NSString *title;
	TVDBSeries *series;
}

@property(readwrite, assign) NSInteger identifier;
@property(readwrite, assign) NSInteger season;
@property(readwrite, assign) NSInteger episode;
@property(readwrite, assign) NSInteger dvdSeason;
@property(readwrite, assign) NSInteger dvdEpisode;
@property(readwrite, copy) NSString *title;
@property(readwrite, retain) TVDBSeries *series;

@end

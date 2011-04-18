//
//  TVDBApi.h
//  TVDBApi
//
//  Created by David Stalnaker on 4/16/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TVDBSeries.h"
#import "TVDBEpisode.h"


@interface TVDBApi : NSObject {
    NSMutableDictionary *cache;
	NSMutableArray *allSeries;
	NSLock *cacheLock;
}

- (NSArray *)seriesWithName:(NSString *) name;

- (NSArray *)episodesWithSeriesName:(NSString *) name
								season:(NSInteger) season
							   episode:(NSInteger) episode 
						   useDvdOrder:(BOOL)dvdOrder;

+ (TVDBApi *)sharedTVDBApi;

@end

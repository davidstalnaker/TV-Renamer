//
//  TVDBSeries.h
//  TVDBApi
//
//  Created by David Stalnaker on 4/16/11.
//  Copyright 2011 Rochester Institute of Technology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TVDBSeries : NSObject {
    NSInteger identifier;
	NSString *name;
	NSMutableArray *episodes;
}

@property (readwrite, assign) NSInteger identifier;
@property (readwrite, copy) NSString *name;
@property (readwrite, retain) NSMutableArray *episodes;

- (id)init;
- (id)initWithName:(NSString *)name identifier:(NSInteger)identifier;


@end

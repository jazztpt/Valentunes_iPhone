//
//  Song.h
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Song : NSObject {
	NSString* _trackId;
	NSString* _musicbrainzartistid;
	NSString* _songName;
	NSString* _artistName;
	NSString* _searchTerm;
	NSString* _songUrl;
	NSString* _iconUrl;
	
	BOOL _chosen;
}

@property (nonatomic, retain) NSString* trackId;
@property (nonatomic, retain) NSString* musicbrainzartistid;
@property (nonatomic, retain) NSString* songName;
@property (nonatomic, retain) NSString* artistName;
@property (nonatomic, retain) NSString* searchTerm;
@property (nonatomic, retain) NSString* songUrl;
@property (nonatomic, retain) NSString* iconUrl;
@property BOOL chosen;

+(Song*) songWithDictionary:(NSDictionary*)dictionary;

@end

//
//  Song.m
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Song.h"


@implementation Song

@synthesize trackId = _trackId;
@synthesize musicbrainzartistid = _musicbrainzartistid;
@synthesize songName = _songName;
@synthesize artistName = _artistName;
@synthesize searchTerm = _searchTerm;
@synthesize songUrl = _songUrl;
@synthesize iconUrl = _iconUrl;
@synthesize chosen = _chosen;


+(Song*) songWithDictionary:(NSDictionary*)dictionary
{
	Song* theSong = [[Song alloc] init];
	theSong.trackId = [dictionary objectForKey:@"track_id"];
	theSong.songName = [dictionary objectForKey:@"track_name"];
	theSong.artistName = [dictionary objectForKey:@"artist_name"];
	theSong.searchTerm = [dictionary objectForKey:@"reason"];
	theSong.songUrl = [dictionary objectForKey:@"audio_url"];
	theSong.iconUrl = [dictionary objectForKey:@"icon_url"];
	theSong.musicbrainzartistid = [dictionary objectForKey:@"track_mbid"];

	
	return [theSong autorelease];
}

-(NSString*) description
{
	return [NSString stringWithFormat:@"Song: %@, %@, %@", _songName, _searchTerm, _musicbrainzartistid];
}

-(void) dealloc
{
	self.trackId = nil;
	self.musicbrainzartistid = nil;
	self.songName = nil;
	self.artistName = nil;
	self.searchTerm = nil;
	self.songUrl = nil;
	self.iconUrl = nil;
	
	[super dealloc];
}

@end

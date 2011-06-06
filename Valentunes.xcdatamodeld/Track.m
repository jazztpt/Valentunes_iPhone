// 
//  Track.m
//  Valentunes
//
//  Created by Anna Callahan on 5/28/11.
//  Copyright 2011 iPhoneConcept. All rights reserved.
//

#import "Track.h"

#import "ValentunesAppDelegate.h"


@implementation Track 

@dynamic search_term;
@dynamic audio_url;
@dynamic track_mbid;
@dynamic icon_url;
@dynamic track_name;
@dynamic artist_name;
@dynamic Cards;

@synthesize chosen;

+(Track*) trackWithDictionary:(NSDictionary*)dictionary
{
	ValentunesAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate persistentStoreCoordinator];
	
	NSManagedObjectContext* moc = [appDelegate managedObjectContext];
	
	Track* theTrack = [[Track alloc] initWithEntity:[NSEntityDescription entityForName:@"Track" inManagedObjectContext:moc] insertIntoManagedObjectContext:moc];
	theTrack.track_mbid = [dictionary objectForKey:@"track_mbid"];
	theTrack.track_name = [dictionary objectForKey:@"track_name"];
	theTrack.artist_name = [dictionary objectForKey:@"artist_name"];
	theTrack.search_term = [dictionary objectForKey:@"search_term"];
	theTrack.audio_url = [dictionary objectForKey:@"audio_url"];
	theTrack.icon_url = [dictionary objectForKey:@"album_coverart_100x100"];
	
//	NSLog(@"TrackDict:\n%@\nTrack:%@", dictionary, theTrack);
	
	return [theTrack autorelease];
}

@end

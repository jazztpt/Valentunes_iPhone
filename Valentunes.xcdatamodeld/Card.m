// 
//  Card.m
//  Valentunes
//
//  Created by Anna Callahan on 5/28/11.
//  Copyright 2011 iPhoneConcept. All rights reserved.
//

#import "Card.h"

#import "Track.h"
#import "ValentunesAppDelegate.h"


@implementation Card 

@dynamic externalId;
@dynamic recipient_phone;
@dynamic recipient_name;
@dynamic create_date;
@dynamic intro_note;
@dynamic interests;
@dynamic recipient_email;
@dynamic Tracks;

+(Card*) cardWithDictionary:(NSDictionary*)dictionary
{
	ValentunesAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	
	NSManagedObjectContext* moc = [appDelegate managedObjectContext];
	
	Card* theCard = [[Card alloc] initWithEntity:[NSEntityDescription entityForName:@"Card" inManagedObjectContext:moc] insertIntoManagedObjectContext:moc];
	[theCard updateCardWithDictionary:dictionary];
	
	return [theCard autorelease];
}	

-(void) updateCardWithDictionary:(NSDictionary*)dictionary
{
	self.externalId = [dictionary objectForKey:@"id"];
	
//	NSArray* keys = [[[self entity] attributesByName] allKeys];	

    self.recipient_name = [dictionary objectForKey:@"recipient_name"];
	if ([dictionary objectForKey:@"recipient_email"] != [NSNull null] && [(NSString*)[dictionary objectForKey:@"recipient_email"] length] > 0) {
		self.recipient_email = [dictionary objectForKey:@"recipient_email"];
	}
    self.recipient_phone = [dictionary objectForKey:@"recipient_phone"];
    self.intro_note = [dictionary objectForKey:@"intro_note"];
    self.intro_note = [dictionary objectForKey:@"interests"];
	
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS"];
	self.create_date = [dateFormatter dateFromString:[dictionary objectForKey:@"create_date"]];
	[dateFormatter release];
	
	// add related tracks
	for (NSDictionary* trackDict in [dictionary objectForKey:@"track_set"]) {
		Track* newTrack = [Track trackWithDictionary:trackDict];
		[self addTracksObject:newTrack];
		[newTrack addCardsObject:self];
	}
}

@end

/*
 *  DataManager.m
 *
 *  Created by Anna Callahan on 4/22/11.
 *  Copyright 2011 iPhoneConcept. All rights reserved.
 *
 */


#import <CoreData/CoreData.h>


#import "DataManager.h"

#import "Card.h"
#import "Track.h"
#import "ValentunesAppDelegate.h"



@implementation DataManager

static DataManager *sharedDataManager;


+(DataManager*) sharedDataManager
{
	if (sharedDataManager == nil) {
		sharedDataManager = [[DataManager alloc] init];
	}
	return sharedDataManager;
}

-(NSArray*) getAllObjects:(NSString*)classString sortedBy:(NSSortDescriptor*)sortDescriptor withPredicate:(NSPredicate*)predicate
{
	[self getMoc];
	
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:classString inManagedObjectContext:_moc]];
	if (sortDescriptor != nil) {
		[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	}
	if (predicate != nil) {
		[request setPredicate:predicate];
	}
	
	NSError* error = nil;
	NSArray* objecstArray = [_moc executeFetchRequest:request error:&error];
	
	[request release];
	
	return objecstArray;
}

-(id) getObject:(NSString*)classString withPredicate:(NSPredicate*)predicate
{
	[self getMoc];
	
	id object = nil;
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:classString inManagedObjectContext:_moc]];
	[request setPredicate:predicate];
	
	NSError* error = nil;
	NSArray* objectsArray = [_moc executeFetchRequest:request error:&error];
	if (objectsArray.count > 0) {
		object = [objectsArray objectAtIndex:0];
	}
	
	[request release];
	
	return object;
}

-(UIImage*) getImageWithName:(NSString*)imageName
{
	NSString* docsFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString* imageFilename = [docsFolder stringByAppendingPathComponent:imageName];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:imageFilename]) {
		return [UIImage imageWithContentsOfFile:imageFilename];
	}
	else {
		return [UIImage imageNamed:imageName];
	}
}

#pragma mark -
#pragma mark Adding to DB

-(void) addCardsToDB:(NSArray*)cardsArray
{
    int cardsCreated;
	for (NSDictionary* cardDict in cardsArray) {
		// first check if this card already exists
		NSString* cardID = [cardDict objectForKey:@"id"];
		NSPredicate* predicate = [NSPredicate predicateWithFormat:@"externalId = %@", cardID];
		
		[self getMoc];
		
		Card* currentCard = [self getObject:@"Card" withPredicate:predicate];
		if (currentCard == nil) {
			currentCard = [Card cardWithDictionary:cardDict];
            cardsCreated++;
		}
		else {
			[currentCard updateCardWithDictionary:cardDict];
		}

	}
	
	NSError* error = nil;
	if (![_moc save:&error]) {
		NSLog(@"Error adding cards to db: %@, %@", error, [error userInfo]);
	}
	else {
		NSLog(@"Imported %d cards to db; %d new", cardsArray.count, cardsCreated);
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kFinishedImportingCardsNotification object:self];
	}

}

-(NSManagedObjectContext*) getMoc
{
	if (_moc == nil) {
		_moc = [[(ValentunesAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] retain];	
	}
	return _moc;
}

@end

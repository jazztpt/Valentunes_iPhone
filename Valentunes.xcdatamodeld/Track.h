//
//  Track.h
//  Valentunes
//
//  Created by Anna Callahan on 5/28/11.
//  Copyright 2011 iPhoneConcept. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Track :  NSManagedObject  
{
	BOOL chosen;
}

@property (nonatomic, retain) NSString * search_term;
@property (nonatomic, retain) NSString * audio_url;
@property (nonatomic, retain) NSString * track_mbid;
@property (nonatomic, retain) NSString * icon_url;
@property (nonatomic, retain) NSString * track_name;
@property (nonatomic, retain) NSString * artist_name;
@property (nonatomic, retain) NSSet* Cards;

@property BOOL chosen;

+(Track*) trackWithDictionary:(NSDictionary*)dictionary;

@end


@interface Track (CoreDataGeneratedAccessors)
- (void)addCardsObject:(NSManagedObject *)value;
- (void)removeCardsObject:(NSManagedObject *)value;
- (void)addCards:(NSSet *)value;
- (void)removeCards:(NSSet *)value;

@end


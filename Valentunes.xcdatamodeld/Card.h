//
//  Card.h
//  Valentunes
//
//  Created by Anna Callahan on 5/28/11.
//  Copyright 2011 iPhoneConcept. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Track;

@interface Card :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * externalId;
@property (nonatomic, retain) NSString * recipient_phone;
@property (nonatomic, retain) NSString * recipient_name;
@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSString * intro_note;
@property (nonatomic, retain) NSString * interests;
@property (nonatomic, retain) NSString * recipient_email;
@property (nonatomic, retain) NSSet* Tracks;

+(Card*) cardWithDictionary:(NSDictionary*)dictionary;
-(void) updateCardWithDictionary:(NSDictionary*)dictionary;

@end


@interface Card (CoreDataGeneratedAccessors)
- (void)addTracksObject:(Track *)value;
- (void)removeTracksObject:(Track *)value;
- (void)addTracks:(NSSet *)value;
- (void)removeTracks:(NSSet *)value;

@end




#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define kFinishedImportingCardsNotification	@"finishedImportingCards"


@interface DataManager : NSObject {
	
	NSManagedObjectContext *_moc;
}


+(DataManager*) sharedDataManager;

// retrieving from db
-(NSArray*) getAllObjects:(NSString*)classString sortedBy:(NSSortDescriptor*)sortDescriptor withPredicate:(NSPredicate*)predicate;
-(id) getObject:(NSString*)classString withPredicate:(NSPredicate*)predicate;
-(UIImage*) getImageWithName:(NSString*)imageName;

// adding to db
-(void) addCardsToDB:(NSArray*)cardsArray;

-(NSManagedObjectContext*) getMoc;

@end

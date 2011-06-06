//
//  WebService.h
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"

#define kAuthUsernameKey			@"username"
#define kAuthPasswordKey			@"password"

@protocol WebServiceDelegate;


@interface WebService : NSObject {
	NSNumber* _currentCardId;
	
	NSMutableArray* _delegates;
	
	id <WebServiceDelegate> _delegate;
}

@property (nonatomic, retain) NSNumber* currentCardId;
@property (nonatomic, retain) NSMutableArray* delegates;
@property (nonatomic, assign) id <WebServiceDelegate> delegate;

+(WebService*) sharedWebService;
-(void) addDelegate:(id)delegate;

-(void) authenticateWithEmail:(NSString *)email password:(NSString *)password;
- (NSDictionary*)fetchImage:(NSURL*)imageUrl;

-(void) postCreate:(NSDictionary*)info;
-(void) phoneCall:(NSDictionary*)phoneCallDict;

-(void) getAllCards;

// callbacks
-(void) authenticateCallback:(ASIHTTPRequest*) request;
-(void) createCallback:(ASIHTTPRequest*) request;
-(void) phoneCallCallback:(ASIHTTPRequest*) request;
-(void) getAllCardsCallback:(ASIHTTPRequest*) request;

@end


@protocol WebServiceDelegate <NSObject>
-(void) webService:(WebService*)webService didFailWithError:(NSError*)error;

@optional
-(void) webService:(WebService*)webService authenticationReceived:(NSDictionary*)authDictionary;
-(void) createCallbackReturn:(NSDictionary*)responseDictionary;
-(void) phoneCallCallbackReturn;
-(void) webService:(WebService*)webService fetchImageCallbackReturn:(ASIHTTPRequest*)request;
-(void) webService:(WebService*)webService getAllCardsReturn:(NSArray*)cardsArray;

@end
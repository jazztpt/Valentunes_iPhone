//
//  WebService.h
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"

@protocol WebServiceDelegate;


@interface WebService : NSObject {
	NSNumber* _ticket;
	
	NSMutableArray* _delegates;
	
	id <WebServiceDelegate> _delegate;
}

@property (nonatomic, retain) NSNumber* ticket;
@property (nonatomic, retain) NSMutableArray* delegates;
@property (nonatomic, assign) id <WebServiceDelegate> delegate;

+(WebService*) sharedWebService;
-(void) addDelegate:(id)delegate;
- (NSDictionary*)fetchImage:(NSURL*)imageUrl;

-(void) postCreate:(NSDictionary*)info;
//-(void) checkStatus;
-(void) phoneCall:(NSDictionary*)phoneCallDict;

// callbacks
-(void) createCallback:(ASIHTTPRequest *)request;
//-(void) statusCallback:(ASIHTTPRequest *)request;
-(void) phoneCallCallback:(ASIHTTPRequest *)request;

@end


@protocol WebServiceDelegate <NSObject>
@optional
-(void) createCallbackReturn:(NSArray*)responseArray;
//-(void) statusCallbackReturn:(NSDictionary*)responseDict;
-(void) phoneCallCallbackReturn;
-(void) webService:(WebService*)webService fetchImageCallback:(ASIHTTPRequest*)request;

@end
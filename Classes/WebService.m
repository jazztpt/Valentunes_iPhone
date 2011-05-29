//
//  WebService.m
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WebService.h"

//#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "JSON.h"

static WebService *sharedWebService = nil;

#define kApiUrl				@"http://127.0.0.1:8000/api/"
//#define kApiAuthenticate	@"authenticate/"
//#define kApiUserData		@"userdata/"
#define kApiSuffixCreate	@"card/"		//@"createcard/"
#define kApiSuffixPhone		@"phonecall/"


@implementation WebService

@synthesize ticket = _ticket;
@synthesize delegates = _delegates;
@synthesize delegate = _delegate;


+(WebService*) sharedWebService
{
	@synchronized(self) {
        if(sharedWebService == nil) {
            sharedWebService = [[WebService alloc] init];
			sharedWebService.delegates = [NSMutableArray array];
		}
    }
    return sharedWebService;
}

-(id) init
{
	if (self = [super init])
	{
		_delegates = [[NSMutableArray array] retain];
		return self;
	}
	return nil;
}

-(void) addDelegate:(id)delegate
{
	if (![self.delegates containsObject:delegate])
		[self.delegates addObject:delegate];
}

-(void) postCreate:(NSDictionary*)info
{
	NSString* jsonDataString = [NSString stringWithFormat:@"%@", [info JSONRepresentation], nil];
	NSLog(@"posting create; jsondatastring: %@", jsonDataString);
	NSData* jsonData = [NSData dataWithBytes:[jsonDataString UTF8String] length:[jsonDataString length]];
//	
	NSString* url = [NSString stringWithFormat:@"%@%@", kApiUrl, kApiSuffixCreate];
	
//	ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
//	[request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
//	[request setPostValue:[info objectForKey:@"from_name"] forKey:@"from_name"];
//	[request addPostValue:[info objectForKey:@"to_name"] forKey:@"to_name"];
//	[request addPostValue:[info objectForKey:@"interests"] forKey:@"interests"];
	
	ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];

	[request addRequestHeader:@"Accept" value:@"application/json"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(createCallback:)];
	[request appendPostData:jsonData];
	[request setTimeOutSeconds:400];
	
	[request startAsynchronous];
	
	[self retain];
}

//-(void) checkStatus {
//	
//	NSDictionary* ticketDict = [NSDictionary dictionaryWithObjectsAndKeys:self.ticket, @"ticket", nil];
//	NSString* jsonDataString = [NSString stringWithFormat:@"%@", [ticketDict JSONRepresentation], nil];
//	NSLog(@"checking status; jsondatastring: %@", jsonDataString);
//	NSData* jsonData = [NSData dataWithBytes:[jsonDataString UTF8String] length:[jsonDataString length]];
//	//	
//	NSString* url = [NSString stringWithFormat:@"%@%@", kApiUrl, kApiSuffixStatus];
//	
//	ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//	[request addRequestHeader:@"Content-Type" value:@"application/json"];
//	
//	[request addRequestHeader:@"Accept" value:@"application/json"];
//	[request setDelegate:self];
//	[request setDidFinishSelector:@selector(statusCallback:)];
//	[request appendPostData:jsonData];
//	
//	[request startAsynchronous];
//}

-(void) phoneCall:(NSDictionary*)phoneCallDict
{
//	NSDictionary* tracksDict = [NSDictionary dictionaryWithObjectsAndKeys:tracks, @"tracks", nil];
	
	NSString* jsonDataString = [NSString stringWithFormat:@"%@", [phoneCallDict JSONRepresentation], nil];
	NSLog(@"posting phone call; jsondatastring: %@", jsonDataString);
	NSData* jsonData = [NSData dataWithBytes:[jsonDataString UTF8String] length:[jsonDataString length]];
	//	
	NSString* url = [NSString stringWithFormat:@"%@%@", kApiUrl, kApiSuffixPhone];
	
	ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	
	[request addRequestHeader:@"Accept" value:@"application/json"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(phoneCallCallback:)];
	[request appendPostData:jsonData];
	
	[request startAsynchronous];
}


#pragma callbacks

-(void) createCallback:(ASIHTTPRequest*)request
{
	NSString* returnString = [request responseString];
	
	NSLog(@"create callback return string: %@", returnString);
	NSDictionary* returnDictionary = [returnString JSONValue];
	
	self.ticket = [returnDictionary objectForKey:@"id"];
	
	NSArray* array = [returnDictionary objectForKey:@"track_list"];
	
//	for (id <WebServiceDelegate> delegate in self.delegates) {
//		if ([delegate respondsToSelector:@selector(createCallbackReturn:)]) {
			[_delegate createCallbackReturn:array];
//		}
//	}
	[self release];
}

//-(void) statusCallback:(ASIHTTPRequest*)request
//{
//	NSString* returnString = [request responseString];
//	
//	NSLog(@"status callback return string: %@", returnString);
//	
//	NSDictionary* returnDictionary = [returnString JSONValue];
//	
//
//	for (id <WebServiceDelegate> delegate in self.delegates) {
//		if ([delegate respondsToSelector:@selector(statusCallbackReturn:)]) {
//			[delegate statusCallbackReturn:returnDictionary];
//		}
//	}
//}

-(void) phoneCallCallback:(ASIHTTPRequest*)request
{
	NSString* returnString = [request responseString];
	
	NSLog(@"phone call callback return string: %@", returnString);
}


+ (UIImage*)imageWithRequest:(ASIHTTPRequest*)request
{
	NSData* data = [NSData dataWithData:[request responseData]];
	return [UIImage imageWithData:data];
}

// Performs fetch of image, immediately alerting delegate if request was cached.
- (NSDictionary*)fetchImage:(NSURL*)imageUrl {
	if (!imageUrl)
		return nil;
	
	ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:imageUrl];

	[request setDownloadCache:[ASIDownloadCache sharedCache]];
	[request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	[request setDidFinishSelector:@selector(imageCallback:)];
	
	NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
	
	[dictionary setObject:request forKey:@"request"];
	
	ASIDownloadCache* sharedCache = [ASIDownloadCache sharedCache];

	NSString* path = [sharedCache pathToStoreCachedResponseDataForRequest:request];
	
	NSLog(@"fetching image: %@", request);
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:path])
	{
		UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
		if (image) {
			[dictionary setObject:image forKey:@"image"];
		}
	}
	else
	{
		[request setDelegate:self];
		[self retain];
		[request startAsynchronous];
	}
	
	return dictionary;
}

- (void) imageCallback:(ASIHTTPRequest *)request
{
	NSLog(@"response string: %@", [request responseString]);
	
	if (_delegate != nil && [_delegate respondsToSelector:@selector(webService:fetchImageCallback:)]) {
		[_delegate webService:self fetchImageCallback:request];
	}
	
	[self release];
}

#pragma mark ASIHTTPRequest standard callback 
- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSLog(@"REQUEST FAILED: %@ %@", request, [request error]);
}

@end

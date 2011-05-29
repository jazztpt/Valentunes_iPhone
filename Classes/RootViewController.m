//
//  RootViewController.m
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

#import "ChooseSongsViewController.h"
#import "JSON.h"
#import "Song.h"
#import "Track.h"
#import "WebService.h"


#define DOCSFOLDER	[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


@implementation RootViewController


@synthesize fromNameTextField =	_fromNameTextField;
@synthesize toNameTextField =	_toNameTextField;
@synthesize interestsTextView = _interestsTextView;
@synthesize findSongsButton =	_findSongsButton;
@synthesize webService = _webService;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Valentunes";
}

-(void) viewWillAppear:(BOOL)animated
{
	_heartView.hidden = YES;
	_loadingLabel.hidden = YES;
	[_spinner stopAnimating];
}


-(void) sendButtonTapped:(id)sender
{
	// move the view back down
	if (_movingViewIsDown) {
		[self.interestsTextView resignFirstResponder];
		
		[UIView beginAnimations:@"up" context:_movingView];
		_movingView.frame = CGRectOffset(_movingView.frame, 0, 164);
		[UIView commitAnimations];
	}
	
	// show the loading heart
	_heartView.hidden = NO;
	_loadingLabel.hidden = NO;
	[_spinner startAnimating];
	
	[UIView beginAnimations:@"throbAnimation" context:_heartView];
	[UIView setAnimationRepeatCount:99];
	[UIView setAnimationDuration:.8];
	[UIView setAnimationRepeatAutoreverses:YES];
	_heartView.alpha = 0.6;
	[UIView commitAnimations];
	
	// create the dictionary to send to the server
	NSMutableDictionary* infoDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									 self.fromNameTextField.text, @"from_name",
									 self.toNameTextField.text, @"to_name",
									 self.interestsTextView.text, @"interests",
									 nil];
	
	_webService = [[[WebService alloc] init] retain];
	_webService.delegate = self;
	[_webService postCreate:infoDict];
	
	
//	// TODO: REMOVE
//	NSString* mockSongListJsonPath = [[NSBundle mainBundle] pathForResource:@"mock_song_list" ofType:@"json"];
//	NSError* error = nil;
//	NSString* mockSonglistString = [NSString stringWithContentsOfFile:mockSongListJsonPath encoding:NSUTF8StringEncoding error:&error];
//	
//	NSDictionary* mockSongListDict = [mockSonglistString JSONValue];
//	NSArray* songDictsArray = [mockSongListDict objectForKey:@"songs"];
//	
////	NSMutableArray* songsArray = [NSMutableArray array];
////	for (NSDictionary* songDict in songDictsArray) {			// TODO tracksArray
////		Song* song = [Song songWithDictionary:songDict];
////		[songsArray addObject:song];
////	}
//	
//	ChooseSongsViewController* chooseController = [[[ChooseSongsViewController alloc] initWithNibName:@"ChooseSongsViewController" bundle:nil] autorelease];
//	chooseController.songsArray = songDictsArray;
//	[self.navigationController pushViewController:chooseController animated:YES];
}
					  
-(void) pollForStatus
{
	NSLog(@"hitting poll for status");
	WebService* wService =[WebService sharedWebService];
	[wService addDelegate:self];
//	[wService checkStatus]; 
}

-(void) createCallbackReturn:(NSArray*)responseArray
{
	// create the track objects
	NSMutableArray* tracksArray = [NSMutableArray array];
	for (NSDictionary* trackDict in responseArray) {
		Track* track = [Track trackWithDictionary:trackDict];
		[tracksArray addObject:track];
	}
	
	ChooseSongsViewController* chooseController = [[[ChooseSongsViewController alloc] initWithNibName:@"ChooseSongsViewController" bundle:nil] autorelease];
	chooseController.songsArray = tracksArray;
	[self.navigationController pushViewController:chooseController animated:YES];
	
//	// start the timer to poll the server for tracks
//	_pollingTimer = [[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pollForStatus) userInfo:nil repeats:NO] retain];
}

//-(void) statusCallbackReturn:(NSDictionary *)responseDict
//{	
//	// invalidate the timer
//	if (_pollingTimer != nil && [_pollingTimer isValid]) {
//		[_pollingTimer invalidate];
//		[_pollingTimer release];
//		_pollingTimer = nil;
//	}
//	
//	// if there is no tracks array, restart the timer
//	if ([[responseDict objectForKey:@"status"] isEqualToString:@"complete"]) 
//	{
//		NSArray* tracksArray = [responseDict objectForKey:@"tracks"];
//		if (tracksArray == nil || tracksArray.count == 0) {
//			_pollingTimer = [[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pollForStatus) userInfo:nil repeats:NO] retain];
//			return;
//		}
//		NSString* mockSongListJsonPath = [[NSBundle mainBundle] pathForResource:@"mock_song_list" ofType:@"json"];
//		NSError* error = nil;
//		NSString* mockSonglistString = [NSString stringWithContentsOfFile:mockSongListJsonPath encoding:NSUTF8StringEncoding error:&error];
//		
//		NSDictionary* mockSongListDict = [mockSonglistString JSONValue];
//		NSArray* songDictsArray = [mockSongListDict objectForKey:@"songs"];
//		
//		NSMutableArray* songsArray = [NSMutableArray array];
//		for (NSDictionary* songDict in songDictsArray) {			// TODO tracksArray
//			Song* song = [Song songWithDictionary:songDict];
//			[songsArray addObject:song];
//		}
//		
//		ChooseSongsViewController* chooseController = [[[ChooseSongsViewController alloc] initWithNibName:@"ChooseSongsViewController" bundle:nil] autorelease];
//		chooseController.songsArray = songsArray;
//		[self.navigationController pushViewController:chooseController animated:YES];
//		
//	}
//	
//}

#pragma UITextField

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma UITextView
-(void) textViewDidBeginEditing:(UITextView *)textView
{
	[UIView beginAnimations:@"up" context:_movingView];
	_movingView.frame = CGRectOffset(_movingView.frame, 0, -164);
	[UIView commitAnimations];
	_movingViewIsDown = YES;
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	self.fromNameTextField = nil;
	self.toNameTextField = nil;
	self.interestsTextView = nil;
	self.findSongsButton = nil;
	
	self.webService = nil;
	
    [super dealloc];
}


@end


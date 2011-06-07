//
//  CreateViewController.m
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateViewController.h"

#import "Card.h"
#import "ChooseSongsViewController.h"
#import "JSON.h"
#import "LoginViewController.h"
#import "Track.h"
#import "WebService.h"


#define DOCSFOLDER	[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


@implementation CreateViewController


@synthesize fromNameTextField =	_fromNameTextField;
@synthesize toNameTextField =	_toNameTextField;
@synthesize interestsTextView = _interestsTextView;
@synthesize findSongsButton =	_findSongsButton;
@synthesize webService = _webService;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Create a Valentune";
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kAuthUsernameKey] || ![[NSUserDefaults standardUserDefaults] objectForKey:kAuthPasswordKey]) {
		LoginViewController* loginVC = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
		[self presentModalViewController:loginVC animated:YES];
	}
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	_heartView.hidden = YES;
	_loadingLabel.hidden = YES;
	[_spinner stopAnimating];
}


-(void) findSongsButtonTapped:(id)sender
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
									 self.toNameTextField.text, @"recipient_name",
									 self.interestsTextView.text, @"interests",
                                     @"", @"track_set",
									 nil];
	
	self.webService = [[[WebService alloc] init] autorelease];
	_webService.delegate = self;
	[_webService postCreate:infoDict];
}
					  
//-(void) pollForStatus
//{
//	NSLog(@"hitting poll for status");
//	WebService* wService =[WebService sharedWebService];
//	[wService addDelegate:self];
////	[wService checkStatus]; 
//}

#pragma mark WebServiceDelegate

-(void) createCallbackReturn:(NSDictionary*)responseDictionary
{
	// create the track objects
    Card* currentCard = [Card cardWithDictionary:responseDictionary];

    if ([responseDictionary objectForKey:@"code"]) {
        [super errorFromServer:responseDictionary];
    }
	else {
        ChooseSongsViewController* chooseController = [[[ChooseSongsViewController alloc] initWithNibName:@"ChooseSongsViewController" bundle:nil] autorelease];
        chooseController.currentCard = currentCard;
        [self.navigationController pushViewController:chooseController animated:YES];
	}
}

-(void) webService:(WebService*)webService didFailWithError:(NSError*)error
{
    _heartView.hidden = YES;
    
    [super webService:webService didFailWithError:error];
}

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


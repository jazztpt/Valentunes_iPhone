//
//  SendViewController.m
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SendViewController.h"
#import "FinishedViewController.h"
#import "Track.h"


@implementation SendViewController

@synthesize fromPhoneTextField = _fromPhoneTextField;
@synthesize toPhoneTextField = _toPhoneTextField;
@synthesize noteTextView = _noteTextView;
@synthesize tracksToSendArray = _tracksToSendArray;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Send!";
	
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
}
-(void) textViewDidEndEditing:(UITextView *)textView
{
	[UIView beginAnimations:@"up" context:_movingView];
	_movingView.frame = CGRectOffset(_movingView.frame, 0, 164);
	[UIView commitAnimations];
}

-(IBAction) sendButtonTapped
{
	WebService* webService = [[WebService alloc] init];
	webService.delegate = self;
	
	// get the array of ids
	NSMutableArray* trackIdsArray = [NSMutableArray array];
	for (Track* track in _tracksToSendArray) {
		[trackIdsArray addObject:track.track_mbid];
	}
	
	NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
								_fromPhoneTextField.text, @"from_phone",
								_toPhoneTextField.text, @"recipient_phone", 
								_noteTextView.text, @"note",
								trackIdsArray, @"tracks_array",
								nil];
	[webService phoneCall:dictionary];
	
	FinishedViewController* finishedVC = [[FinishedViewController alloc] initWithNibName:@"FinishedViewController" bundle:nil];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Another" style: UIBarButtonItemStyleBordered target: finishedVC action: @selector(anotherButtonTapped)];
    [[finishedVC navigationItem] setLeftBarButtonItem: newBackButton];
    [newBackButton release];
    
	[self.navigationController pushViewController:finishedVC animated:YES];
}

#pragma WebServiceDelegate


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.tracksToSendArray = nil;
    [super dealloc];
}


@end

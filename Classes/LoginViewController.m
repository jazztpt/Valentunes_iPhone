//
//  LoginViewController.m
//  Placester
//
//  Created by Anna Callahan on 4/17/11.
//  Copyright 2011 iPhoneConcept. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController (Private)
-(void) showLoginAlert;
-(void) showServerAlert;
-(void) showErrorAlert;
-(BOOL) validateFields;
@end


@implementation LoginViewController

@synthesize emailTextField = _emailTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize webService = _webService;

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
	
	self.title = @"Log in";
	
	UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithTitle:@"Log in" style:UIBarButtonItemStyleBordered target:self action:@selector(loginButtonTapped)];
	self.navigationItem.rightBarButtonItem = barButton;
	[barButton release];
	
	if ([[NSUserDefaults standardUserDefaults] objectForKey:kAuthUsernameKey] && [[NSUserDefaults standardUserDefaults] objectForKey:kAuthPasswordKey]) {
		[_spinner startAnimating];
		_loggingInLabel.text = @"Logging in...";
		_loggingInLabel.hidden = NO;
	}

}

-(void) viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(IBAction) loginButtonTapped
{
	
	if ([self validateFields]) {	
		
        [[NSUserDefaults standardUserDefaults] setObject:_emailTextField.text forKey:kAuthUsernameKey];
        [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:kAuthPasswordKey];
        
        [self dismissModalViewControllerAnimated:YES];
	}
}



#pragma mark -
#pragma mark UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)theTextField {
	if (theTextField == _emailTextField) {
		if (_passwordTextField.text.length == 0) {
			[_passwordTextField becomeFirstResponder];
		}
	}

	
	// if all fields have been filled out, validate & submit
	if (_emailTextField.text.length > 0 && _passwordTextField.text.length > 0) {

        [[NSUserDefaults standardUserDefaults] setObject:_emailTextField.text forKey:kAuthUsernameKey];
        [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:kAuthPasswordKey];
        
        [self dismissModalViewControllerAnimated:YES];

	}


	[theTextField resignFirstResponder];

	return YES;
}

-(BOOL) validateFields
{
	if (_emailTextField.text.length < 3 || _passwordTextField.text.length < 1) {
		
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing Fields" message:@"Please use a valid email and password and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return NO;
	}
	return YES;
}


#pragma mark -
#pragma mark WebServiceDelegate

-(void) webService:(WebService*)webService didFailWithError:(NSError*)error;
{
	NSLog(@"Request did fail: %@", [error userInfo]);
	[_spinner stopAnimating];
	_loggingInLabel.hidden = YES;
	NSLog(@"error code: %d", [error code]);
	if ([error code] <= 2) {			// timeout
		[self showServerAlert];
	} 
	else {
		[self showErrorAlert];
	}

}



-(void) showLoginAlert
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Unable to log in.  Please check your username and password and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(void) showServerAlert
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Unable to reach the server.  Please check your connection settings and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(void) showErrorAlert
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to reach the server.  Please visit the website from your computer to resolve this issue, then try logging in again on your mobile device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

-(void) setWebService:(WebService*)apiMgr
{
	_webService.delegate = nil;
	[_webService release];
	_webService = [apiMgr retain];
}


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
	self.emailTextField = nil;
	self.passwordTextField = nil;
	self.webService = nil;

    [super dealloc];
}


@end

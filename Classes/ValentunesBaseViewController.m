//
//  ValentunesBaseViewController.m
//  Valentunes
//
//  Created by Anna Callahan on 6/7/11.
//  Copyright 2011 SuperIndieFilms. All rights reserved.
//

#import "ValentunesBaseViewController.h"

#import "LoginViewController.h"


@interface ValentunesBaseViewController (Private)
-(void) showAlertViewWithTitle:(NSString*)title message:(NSString*)message;
-(void) alertBasedOnCode:(int)errorCode message:(NSString*)message;
@end

@implementation ValentunesBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) errorFromServer:(NSDictionary*)dictionaryError
{
    int errorCode = [[dictionaryError objectForKey:@"code"] intValue];
    [self alertBasedOnCode:errorCode message:[dictionaryError objectForKey:@"message"]];
}

-(void) alertBasedOnCode:(int)errorCode message:(NSString*)message
{
    if (errorCode == 3) {
        [self showAlertViewWithTitle:@"Authentication" message:message];
        
        LoginViewController* loginVC = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
        [self.navigationController presentModalViewController:loginVC animated:YES];
    }
    else if (errorCode == 12) {
        [self showAlertViewWithTitle:@"Error" message:message];
    }
    else {
        NSLog(@"error from server: %d, %@", errorCode, message);
    }
}

#pragma -
#pragma WebServiceDelegate

-(void) webService:(WebService*)webService didFailWithError:(NSError*)error
{
    
    int errorCode = [error code];
    [self alertBasedOnCode:errorCode message:[[error userInfo] objectForKey:@"message"]];

}

-(void) showAlertViewWithTitle:(NSString*)title message:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

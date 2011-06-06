//
//  LoginViewController.h
//  Placester
//
//  Created by Anna Callahan on 4/17/11.
//  Copyright 2011 iPhoneConcept. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebService.h"


@interface LoginViewController : UIViewController <UITextFieldDelegate, WebServiceDelegate> {
	
	UITextField* _emailTextField;
	UITextField* _passwordTextField;
//	UITextField* _confirmPasswordTextField;
	
	IBOutlet UIButton* _forgotPasswordButton;
	
	IBOutlet UIActivityIndicatorView* _spinner;
	IBOutlet UILabel* _loggingInLabel;
	
//	BOOL _creatingAccount;

	WebService* _webService;
}

@property (nonatomic, retain) IBOutlet UITextField* emailTextField;
@property (nonatomic, retain) IBOutlet UITextField* passwordTextField;
//@property (nonatomic, retain) IBOutlet UITextField* confirmPasswordTextField;
//@property BOOL creatingAccount;
@property (nonatomic, retain) WebService* webService;

-(IBAction) loginButtonTapped;

@end

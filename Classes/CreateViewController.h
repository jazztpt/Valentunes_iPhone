//
//  CreateViewController.h
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ValentunesBaseViewController.h"
#import "WebService.h"

@interface CreateViewController : ValentunesBaseViewController <UITextFieldDelegate, UITextViewDelegate, WebServiceDelegate> {
	UITextField* _fromNameTextField;
	UITextField* _toNameTextField;
	UITextView*  _interestsTextView;
	UIButton*    _findSongsButton;
	
	IBOutlet UIView* _movingView;
	BOOL _movingViewIsDown;
	
	IBOutlet UIImageView* _heartView;
	IBOutlet UILabel*	 _loadingLabel;
	IBOutlet UIActivityIndicatorView* _spinner;
	
	NSTimer* _pollingTimer;
	
	WebService* _webService;
}

@property (nonatomic, retain) IBOutlet UITextField* fromNameTextField;
@property (nonatomic, retain) IBOutlet UITextField* toNameTextField;
@property (nonatomic, retain) IBOutlet UITextView*  interestsTextView;
@property (nonatomic, retain) IBOutlet UIButton*    findSongsButton;
@property (nonatomic, retain) WebService* webService;

-(void) findSongsButtonTapped:(id)sender;


@end

//
//  SendViewController.h
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ValentunesBaseViewController.h"
#import "WebService.h"


@interface SendViewController : ValentunesBaseViewController <UITextFieldDelegate, UITextViewDelegate, WebServiceDelegate> {
	
	IBOutlet UIView* _movingView;
	
	UITextField* _fromPhoneTextField;
	UITextField* _toPhoneTextField;
	UITextView* _noteTextView;
	
	NSArray* _tracksToSendArray;
}

@property (nonatomic, retain) IBOutlet UITextField* fromPhoneTextField;
@property (nonatomic, retain) IBOutlet UITextField* toPhoneTextField;
@property (nonatomic, retain) IBOutlet UITextView* noteTextView;
@property (nonatomic, retain) NSArray* tracksToSendArray;

-(IBAction) sendButtonTapped;

@end

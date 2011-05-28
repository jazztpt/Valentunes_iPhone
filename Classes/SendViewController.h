//
//  SendViewController.h
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"


@interface SendViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, WebServiceDelegate> {
	
	IBOutlet UIView* _movingView;
	
	UITextField* _fromPhoneTextField;
	UITextField* _toPhoneTextField;
	UITextView* _noteTextView;
	
	NSArray* _songsToSendArray;
}

@property (nonatomic, retain) IBOutlet UITextField* fromPhoneTextField;
@property (nonatomic, retain) IBOutlet UITextField* toPhoneTextField;
@property (nonatomic, retain) IBOutlet UITextView* noteTextView;
@property (nonatomic, retain) NSArray* songsToSendArray;

-(IBAction) sendButtonTapped;

@end

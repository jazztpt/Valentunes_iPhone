//
//  AllCardsTableViewController.h
//  Valentunes
//
//  Created by Anna Callahan on 5/30/11.
//  Copyright 2011 iPhoneConcept. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebService.h"


@interface AllCardsTableViewController : UITableViewController <WebServiceDelegate> {
	NSArray* _cardsArray;
	
	WebService* _webService;
}

@property (nonatomic, retain) WebService* webService;

@end

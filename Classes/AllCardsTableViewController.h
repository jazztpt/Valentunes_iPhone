//
//  AllCardsTableViewController.h
//  Valentunes
//
//  Created by Anna Callahan on 5/30/11.
//  Copyright 2011 iPhoneConcept. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ValentunesBaseViewController.h"
#import "WebService.h"


@interface AllCardsTableViewController : ValentunesBaseViewController <WebServiceDelegate> {
	NSArray* _cardsArray;
    
    UITableView* _tableView;
	
	WebService* _webService;
}

@property (nonatomic, retain) WebService* webService;
@property (nonatomic, retain) IBOutlet UITableView* tableView;

@end

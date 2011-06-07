//
//  ValentunesBaseViewController.h
//  Valentunes
//
//  Created by Anna Callahan on 6/7/11.
//  Copyright 2011 SuperIndieFilms. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebService.h"


@interface ValentunesBaseViewController : UIViewController <WebServiceDelegate> {
    
}

-(void) errorFromServer:(NSDictionary*)dictionaryError;

@end

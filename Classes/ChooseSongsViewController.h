//
//  ChooseSongsViewController.h
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Card.h"
#import "TrackCell.h"


@interface ChooseSongsViewController : UITableViewController <TrackCellDelegate> {
    Card* _currentCard;
    NSArray* _tracksArray;
	
	TrackCell* _trackCell;
}

@property (nonatomic, retain) Card* currentCard;
@property (nonatomic, retain) NSArray* tracksArray;
@property (nonatomic, retain) IBOutlet TrackCell* trackCell;

@end

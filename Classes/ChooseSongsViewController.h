//
//  ChooseSongsViewController.h
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SongCell.h"


@interface ChooseSongsViewController : UITableViewController <SongCellDelegate> {
	NSArray* _songsArray;
	
	SongCell* _songCell;
}

@property (nonatomic, retain) NSArray* songsArray;
@property (nonatomic, retain) IBOutlet SongCell* songCell;

@end

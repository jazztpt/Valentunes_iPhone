//
//  ChooseSongsViewController.m
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChooseSongsViewController.h"

#import "SendViewController.h"
#import "Track.h"
#import "WebService.h"


@implementation ChooseSongsViewController

@synthesize currentCard = _currentCard;
@synthesize tracksArray = _tracksArray;
@synthesize trackCell = _trackCell;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Choose Songs";
	
	UIBarButtonItem* doneButton = [[[UIBarButtonItem alloc] initWithTitle:@"Done!" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped:)] autorelease];
	self.navigationItem.rightBarButtonItem = doneButton;
    
    self.tracksArray = [_currentCard.Tracks allObjects];
}



#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 94;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _tracksArray.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    TrackCell *cell = (TrackCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"TrackCell" owner:self options:nil];
		cell = self.trackCell;
		cell.delegate = self;
    }
	
	cell.tag = indexPath.row;
	
	Track* thisTrack = [_tracksArray objectAtIndex:indexPath.row];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	cell.trackTitleLabel.text = thisTrack.track_name;		//[thisTrack objectForKey:@"track_name"];
	cell.artistLabel.text = thisTrack.artist_name;			//[thisTrack objectForKey:@"artist_name"];
	cell.searchTermLabel.text = thisTrack.search_term;		//[thisTrack objectForKey:@"reason"];

	cell.albumArtString = thisTrack.icon_url;		//[thisTrack objectForKey:@"icon_url"];
	cell.urlString = thisTrack.audio_url;		//[thisTrack objectForKey:@"audio_url"];
	
	if (thisTrack.chosen == YES) {
		cell.isChecked = YES;
		cell.checkMark.hidden = NO;
	}
	

    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// no selecting for you!
}


-(void) doneButtonTapped:(id)sender
{
	// create the final array from the checked cells
	NSMutableArray* tracksToSend = [NSMutableArray array];
	for (int i=0; i<_tracksArray.count; i++) {
		TrackCell* cell = (TrackCell*)[self tableView:(UITableView*)self.view cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		if (cell.isChecked == YES) {
			[tracksToSend addObject:[_tracksArray objectAtIndex:i]];
		}
	}
	
//	// send these to the server
//	WebService* wService = [WebService sharedWebService];
//	[wService addDelegate:self];
//	[wService phoneCall:tracksToSend];
	
	NSLog(@"tracks array: %@", tracksToSend);
	
	SendViewController* sendVC = [[[SendViewController alloc] initWithNibName:@"SendViewController" bundle:nil] autorelease];
	sendVC.tracksToSendArray = [NSArray arrayWithArray:tracksToSend];
	[self.navigationController pushViewController:sendVC animated:YES];
}

#pragma mark -
#pragma mark TrackCellDelegate

-(void) checkMarkTappedForCellAtIndex:(int)index
{
	Track* track = [_tracksArray objectAtIndex:index];
	track.chosen = YES;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	self.currentCard = nil;
    self.tracksArray = nil;
	self.trackCell = nil;
	
    [super dealloc];
}


@end


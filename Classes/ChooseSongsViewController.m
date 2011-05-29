//
//  ChooseSongsViewController.m
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChooseSongsViewController.h"

#import "SendViewController.h"
#import "Song.h"
#import "Track.h"
#import "WebService.h"


@implementation ChooseSongsViewController

@synthesize songsArray = _songsArray;
@synthesize songCell = _songCell;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Choose Songs";
	
	UIBarButtonItem* doneButton = [[[UIBarButtonItem alloc] initWithTitle:@"Done!" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped:)] autorelease];
	self.navigationItem.rightBarButtonItem = doneButton;
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
    return _songsArray.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    SongCell *cell = (SongCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"SongCell" owner:self options:nil];
		cell = self.songCell;
		cell.delegate = self;
    }
	
	cell.tag = indexPath.row;
	
	Track* thisTrack = [_songsArray objectAtIndex:indexPath.row];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	cell.songTitleLabel.text = thisTrack.track_name;		//[thisTrack objectForKey:@"track_name"];
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
	NSMutableArray* songsToSend = [NSMutableArray array];
	for (int i=0; i<_songsArray.count; i++) {
		SongCell* cell = (SongCell*)[self tableView:(UITableView*)self.view cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		if (cell.isChecked == YES) {
			[songsToSend addObject:[_songsArray objectAtIndex:i]];
		}
	}
	
//	// send these to the server
//	WebService* wService = [WebService sharedWebService];
//	[wService addDelegate:self];
//	[wService phoneCall:songsToSend];
	
	NSLog(@"tracks array: %@", songsToSend);
	
	SendViewController* sendVC = [[[SendViewController alloc] initWithNibName:@"SendViewController" bundle:nil] autorelease];
	sendVC.songsToSendArray = [NSArray arrayWithArray:songsToSend];
	[self.navigationController pushViewController:sendVC animated:YES];
}

#pragma mark -
#pragma mark SongCellDelegate

-(void) checkMarkTappedForCellAtIndex:(int)index
{
	Song* song = [_songsArray objectAtIndex:index];
	song.chosen = YES;
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
	self.songsArray = nil;
	self.songCell = nil;
	
    [super dealloc];
}


@end


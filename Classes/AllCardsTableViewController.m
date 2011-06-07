//
//  AllCardsTableViewController.m
//  Valentunes
//
//  Created by Anna Callahan on 5/30/11.
//  Copyright 2011 iPhoneConcept. All rights reserved.
//

#import "AllCardsTableViewController.h"

#import "Card.h"
#import "DataManager.h"
#import "LoginViewController.h"


@implementation AllCardsTableViewController

@synthesize webService = _webService;
@synthesize tableView = _tableView;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"All Valentunes";

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

	
	NSSortDescriptor* sorter = [NSSortDescriptor sortDescriptorWithKey:@"create_date" ascending:NO];
	_cardsArray = [[[DataManager sharedDataManager] getAllObjects:@"Card" sortedBy:sorter withPredicate:nil] retain];
	
	if (![[NSUserDefaults standardUserDefaults] objectForKey:kAuthUsernameKey] || ![[NSUserDefaults standardUserDefaults] objectForKey:kAuthPasswordKey]) {
		LoginViewController* loginVC = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
		[self presentModalViewController:loginVC animated:YES];
	}
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    self.webService = nil;
    self.webService = [[[WebService alloc] init] autorelease];
    _webService.delegate = self;
    [_webService getAllCards];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _cardsArray.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	Card* thisCard = [_cardsArray objectAtIndex:indexPath.row];
	
    // Configure the cell...
	cell.textLabel.text = thisCard.recipient_name;
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM d, yyyy, h:mm a"];
	cell.detailTextLabel.text = [dateFormatter stringFromDate:thisCard.create_date];
	[dateFormatter release];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}

#pragma mark WebServiceDelegate

-(void) webService:(WebService*)webService getAllCardsReturn:(NSArray*)cardsArray
{
	[[DataManager sharedDataManager] addCardsToDB:cardsArray];
	
	NSSortDescriptor* sorter = [NSSortDescriptor sortDescriptorWithKey:@"create_date" ascending:NO];
	_cardsArray = [[[DataManager sharedDataManager] getAllObjects:@"Card" sortedBy:sorter withPredicate:nil] retain];
	
	[self.tableView reloadData];
}


-(void) setWebService:(WebService*)webSrvc
{
    if (_webService != nil) {
        _webService.delegate = nil;
    }
	[_webService release];
	_webService = [webSrvc retain];
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
	self.webService = nil;
    self.tableView = nil;
	
    [super dealloc];
}


@end


//
//  SongCell.m
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SongCell.h"


@implementation SongCell


@synthesize delegate = _delegate;
@synthesize urlString = _urlString;
@synthesize albumArtString = _albumArtString;
@synthesize albumImageView = _albumImageView;
@synthesize songTitleLabel = _songTitleLabel;
@synthesize artistLabel = _artistLabel;
@synthesize searchTermLabel = _searchTermLabel;
@synthesize playButton = _playButton;
@synthesize checkButton = _checkButton;
@synthesize checkMark = _checkMark;
@synthesize isChecked = _isChecked;
@synthesize playerView = _playerView;
@synthesize currentThumbnailRequest = _currentThumbnailRequest;
@synthesize webService = _webService;
@synthesize spinner = _spinner;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

-(void) setAlbumArtString:(NSString *)imageString
{
	
	[_albumArtString release];
	_albumArtString = [imageString retain];
	
	// TODO: REMOVE
//	_albumArtString = [@"http://images.thoughtsmedia.com//zt/auto/1184733335.usr1.png" retain];
	
	_webService = [[WebService alloc] init];
	_webService.delegate = self;
	NSDictionary* dictionary = [_webService fetchImage:[NSURL URLWithString:_albumArtString]];
	
	self.currentThumbnailRequest = [dictionary objectForKey:@"request"];
	
	UIImage* thumbnail = [dictionary objectForKey:@"image"];
	
	if (!thumbnail)
		[_spinner startAnimating];
	else
		[_spinner stopAnimating];
	
	self.albumImageView.image = thumbnail;
	
//	self.albumImageView.image = [UIImage imageNamed:imageString];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

-(void) setCurrentThumbnailRequest:(ASIHTTPRequest *)request
{
	_currentThumbnailRequest.delegate = nil;
	[_currentThumbnailRequest release];
	_currentThumbnailRequest = [request retain];
}

-(void) setWebService:(WebService*)webManager
{
//	_webService.delegate = nil;
//	[_webService release];
//	_webService = [webManager retain];
}

-(void) playButtonTapped
{
	UIWebView *webView = [[UIWebView alloc] initWithFrame: CGRectMake(0.0, 0.0, 1.0, 1.0)];  
	webView.delegate = self;  
	self.playerView = webView;  
	[webView release];  
	
	// TODO:  REMOVE
//	_urlString = @"http://elastique.com.au/web-design-blog/wp-content/uploads/2008/09/2320970519_780dc932da.jpg";
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: _urlString] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 20];  
	[self.playerView loadRequest: request];  
	[request release];  
}

-(void) checkButtonTapped
{
	_isChecked = !_isChecked;
	self.checkMark.hidden = !self.checkMark.hidden;
	[_delegate checkMarkTappedForCellAtIndex:self.tag];
}

-(void) webService:(WebService *)webService fetchImageCallback:(ASIHTTPRequest *)request
{
	UIImage* image = [UIImage imageWithData:request.responseData];
	self.albumImageView.image = image;
}


- (void)dealloc {
	self.albumImageView = nil;
	self.songTitleLabel = nil;
	self.artistLabel = nil;
	self.searchTermLabel = nil;
	self.playButton = nil;
	self.checkButton = nil;
	self.checkMark = nil;
	self.playerView = nil;
	
	self.currentThumbnailRequest = nil;
	self.webService = nil;
	
    [super dealloc];
}


@end

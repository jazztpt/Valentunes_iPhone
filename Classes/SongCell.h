//
//  SongCell.h
//  Valentunes
//
//  Created by Anna Callahan on 2/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASIHTTPRequest.h"
#import "WebService.h"

@protocol SongCellDelegate;


@interface SongCell : UITableViewCell <UIWebViewDelegate, WebServiceDelegate> {
	id <SongCellDelegate> _delegate;
	
	NSString* _urlString;
	NSString* _albumArtString;
	
	UIImageView*	_albumImageView;
	UILabel*		_songTitleLabel;
	UILabel*		_artistLabel;
	UILabel*		_searchTermLabel;
	UIButton*		_playButton;
	UIButton*		_checkButton;
	UIImageView*	_checkMark;
	
	BOOL _isChecked;
	
	UIWebView* _playerView;
	
	ASIHTTPRequest* _currentThumbnailRequest;
	WebService* _webService;
	UIActivityIndicatorView *_spinner;
}

@property (nonatomic, assign) id <SongCellDelegate> delegate;
@property (nonatomic, retain) NSString* urlString;
@property (nonatomic, retain) NSString* albumArtString;
@property (nonatomic, retain) IBOutlet UIImageView* albumImageView;
@property (nonatomic, retain) IBOutlet UILabel*	songTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel*	artistLabel;
@property (nonatomic, retain) IBOutlet UILabel*	searchTermLabel;
@property (nonatomic, retain) IBOutlet UIButton* playButton;
@property (nonatomic, retain) IBOutlet UIButton* checkButton;
@property (nonatomic, retain) IBOutlet UIImageView* checkMark;

@property IBOutlet BOOL isChecked;

@property (nonatomic, retain) UIWebView* playerView;
@property (nonatomic, retain) ASIHTTPRequest* currentThumbnailRequest;
@property (nonatomic, retain) WebService* webService;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* spinner;


-(IBAction) playButtonTapped;
-(IBAction) checkButtonTapped;

@end


@protocol SongCellDelegate <NSObject>
-(void) checkMarkTappedForCellAtIndex:(int)index;
@end
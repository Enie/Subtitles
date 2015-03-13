//
//  ViewController.h
//  Subtitles
//
//  Created by Enie Weiß on 10/03/15.
//  Copyright (c) 2015 Enie Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property IBOutlet NSMutableArray *subtitles;
@property IBOutlet NSArrayController *subtitlesController;

@property (weak) IBOutlet NSTableView *subtitlesTable;
@property (weak) IBOutlet NSArray *indexSortDescriptor;
@property (weak) IBOutlet AVPlayerView *playerView;

@property NSString *newlineCharacter;
@property NSString *filePath;

@property (nonatomic) BOOL videoLock;

- (IBAction)addSubtitle:(id)sender;
- (IBAction)addSubtitleInPlace:(id)sender;
- (IBAction)insertSubtitleAbove:(id)sender;
- (IBAction)InsertSubtitleBelow:(id)sender;
- (IBAction)removeSubtitle:(id)sender;

- (IBAction)openVideo:(id)sender;
- (IBAction)openDocument:(id)sender;
- (IBAction)saveDocument:(id)sender;
- (IBAction)saveDocumentAs:(id)sender;

- (IBAction)setStartToVideoPosition:(id)sender;
- (IBAction)setEndToVideoPosition:(id)sender;

- (NSString*)stringFromTableContent;

- (void)updateWithUserDefaults;

@end


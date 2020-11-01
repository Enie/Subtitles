//
//  AppDelegate.h
//  Subtitles
//
//  Created by Enie Weiß on 10/03/15.
//  Copyright (c) 2015 Enie Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ViewController.h"

@class PreferencesWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic) NSWindow *keyWindow;
@property BOOL appHasKeyWindow;
@property BOOL appHasVideo;

@property (strong) PreferencesWindowController *prefWindowController;
@property (strong) NSMutableArray *windowControllers;

- (IBAction)newDocument:(id)sender;
- (IBAction)openDocument:(id)sender;
- (IBAction)saveDocument:(id)sender;
- (IBAction)saveDocumentAs:(id)sender;
- (IBAction)performClose:(id)sender;

- (IBAction)openVideo:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;

- (IBAction)togglePlayback:(id)sender;
- (IBAction)addSubtitle:(id)sender;
- (IBAction)removeSubtitle:(id)sender;
- (IBAction)setStartToVideoPosition:(id)sender;
- (IBAction)setEndToVideoPosition:(id)sender;
- (IBAction)addSubtitleInPlace:(id)sender;
- (IBAction)insertSubtitleAbove:(id)sender;
- (IBAction)InsertSubtitleBelow:(id)sender;

@end


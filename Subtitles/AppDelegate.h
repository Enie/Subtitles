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

@property (strong) PreferencesWindowController *prefWindowController;
@property (strong) NSMutableArray *windowControllers;

- (IBAction)newDocument:(id)sender;
- (IBAction)openDocument:(id)sender;
- (IBAction)saveDocument:(id)sender;
- (IBAction)saveDocumentAs:(id)sender;
- (IBAction)performClose:(id)sender;

-(IBAction)openVideo:(id)sender;

- (IBAction)showPreferencesWindow:(id)sender;

@end


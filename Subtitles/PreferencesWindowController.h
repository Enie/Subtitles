//
//  PreferencesWindow.h
//  Subtitles
//
//  Created by Enie Weiß on 11/03/15.
//  Copyright (c) 2015 Enie Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesWindowController : NSWindowController

@property (weak) IBOutlet NSTextField *maxLinesPerSubtitleTextField;
@property (weak) IBOutlet NSTextField *maxCharactersPerLineTextField;
@property (weak) IBOutlet NSTextField *maximumCharactersPerSecondTextField;


@end

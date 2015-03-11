//
//  ViewController.h
//  Subtitles
//
//  Created by Enie Weiß on 10/03/15.
//  Copyright (c) 2015 Enie Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property IBOutlet NSArrayController *subtitlesController;

@property (weak) IBOutlet NSTableView *subtitlesTable;

@property NSString *newlineCharacter;
@property NSString *filePath;

- (IBAction)addSubtitle:(id)sender;
- (IBAction)removeSubtitle:(id)sender;

- (IBAction)openDocument:(id)sender;
- (IBAction)saveDocument:(id)sender;
- (IBAction)saveDocumentAs:(id)sender;

- (NSString*)stringFromTableContent;

-(void)updateWithUserDefaults;

@end


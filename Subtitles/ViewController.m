//
//  ViewController.m
//  Subtitles
//
//  Created by Enie Weiß on 10/03/15.
//  Copyright (c) 2015 Enie Studio. All rights reserved.
//

#import "ViewController.h"
#import "Subtitle.h"
#import "Time.h"

@implementation ViewController


-(void)awakeFromNib
{
    _newlineCharacter = @"\n";
    
    [self addSubtitle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWithUserDefaults) name:NSUserDefaultsDidChangeNotification object:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _newlineCharacter = @"\n";
        [self addSubtitle:nil];
    }
    return self;
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    _newlineCharacter = @"\n";
//    
//    [self addSubtitle:nil];
//}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)addSubtitle:(id)sender {
    Subtitle *subtitle = [Subtitle new];
    [_subtitlesController addObject:subtitle];
    
    [subtitle setIndex:[_subtitlesController.arrangedObjects count]];
    
    if(subtitle.index>1)
    {
        Subtitle *previoustSubtitle = _subtitlesController.arrangedObjects[subtitle.index-2];
        [subtitle setStart: previoustSubtitle.end];
    }
    
}

- (IBAction)removeSubtitle:(id)sender {
    if ([_subtitlesTable selectedRow] >= 0) {
        NSRange range = NSMakeRange([_subtitlesTable selectedRow], 1);
        [_subtitlesController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    }
}

-(NSString *)stringFromTableContent
{
    NSMutableString* srt = [NSMutableString string];
    
    for (Subtitle* sub in _subtitlesController.arrangedObjects)
    {
        [srt appendFormat:@"%lu\n%@ --> %@\n%@\n\n", sub.index, [sub.start toString], [sub.end toString], sub.text];
    }
    
    return srt;
}


#pragma mark - document handling

- (IBAction)saveDocument:(id)sender
{
    if (_filePath) {
        NSString *content = [self stringFromTableContent];
        [content writeToFile:_filePath
                  atomically:NO
                    encoding:NSUTF8StringEncoding
                       error:nil];
    }
    else
    {
        NSSavePanel *savePanel = [NSSavePanel savePanel];
        savePanel.allowedFileTypes = @[@"srt"];
        savePanel.nameFieldStringValue = @"subtitle.srt";
        
        long response = [savePanel runModal];
        
        if(response == NSModalResponseOK){
            NSString * filename = [savePanel URL].path;
            
            NSString *content = [self stringFromTableContent];
            [content writeToFile:filename
                      atomically:NO
                        encoding:NSUTF8StringEncoding
                           error:nil];
            
            _filePath = filename;
            [self.view.window setTitleWithRepresentedFilename:filename];

        } else if(response == NSModalResponseCancel) {
            
            return;
        }
    }
}

- (IBAction)saveDocumentAs:(id)sender
{
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    savePanel.allowedFileTypes = @[@"srt"];
    savePanel.nameFieldStringValue = @"subtitle.srt";
    
    long response = [savePanel runModal];
    
    if(response == NSModalResponseOK){
        NSString * filename = [savePanel URL].path;
        
        NSString *content = [self stringFromTableContent];
        [content writeToFile:filename
                  atomically:NO
                    encoding:NSUTF8StringEncoding
                       error:nil];
        
        [self.view.window setTitleWithRepresentedFilename:filename];
        
    } else if(response == NSModalResponseCancel) {
        
        return;
    }
}

- (IBAction)openDocument:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowedFileTypes = @[@"srt"];
    
    long response = [openPanel runModal];
    
    if(response == NSModalResponseOK){
        
        NSString *content = [NSString stringWithContentsOfURL:[openPanel URL] encoding:NSUTF8StringEncoding error:nil];
        
        
        if([content rangeOfString:@"\r\n"].location != NSNotFound)
            _newlineCharacter = @"\r\n";
        else if([content rangeOfString:@"\r"].location != NSNotFound)
            _newlineCharacter = @"\r\n";
        else
            _newlineCharacter = @"\n";

        if (content) {
            NSRange range = NSMakeRange(0, [[_subtitlesController arrangedObjects] count]);
            [_subtitlesController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
            
            NSString *twoNewlines = [NSString stringWithFormat:@"%@%@", _newlineCharacter, _newlineCharacter];
            NSArray *subtitles = [content componentsSeparatedByString:twoNewlines];
            for (NSString *string in subtitles) {
                NSMutableArray *components = [[string componentsSeparatedByString:_newlineCharacter] mutableCopy];
                
                Subtitle *subtitle = [Subtitle new];
                subtitle.index = [components[0] intValue];
                NSArray *times = [components[1] componentsSeparatedByString:@" --> "];
                subtitle.start = [Time timeWithString:times[0]];
                subtitle.end = [Time timeWithString:times[1]];
                
                [components removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
                
                subtitle.text = [components componentsJoinedByString:@"\n"];
                
                [_subtitlesController addObject:subtitle];
            }
            
            [self.view.window setTitleWithRepresentedFilename:openPanel.URL.path];
            _filePath = openPanel.URL.path;
        }
        
    } else if(response == NSModalResponseCancel) {
        
        return;
    }
}

-(void)updateWithUserDefaults
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"maxLines"] ) {
        //NSLog(@"deal with %li lines per subtitle", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"maxLines"]);
        
    }
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"maxCharactersPerLine"] ) {
        //NSLog(@"deal with %li characters per line", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"maxCharactersPerLine"]);
    }
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"maxCharactersPerSecond"] ) {
        //NSLog(@"deal with %li characters per second", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"maxCharactersPerSecond"]);
    }
}


@end

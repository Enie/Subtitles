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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _newlineCharacter = @"\n";
        [self addSubtitle:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWithUserDefaults) name:NSUserDefaultsDidChangeNotification object:nil];
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

-(IBAction)setStartToVideoPosition:(id)sender
{
    if (_playerView.player.status == AVPlayerStatusReadyToPlay) {
        CMTime currentTime = _playerView.player.currentTime;
        Float64 currentSeconds = CMTimeGetSeconds(currentTime);
        Time *startTime = [Time timeWithSeconds:currentSeconds];
        
        long int senderRow = [_subtitlesTable rowForView:[sender superview]];
        Subtitle *sub = [[_subtitlesController arrangedObjects] objectAtIndex:senderRow];
        sub.start = startTime;
    }
}

-(IBAction)setEndToVideoPosition:(id)sender
{
    if (_playerView.player.status == AVPlayerStatusReadyToPlay) {
        CMTime currentTime = _playerView.player.currentTime;
        Float64 currentSeconds = CMTimeGetSeconds(currentTime);
        Time *endTime = [Time new];
        
        endTime.hour = floor(currentSeconds / 3600);
        endTime.minute = floor(fmod((currentSeconds / 60), 60));
        endTime.second = fmod(currentSeconds, 60);
        
        long int senderRow = [_subtitlesTable rowForView:[sender superview]];
        Subtitle *sub = [[_subtitlesController arrangedObjects] objectAtIndex:senderRow];
        sub.end = endTime;
    }

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

-(IBAction)openVideo:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowedFileTypes = @[AVMediaTypeVideo, (__bridge NSString*)kUTTypeVideo, @"public.movie"];
    
    long response = [openPanel runModal];
    
    if(response == NSModalResponseOK){
        
        _playerView.player = [AVPlayer playerWithURL:openPanel.URL];
    }
}

-(void)updateWithUserDefaults
{
    for (Subtitle *sub in [_subtitlesController arrangedObjects])
    {
        [sub updateInfo];
    }
}


id timeObserver;
-(void)setVideoLock:(BOOL)videoLock
{
    _videoLock = videoLock;
    if(_videoLock)
    {
        CMTime tm = CMTimeMakeWithSeconds(1, 10);
        
        timeObserver = [_playerView.player addPeriodicTimeObserverForInterval:tm
             queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {

                 Time *currentTime = [Time timeWithSeconds:CMTimeGetSeconds(time)];
                 for(Subtitle *sub in [_subtitlesController arrangedObjects])
                 {
                     if([sub.end isGreaterThan:currentTime] && [sub.start isLessThan:currentTime])
                     {
                         [_subtitlesTable selectRowIndexes:[NSIndexSet indexSetWithIndex:sub.index-1] byExtendingSelection:NO];
                         [_subtitlesTable scrollRowToVisible:sub.index-1];
                         return;
                     }
                 }
             }];
    }
    else if(timeObserver){
        [_playerView.player removeTimeObserver:timeObserver];
    }
}

@end

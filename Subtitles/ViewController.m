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
        
        _subtitles = [NSMutableArray array];
        [self addSubtitle:nil];
        _indexSortDescriptor = [NSArray arrayWithObject:
                                [NSSortDescriptor sortDescriptorWithKey:@"index"
                                                              ascending:YES]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWithUserDefaults) name:NSUserDefaultsDidChangeNotification object:nil];
    }
    return self;
}

- (void)focusTextInSelection {
    NSTableRowView* view = [_subtitlesTable rowViewAtRow:_subtitlesTable.selectedRow makeIfNecessary:NO];
    if (view) {
        [_subtitlesTable.window makeFirstResponder:[view viewWithTag:10]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"rate"])
    {
        if(_playerView.player.rate != 0)
            [self startSubtitleAutoplay];
        else
            [self stopSubtitleAutoplay];
    }
    /*
     Be sure to call the superclass's implementation *if it implements it*.
     NSObject does not implement the method.
     */
    /*[super observeValueForKeyPath:keyPath
                         ofObject:object
                           change:change
                          context:context];
     */
}


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
        
        long int senderRow;
        if ([[sender class] isEqual: [NSMenuItem class]])
            senderRow = [_subtitlesTable selectedRow];
        else
            senderRow = [_subtitlesTable rowForView:[sender superview]];
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
        
        long int senderRow;
        if ([[sender class] isEqual: [NSMenuItem class]])
            senderRow = [_subtitlesTable selectedRow];
        else
            senderRow = [_subtitlesTable rowForView:[sender superview]];
        Subtitle *sub = [[_subtitlesController arrangedObjects] objectAtIndex:senderRow];
        sub.end = endTime;
    }

}

- (IBAction)addSubtitle:(id)sender {
    Subtitle *subtitle = [Subtitle new];
    [_subtitles addObject:subtitle];
    [_subtitlesController rearrangeObjects];
    
    [subtitle setIndex:[_subtitles count]];
    if(subtitle.index>1)
    {
        Subtitle *previoustSubtitle = _subtitles[subtitle.index-2];
        Time *startTime =  [previoustSubtitle.end copy];
        startTime.second = startTime.second + 0.001;
        [subtitle setStart: startTime];
    }
    [_subtitlesTable reloadData];
    [_subtitlesTable selectRowIndexes:[NSIndexSet indexSetWithIndex:subtitle.index-1] byExtendingSelection:NO ];
    
    [self focusTextInSelection];
}

- (IBAction)addSubtitleInPlace:(id)sender {
    [self addSubtitle:sender];
    [self setStartToVideoPosition:sender];
}

- (IBAction)insertSubtitleAbove:(id)sender {
    long int selectedRow = [_subtitlesTable selectedRow];
    [_subtitles insertObject:[Subtitle new] atIndex:selectedRow];
    [_subtitlesController rearrangeObjects];
    for (long int i = selectedRow; i < [_subtitlesController.arrangedObjects count]; i++) {
        ((Subtitle*)[_subtitles objectAtIndex:i]).index = i+1;
    }
    [_subtitlesTable reloadData];
    [_subtitlesTable selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
}

- (IBAction)InsertSubtitleBelow:(id)sender {
    long int selectedRow = [_subtitlesTable selectedRow];
    [_subtitles insertObject:[Subtitle new] atIndex:selectedRow+1];
    [_subtitlesController rearrangeObjects];
    for (long int i = selectedRow; i < [_subtitlesController.arrangedObjects count]; i++) {
        ((Subtitle*)[_subtitles objectAtIndex:i]).index = i+1;
    }
    [_subtitlesTable reloadData];
    [_subtitlesTable selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow+1] byExtendingSelection:NO];
}

- (IBAction)togglePlayback:(id)sender {
    if (_playerView.player.rate == 0) {
        _playerView.player.rate = 1.0;
    } else {
        _playerView.player.rate = 0.0;
    }
}

- (IBAction)removeSubtitle:(id)sender {
    long int selectedRow = [_subtitlesTable selectedRow];
    if (selectedRow >= 0) {
        NSRange range = NSMakeRange(selectedRow, 1);
        [_subtitles removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        [_subtitlesController rearrangeObjects];
        for (long int i = selectedRow; i < [_subtitlesController.arrangedObjects count]; i++) {
            ((Subtitle*)[_subtitles objectAtIndex:i]).index = i+1;
        }
        [_subtitlesTable reloadData];
        [_subtitlesTable selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow-1] byExtendingSelection:NO];
    }
}

-(NSString *)stringFromTableContent
{
    NSMutableString* srt = [NSMutableString string];
    
    for (Subtitle* sub in _subtitlesController.arrangedObjects)
    {
        [srt appendFormat:@"%lu\n%@ --> %@\n%@\n\n", sub.index, [sub.start toString], [sub.end toString], sub.text ? sub.text : @""];
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
            [self.view.window setTitleWithRepresentedFilename:savePanel.URL.path];

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
                if (components.count < 2) continue;
                
                if ([components[0] compare:@""] == NSEqualToComparison) {
                    if ([components[1] compare:@""] == NSEqualToComparison) {
                        continue;
                    }
                    [components removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,1)]];
                }
                
                Subtitle *subtitle = [Subtitle new];
                subtitle.index = [components[0] intValue];
                NSArray *times = [components[1] componentsSeparatedByString:@" --> "];
                subtitle.start = [Time timeWithString:times[0]];
                subtitle.end = [Time timeWithString:times[1]];
                
                [components removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)]];
                
                // check if string is empty
                if (components.count == 0) {
                    subtitle.text = @"";
                } else {
                    subtitle.text = [components componentsJoinedByString:@"\n"];
                }
                
                [_subtitlesController addObject:subtitle];
            }
        }
        
        [self.view.window setTitleWithRepresentedFilename:openPanel.URL.path];
        _filePath = openPanel.URL.path;
        
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
        
        _player = _playerView.player;
        
        [_player addObserver:self forKeyPath:@"rate" options:0 context:nil];
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
AVPlayer *observer;
bool observerSelection = NO;
-(void)startSubtitleAutoplay
{
    if (timeObserver) {
        return;
    }
    CMTime tm = CMTimeMakeWithSeconds(1, 10);
        
    observer = _playerView.player;
    timeObserver = [_playerView.player addPeriodicTimeObserverForInterval:tm
         queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0) usingBlock:^(CMTime time) {

             Time *currentTime = [Time timeWithSeconds:CMTimeGetSeconds(time)];
             for(Subtitle *sub in [_subtitlesController arrangedObjects])
             {
                 if([sub.end isGreaterThan:currentTime] && [sub.start isLessThan:currentTime])
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         //if(_videoLock)
                         {
                             observerSelection = YES;
                             [_subtitlesTable selectRowIndexes:[NSIndexSet indexSetWithIndex:sub.index-1] byExtendingSelection:NO];
                             observerSelection = NO;
                             [_subtitlesTable scrollRowToVisible:sub.index-1];
                         }
                         _subtitleView.text = sub.text;
                     });
                     return;
                 }
             }
         }];
}

-(void)stopSubtitleAutoplay
{
    if(timeObserver){
        [observer removeTimeObserver:timeObserver];
        timeObserver = nil;
    }
}


-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _subtitles.count;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    Subtitle *sub = [_subtitlesController.arrangedObjects objectAtIndex:_subtitlesTable.selectedRow];
    _subtitleView.text = sub.text;
    if ( !observerSelection && !_playerView.player.error && _videoLock) {
//        _playerView.player.rate = 0;
        [_playerView.player seekToTime:CMTimeMakeWithSeconds([sub.start toSeconds], 100)];
//        _playerView.player.rate = 1;
    }
}

-(IBAction)centerSelectionInVisibleArea:(id)sender
{
    [_subtitlesTable scrollRowToVisible:(Subtitle*)[_subtitles objectAtIndex:[_subtitlesTable selectedRow]]];
}

@end

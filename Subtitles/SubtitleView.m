//
//  SubtitleView.m
//  Subtitles
//
//  Created by Enie Weiß on 11/03/15.
//  Copyright (c) 2015 Enie Studio. All rights reserved.
//

#import "SubtitleView.h"

static void *AVSPPlayerItemStatusContext = &AVSPPlayerItemStatusContext;
static void *AVSPPlayerRateContext = &AVSPPlayerRateContext;
static void *AVSPPlayerLayerReadyForDisplay = &AVSPPlayerLayerReadyForDisplay;

@implementation SubtitleView

#pragma mark - Destination Operations

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self registerForDraggedTypes:@[AVMediaTypeVideo,AVMediaTypeSubtitle,(__bridge NSString*)kUTTypeVideo]];
        [self.window registerForDraggedTypes:@[AVMediaTypeVideo,AVMediaTypeSubtitle,(__bridge NSString*)kUTTypeVideo]];
    }
    return self;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    /*------------------------------------------------------
     method called whenever a drag enters our drop zone
     --------------------------------------------------------*/
    
    // Check if the pasteboard contains image data and source/user wants it copied
    if ([sender draggingSourceOperationMask] &
        NSDragOperationCopy ) {
        
        //accept data as a copy operation
        return NSDragOperationCopy;
    }
    
    return NSDragOperationNone;
}


- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    /*------------------------------------------------------
     method to determine if we can accept the drop
     --------------------------------------------------------*/
    //finished with the drag so remove any highlighting
    
    //if the drag comes from a file, set the window title to the filename
    NSURL* fileURL=[NSURL URLFromPasteboard: [sender draggingPasteboard]];
    AVURLAsset *asset = [AVURLAsset assetWithURL:fileURL];
    
    //check to see if we can accept the data
    return asset?YES:NO;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    /*------------------------------------------------------
     method that should handle the drop data
     --------------------------------------------------------*/
    if ( [sender draggingSource] != self ) {
        NSURL* fileURL;
        
        fileURL=[NSURL URLFromPasteboard: [sender draggingPasteboard]];
        AVURLAsset *asset = [AVURLAsset assetWithURL:fileURL];
        
        if (![asset isPlayable] || [asset hasProtectedContent])
        {
            // We can't play this asset. Show the "Unplayable Asset" label.
            //[self stopLoadingAnimationAndHandleError:nil];
            //self.unplayableLabel.hidden = NO;
            return NO;
        }
        
        if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0)
        {
            // Create an AVPlayerLayer and add it to the player view if there is video, but hide it until it's ready for display
            AVPlayerLayer *newPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            newPlayerLayer.frame = self.playerView.layer.bounds;
            newPlayerLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
            newPlayerLayer.hidden = YES;
            [self.playerView.layer addSublayer:newPlayerLayer];
            self.playerLayer = newPlayerLayer;
            [self addObserver:self forKeyPath:@"playerLayer.readyForDisplay" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVSPPlayerLayerReadyForDisplay];
        }
        else
        {
            // This asset has no video tracks. Show the "No Video" label.
        }
        
        // Create a new AVPlayerItem and make it our player's current item.
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
        
        // If needed, configure player item here (example: adding outputs, setting text style rules, selecting media options) before associating it with a player
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
        
        
    }
    
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    if (outError != NULL)
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    if (outError != NULL)
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    return YES;
}

- (void)pasteboard:(NSPasteboard *)sender item:(NSPasteboardItem *)item provideDataForType:(NSString *)type
{
    /*------------------------------------------------------
     method called by pasteboard to support promised
     drag types.
     --------------------------------------------------------*/
    //sender has accepted the drag and now we need to send the data for the type we promised
    if ( [type compare: NSPasteboardTypeTIFF] == NSOrderedSame ) {
        
        //set data for TIFF type on the pasteboard as requested
        //[sender setData:[[self image] TIFFRepresentation] forType:NSPasteboardTypeTIFF];
        
    } else if ( [type compare: NSPasteboardTypePDF] == NSOrderedSame ) {
        
        //set data for PDF type on the pasteboard as requested
        [sender setData:[self dataWithPDFInsideRect:[self bounds]] forType:NSPasteboardTypePDF];
    }
    
}

@end

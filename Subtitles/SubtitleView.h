//
//  SubtitleView.h
//  Subtitles
//
//  Created by Enie Weiß on 11/03/15.
//  Copyright (c) 2015 Enie Studio. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SubtitleView : NSView <NSDraggingDestination, NSPasteboardItemDataProvider>

@property IBOutlet AVPlayerView *playerView;
@property (strong) AVPlayer *player;
@property (strong) AVPlayerLayer *playerLayer;

@end

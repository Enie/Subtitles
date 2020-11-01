//
//  SubtitleWindowController.m
//  Subtitles
//
//  Created by Enie Weiß on 11/03/15.
//  Copyright (c) 2015 Enie Studio. All rights reserved.
//

#import "SubtitleWindowController.h"

@interface SubtitleWindowController ()

@end

@implementation SubtitleWindowController

NSTimer* timer;

- (void)windowDidLoad {
    [super windowDidLoad];
    timer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [[[[self.window standardWindowButton:NSWindowCloseButton] superview] animator] setAlphaValue:0];
    }];
}

-(void)mouseMoved:(NSEvent *)event {
    if (timer) [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [[[[self.window standardWindowButton:NSWindowCloseButton] superview] animator] setAlphaValue:0];
    }];
    [[[[self.window standardWindowButton:NSWindowCloseButton] superview] animator] setAlphaValue:1];
    
    
}

@end

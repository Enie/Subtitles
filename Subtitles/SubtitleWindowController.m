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

- (void)windowDidLoad {
    [super windowDidLoad];
    
#ifdef MAC_OS_X_VERSION_10_10
    [self.window setTitleVisibility:NSWindowTitleHidden];
    [self.window setTitlebarAppearsTransparent:YES];
    self.window.styleMask = self.window.styleMask | NSFullSizeContentViewWindowMask;
    
#endif
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end

//
//  AppDelegate.m
//  Subtitles
//
//  Created by Enie Weiß on 10/03/15.
//  Copyright (c) 2015 Enie Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "SubtitleWindowController.h"
#import "PreferencesWindowController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

-(void)awakeFromNib
{
    _windowControllers = [NSMutableArray array];
    
    
    [self newDocument:nil];
    self.appHasKeyWindow = YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)newDocument:(id)sender
{
    SubtitleWindowController *controllerWindow = [[SubtitleWindowController alloc] initWithWindowNibName:@"SubtitleWindowController"];
    
    if(self.keyWindow)
        [_keyWindow resignKeyWindow];
    
    [controllerWindow.window orderFront:nil];
    [controllerWindow.window makeKeyWindow];
    [_windowControllers addObject:controllerWindow];
}

-(IBAction)openDocument:(id)sender
{
    if(!self.keyWindow)
        [self newDocument:nil];
    [((SubtitleWindowController*)_keyWindow.windowController).viewController openDocument:sender];
}

-(IBAction)openVideo:(id)sender
{
    if(!self.keyWindow)
        [self newDocument:nil];
    [((SubtitleWindowController*)_keyWindow.windowController).viewController openVideo:sender];
}

-(IBAction)saveDocument:(id)sender
{
    if(self.keyWindow)
        [((SubtitleWindowController*)_keyWindow.windowController).viewController saveDocument:sender];

}

-(IBAction)saveDocumentAs:(id)sender
{
    if(self.keyWindow)
        [((SubtitleWindowController*)_keyWindow.windowController).viewController saveDocumentAs:sender];
}

- (IBAction)performClose:(id)sender
{
    NSWindow *closingWindow = [[NSApplication sharedApplication] keyWindow];
    [_windowControllers removeObject:closingWindow.windowController];
    
    if (!_windowControllers.count) {
        self.appHasKeyWindow = NO;
    }
}

- (IBAction)showPreferencesWindow:(id)sender {
    _prefWindowController = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindowController"];
    [_prefWindowController.window orderFront:nil];
    [_prefWindowController.window makeKeyWindow];
}


-(NSWindow *)keyWindow
{
    _keyWindow = [[NSApplication sharedApplication] keyWindow];
    return [[NSApplication sharedApplication] keyWindow];
}

@end

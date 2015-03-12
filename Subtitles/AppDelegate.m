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
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)newDocument:(id)sender
{
    SubtitleWindowController *controllerWindow = [[SubtitleWindowController alloc] initWithWindowNibName:@"SubtitleWindowController"];
    //[controllerWindow showWindow:self];
    
    NSWindow *keyWindow = [[NSApplication sharedApplication] keyWindow];
    if(keyWindow){
        [keyWindow resignKeyWindow];
    }
    
    [controllerWindow.window orderFront:nil];
    [controllerWindow.window makeKeyWindow];
    [_windowControllers addObject:controllerWindow];
}

-(IBAction)openDocument:(id)sender
{
    NSWindow *keyWindow = [[NSApplication sharedApplication] keyWindow];
    if(!keyWindow)
    {
        [self newDocument:nil];
        keyWindow = [[NSApplication sharedApplication] keyWindow];
    }
    [((SubtitleWindowController*)keyWindow.windowController).viewController openDocument:sender];
}

-(IBAction)openVideo:(id)sender
{
    NSWindow *keyWindow = [[NSApplication sharedApplication] keyWindow];
    if(!keyWindow)
    {
        [self newDocument:nil];
        keyWindow = [[NSApplication sharedApplication] keyWindow];
    }
    [((SubtitleWindowController*)keyWindow.windowController).viewController openVideo:sender];
}

-(IBAction)saveDocument:(id)sender
{
    NSWindow *keyWindow = [[NSApplication sharedApplication] keyWindow];
    if(keyWindow)
        [((SubtitleWindowController*)keyWindow.windowController).viewController saveDocument:sender];

}

-(IBAction)saveDocumentAs:(id)sender
{
    NSWindow *keyWindow = [[NSApplication sharedApplication] keyWindow];
    if(keyWindow)
        [((SubtitleWindowController*)keyWindow.windowController).viewController saveDocumentAs:sender];
}

- (IBAction)performClose:(id)sender
{
    NSWindow *closingWindow = [[NSApplication sharedApplication] keyWindow];
    [_windowControllers removeObject:closingWindow.windowController];
}

- (IBAction)showPreferencesWindow:(id)sender {
    _prefWindowController = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindowController"];
    [_prefWindowController.window orderFront:nil];
    [_prefWindowController.window makeKeyWindow];
}



@end

//
//  Subtitle.h
//  Subtitles
//
//  Created by Enie Weiß on 10/03/15.
//  Copyright (c) 2015 Enie Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@class Time;

@interface Subtitle : NSObject <NSCopying>

@property long int index;
@property (strong, nonatomic) NSString *text;

@property (nonatomic) Time *start;
@property (nonatomic) Time *end;
@property (nonatomic) Time *duration;

@property int charactersPerLine;
@property double charactersPerSecond;
@property int lines;

@property NSColor *charactersPerLineErrorColor;
@property NSColor *charactersPerSecondErrorColor;
@property NSColor *linesErrorColor;
@property NSColor *durationErrorColor;

@end

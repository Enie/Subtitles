//
//  Subtitle.m
//  Subtitles
//
//  Created by Enie Weiß on 10/03/15.
//  Copyright (c) 2015 Enie Studio. All rights reserved.
//

#import "Subtitle.h"
#import "Time.h"

@implementation Subtitle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _start = [Time timeWithString:@"00:00:00,000"];
        _end = [Time timeWithString:@"00:00:00,000"];
        _duration = [Time timeWithString:@"00:00:00,000"];
    }
    return self;
}


NSString* newlineCharacter;
-(void)updateInfo
{
    if (_text) {
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"</?\w+((\s+\w+(\s*=\s*(?:\".*?\"|'.*?'|[^'\">\s]+))?)+\s*|\s*)/?>" options:NSRegularExpressionCaseInsensitive error:&error];
        NSString *pureString = [regex stringByReplacingMatchesInString:_text options:0 range:NSMakeRange(0, [_text length]) withTemplate:@""];
        //NSLog(@"%@", pureString);
        
        double durationInSeconds = (_duration.hour*3600 + _duration.minute*60 + _duration.second);
        if (durationInSeconds!=0)
            self.charactersPerSecond = (double)[pureString length] / durationInSeconds;
        else
            self.charactersPerSecond = INFINITY;
        
        if([pureString rangeOfString:@"\r\n"].location != NSNotFound)
            newlineCharacter = @"\r\n";
        else if([pureString rangeOfString:@"\r"].location != NSNotFound)
            newlineCharacter = @"\r\n";
        else
            newlineCharacter = @"\n";
        
        NSArray *lines = [pureString componentsSeparatedByString:newlineCharacter];
        self.lines = (int)lines.count;
        
        int maxCharactersPerLine = 0;
        for (NSString *line in lines) {
            if (line.length > maxCharactersPerLine) {
                maxCharactersPerLine = (int)line.length;
            }
        }
        self.charactersPerLine = maxCharactersPerLine;
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"maxLines"] && [[NSUserDefaults standardUserDefaults] integerForKey:@"maxLines"] < _lines )
            self.linesErrorColor = [NSColor redColor];
        else
            self.linesErrorColor = nil;
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"maxCharactersPerLine"] && [[NSUserDefaults standardUserDefaults] integerForKey:@"maxCharactersPerLine"] < _charactersPerLine )
            self.charactersPerLineErrorColor = [NSColor redColor];
        else
            self.charactersPerLineErrorColor = nil;
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"maxCharactersPerSecond"] && [[NSUserDefaults standardUserDefaults] integerForKey:@"maxCharactersPerSecond"] < _charactersPerSecond )
            self.charactersPerSecondErrorColor = [NSColor redColor];
        else
            self.charactersPerSecondErrorColor = nil;
        
        if ( [[Time timeWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"maxDurationPerSubtitle"]] isLessThan:_duration] )
            self.durationErrorColor = [NSColor redColor];
        else
            self.durationErrorColor = nil;
        
        if ( [[Time timeWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"minDurationPerSubtitle"]] isGreaterThan:_duration] )
            self.durationErrorColor = [NSColor redColor];
        else
            self.durationErrorColor = nil;
    }
}

-(void)setText:(NSString *)text
{
    _text = text;
    
    [self updateInfo];
}

-(void)setStart:(Time*)start
{
    _start = start;
    if ([_start isGreaterThan: _end])
        self.end = [_start timeAddingTime:_duration];
    else
        [self setDuration:[_end timeSubtractingTime:_start]];
    
        [self updateInfo];
}

-(void)setEnd:(Time*)end
{
    _end = end;
    if([_start isGreaterThan: _end])
        self.start = [_end timeSubtractingTime:_duration];
    else
        [self setDuration:[_end timeSubtractingTime:_start]];
    
    [self updateInfo];
}

-(void)setDuration:(Time*)duration
{
    _duration = duration;
    //self.end = _start + _duration;
    
    [self updateInfo];
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

-(id)copyWithZone:(NSZone *)zone
{
    Subtitle *copy = [Subtitle new];
    
    if (copy)
    {
        copy.text = [_text copyWithZone:zone];
        
        copy.start = [_start copyWithZone:zone];
        copy.end = [_end copyWithZone:zone];
        copy.duration = [_duration copyWithZone:zone];
        
        
        copy.index = _index;
        copy.charactersPerLine = _charactersPerLine;
        copy.charactersPerSecond = _charactersPerSecond;
        copy.lines = _lines;
    }
    
    return copy;
}

@end

//
//  TimeFormatter.m
//  Subtitles
//
//  Created by Enie Weiß on 10/03/15.
//  Copyright (c) 2015 Enie Studio. All rights reserved.
//

#import "TimeFormatter.h"
#import "Time.h"

@implementation TimeFormatter

- (NSString *)stringForObjectValue:(id)value;
{
    if (![value isKindOfClass:[Time class]]) {
        return nil;
    }
    
    return [value toString];
}

- (BOOL)getObjectValue:(out __autoreleasing id *)obj
             forString:(NSString *)string
      errorDescription:(out NSString *__autoreleasing *)error;
{
    Time *time = [Time timeWithString:string];
    
    if (time) {
        *obj = time;
        return YES;
    } else if (error) {
        *error = [NSString stringWithFormat:@"%@ is not a proper time format", string];
    }
    
    return NO;
}
@end

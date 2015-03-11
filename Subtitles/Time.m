//
//  Time.m
//  Subtitles
//
//  Created by Enie Weiß on 10/03/15.
//  Copyright (c) 2015 Enie Studio. All rights reserved.
//

#import "Time.h"

@implementation Time

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _hour = [coder decodeIntForKey:@"hour"];
        _minute = [coder decodeIntForKey:@"minute"];
        _second = [coder decodeDoubleForKey:@"second"];
    }
    return self;
}

-(instancetype)initWithString:(NSString *)time
{
    self = [super init];
    if (self) {
        NSArray *components = [[time stringByReplacingOccurrencesOfString:@"," withString:@"."] componentsSeparatedByString:@":"];
        if (components.count!=3) {
            return nil;
        }
        _hour = [components[0] intValue];
        _minute = [components[1] intValue] > 59? 59 : [components[1] intValue];
        _second = [components[2] doubleValue] > 59.999 ? 59.999 : [components[2] doubleValue];
    }
    return self;
}

+(instancetype)timeWithString:(NSString *)time
{
    return [[Time alloc] initWithString:time];
}

-(NSString *)toString
{
    return [[NSString stringWithFormat:@"%02i:%02i:%06.3F", _hour, _minute, _second] stringByReplacingOccurrencesOfString:@"." withString:@","];
}

-(Time *)timeSubtractingTime:(Time *)time
{
    Time *subTime = [Time new];
    subTime.hour = _hour - time.hour;
    subTime.minute = _minute - time.minute;
    subTime.second = _second - time.second;
    
    return subTime;
}

-(Time *)timeAddingTime:(Time *)time
{
    Time *addTime = [Time new];
    addTime.hour = _hour + time.hour;
    addTime.minute = _minute + time.minute;
    addTime.second = _second + time.second;
    
    return addTime;
}

-(id)copyWithZone:(NSZone *)zone
{
    Time *copy = [Time new];
    
    if (copy)
    {
        copy.hour = self.hour;
        copy.minute = self.minute;
        copy.second = self.second;
    }
    
    return copy;
}

- (BOOL)isEqual:(Time*)other
{
    if (other.hour==_hour && other.minute == _minute && other.second == _second) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isLessThan:(Time*)object
{
    if ((object.hour*3600.0 + object.minute*60.0 + object.second > _hour*3600.0 + _minute*60.0 + _second))
        return YES;
    else
        return NO;
}

-(BOOL)isGreaterThan:(Time*)object
{
    if ((object.hour*3600.0 + object.minute*60.0 + object.second < _hour*3600.0 + _minute*60.0 + _second))
        return YES;
    else
        return NO;
}

-(BOOL)isGreaterThanOrEqualTo:(Time*)object
{
    return [self isEqual:object] || [self isGreaterThan:object];
}

-(BOOL)isLessThanOrEqualTo:(Time*)object
{
    return [self isEqual:object] || [self isLessThan:object];
}


//- (NSUInteger)hash
//{
//    return ;
//}

- (void)encodeWithCoder:(NSCoder *)coder
{
    //[super encodeWithCoder:coder];
    [coder encodeInt:_hour forKey:@"hour"];
    [coder encodeInt:_minute forKey:@"minute"];
    [coder encodeDouble:_second forKey:@"second"];
    
}

@end

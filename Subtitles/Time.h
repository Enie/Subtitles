//
//  Time.h
//  Subtitles
//
//  Created by Enie Weiß on 10/03/15.
//  Copyright (c) 2015 Enie Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Time : NSObject <NSCopying, NSCoding>

@property short hour;
@property short minute;
@property double second;

-(instancetype)initWithString:(NSString*)time;
+(instancetype)timeWithString:(NSString*)time;
+(instancetype)timeWithSeconds:(double)seconds;

-(NSString*)toString;
-(double)toSeconds;
-(Time*)timeSubtractingTime:(Time*)time;
-(Time*)timeAddingTime:(Time*)time;

@end

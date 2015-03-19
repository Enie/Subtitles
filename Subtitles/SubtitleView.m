//
//  SubtitleView.m
//  Subtitles
//
//  Created by Enie Weiß on 11/03/15.
//  Copyright (c) 2015 Enie Studio. All rights reserved.
//

#import "SubtitleView.h"

@implementation SubtitleView

CATextLayer *textLayer;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    
        [self setWantsLayer:YES];
        textLayer = [CATextLayer layer];
        textLayer.string = _text;
        textLayer.fontSize = 16;
        textLayer.alignmentMode = kCAAlignmentCenter;

        self.text = @"";
        [self.layer addSublayer:textLayer];
    }
    return self;
}

-(void)setText:(NSString *)text
{
    _text = text;
    textLayer.string = _text;
    CGRect labelRect = [_text boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [NSFont fontWithName:@"HelveticaNeue" size:17.0] }];
    textLayer.frame = labelRect;
    textLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds)  + CGRectGetHeight(labelRect)/2);
}

-(void)layout
{
    [super layout];
    CGRect labelRect = [_text boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [NSFont fontWithName:@"HelveticaNeue" size:17.0] }];
    textLayer.frame = labelRect;
    textLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds) + CGRectGetHeight(labelRect)/2);
}

@end

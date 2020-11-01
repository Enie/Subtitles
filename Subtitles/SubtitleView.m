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
CALayer *backgroundLayer;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    
        [self setWantsLayer:YES];
        textLayer = [CATextLayer layer];
        textLayer.string = _text;
        textLayer.fontSize = 16;
        textLayer.alignmentMode = kCAAlignmentCenter;

        backgroundLayer = [CALayer layer];
        backgroundLayer.backgroundColor = [NSColor.blackColor colorWithAlphaComponent:0.8].CGColor;
        backgroundLayer.cornerRadius = 8;
        
        self.text = @"";
        [self.layer addSublayer:backgroundLayer];
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
    textLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds)  + CGRectGetHeight(labelRect));
    
    labelRect.origin.x -= 8;
    labelRect.origin.y -= 4;
    labelRect.size.width += 16;
    labelRect.size.height += 16;
    backgroundLayer.frame = labelRect;
    backgroundLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds)  + CGRectGetHeight(labelRect) - 12);
}

-(void)layout
{
    [super layout];
    CGRect labelRect = [_text boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [NSFont fontWithName:@"HelveticaNeue" size:17.0] }];
    textLayer.frame = labelRect;
    textLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds) + CGRectGetHeight(labelRect));
    
    labelRect.origin.x -= 8;
    labelRect.origin.y -= 4;
    labelRect.size.width += 16;
    labelRect.size.height += 16;
    backgroundLayer.frame = labelRect;
    backgroundLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds)  + CGRectGetHeight(labelRect) - 12);
}

@end

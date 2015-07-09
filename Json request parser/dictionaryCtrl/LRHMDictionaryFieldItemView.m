//
//  LRHMDictionaryFieldItemView.m
//  testss
//
//  Created by aggsugar on 15/4/3.
//  Copyright (c) 2015年 aggsugar. All rights reserved.
//

#import "LRHMDictionaryFieldItemView.h"

@implementation LRHMDictionaryFieldItemView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [[NSColor colorWithDeviceWhite:0.4 alpha:0.3] setStroke];
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:6 yRadius:6];
    [path stroke];
}

@end

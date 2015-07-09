//
//  LRHMView.m
//  Json request parser
//
//  Created by tangj on 15/4/27.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMView.h"

@implementation LRHMView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    if ([self.identifier isEqualToString:@"httpRequestUI"]) {
        [[NSColor colorWithDeviceRed:222.0/255 green:222.0/255 blue:221.0/255 alpha:1.0f] set];
    }
    
    if ([self.identifier isEqualToString:@"recordHeader"]) {
        [[NSColor colorWithDeviceRed:96.0/255 green:92.0/255 blue:93.0/255 alpha:1.0] set];
    }
    if ([self.identifier isEqualToString:@"addCollectionHeader"]) {
        [[NSColor colorWithDeviceRed:132.0/255 green:131.0/255 blue:130.0/255 alpha:1.0] set];
    }
    if ([self.identifier isEqualToString:@"addCollectionContent"]) {
        [[NSColor colorWithDeviceRed:214.0/255 green:214.0/255 blue:213.0/255 alpha:1.0] set];
    }
    NSRectFill(self.bounds);
}

@end

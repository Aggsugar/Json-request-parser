//
//  Titlebar.m
//  VideoEdit
//
//  Created by Duen Yuen on 8/21/14.
//  Copyright (c) 2014 Jorn Dan. All rights reserved.
//

#import "LRHMTitleBar.h"

@implementation LRHMTitleBar

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (BOOL) acceptsFirstResponder
{
    return YES;
}
- (BOOL)isOpaque
{
    return  NO;
}

#define DEFAULT_CORNER 8
- (void)drawRect:(NSRect)dirtyRect
{
    NSRect bounds = [self bounds];
    
    if (_fillColor) {
        [_fillColor setFill];
    }else{
        [[NSColor whiteColor]setFill];
    }
    if (_borderColor) {
        [_borderColor setStroke];
    }else{
        [[NSColor whiteColor] setStroke];
    }
    
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(0, 0)];
    [path lineToPoint:NSMakePoint(0, bounds.size.height - DEFAULT_CORNER)];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(DEFAULT_CORNER, bounds.size.height-DEFAULT_CORNER)
                                     radius:DEFAULT_CORNER
                                 startAngle:180
                                   endAngle:90
                                  clockwise:YES
     ];
    
    [path lineToPoint:NSMakePoint(bounds.size.width-DEFAULT_CORNER, bounds.size.height)];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(bounds.size.width-DEFAULT_CORNER, bounds.size.height-DEFAULT_CORNER)
                                     radius:DEFAULT_CORNER
                                 startAngle:90
                                   endAngle:0
                                  clockwise:YES];
    [path lineToPoint:NSMakePoint(bounds.size.width, 0)];
    [path lineToPoint:NSMakePoint(0, 0)];
    [path closePath];
    [path setLineWidth:2];
    
    [path fill];
    [path stroke];
    
    
    //绘制Title
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    [style setAlignment:NSCenterTextAlignment];
    
    NSMutableDictionary* titleAtt = [[NSMutableDictionary alloc]init];
    [titleAtt setValue:style forKey:NSParagraphStyleAttributeName];
    [style release];
    if (_titleColor) {
        [titleAtt setValue:_titleColor forKey:NSForegroundColorAttributeName];
    }else{
        [titleAtt setValue:[NSColor windowFrameTextColor] forKey:NSForegroundColorAttributeName];
    }
    float fontSize = [NSFont systemFontSize];
    NSFont* font = [NSFont titleBarFontOfSize:fontSize];
    [titleAtt setValue:font forKey:NSFontAttributeName];
    
    
    NSString* title = [[self window]title];
    NSRect titleRc = bounds;
    titleRc.origin.y -= 2;
    [title drawInRect:titleRc withAttributes:titleAtt];
    if (titleAtt) {
        [titleAtt release];
    }
}
- (void) mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
}
- (void) mouseUp:(NSEvent *)theEvent
{
    [super mouseUp:theEvent];
}
- (void) keyDown:(NSEvent *)theEvent
{
//    [super keyDown:theEvent];
    [[super nextResponder]keyDown:theEvent];
}

@end

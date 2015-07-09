//
//  LRHMTableCellView.m
//  Json request parser
//
//  Created by aggsugar on 15/4/9.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMTableCellView.h"
#define _button_space_   0
@interface LRHMTableCellView()
@property (assign) BOOL isMouseInActiveArea;
@end

@implementation LRHMTableCellView
@synthesize editButton = _editButton;
@synthesize deleteButton = _deleteButton;

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    if (self.isMouseInActiveArea) {
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:self.bounds];
        [[NSColor colorWithDeviceRed:153.0/255 green:191.0/255 blue:43.0/255 alpha:1.0f] set];
        [path fill];
    }else{
//        [[NSColor blueColor] setFill];
//        NSRectFill(self.bounds);
    }
 
}

- (void)viewWillDraw {
    [super viewWillDraw];
        NSRect textFrame = self.textField.frame;
        NSRect deletebuttonFrame = self.deleteButton.frame;
        deletebuttonFrame.origin.x = NSWidth(self.frame) - NSWidth(deletebuttonFrame) - _button_space_;
        self.deleteButton.frame = deletebuttonFrame;
    if (self.editButton) {
        NSRect editButtonFrame = self.editButton.frame;
        editButtonFrame.origin.x = NSMinX(deletebuttonFrame) - NSWidth(editButtonFrame) - _button_space_;
        self.editButton.frame = editButtonFrame;
        
        textFrame.size.width = NSMinX(editButtonFrame) - NSMinX(textFrame);
        self.textField.frame = textFrame;
    }else{
        textFrame.size.width = NSMinX(deletebuttonFrame) - NSMinX(textFrame);
        self.textField.frame = textFrame;
    }
    
    
}

- (void)awakeFromNib
{
    self.isMouseInActiveArea = NO;
    [self.deleteButton setHidden:YES];
    [self.editButton setHidden:YES];
    
    [self addTrackArea];
}

#pragma mark trackArea
- (void)updateTrackingAreas
{
    for (NSTrackingArea *area in self.trackingAreas) {
        [self removeTrackingArea:area];
    }
    [self addTrackArea];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    self.isMouseInActiveArea = YES;
    [self.deleteButton setHidden:NO];
    [self.editButton setHidden:NO];
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    self.isMouseInActiveArea = NO;
    
    [self.editButton setHidden:YES];
    [self.deleteButton setHidden:YES];
    [self setNeedsDisplay:YES];
}

- (void)addTrackArea
{
    NSTrackingArea * area = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveInKeyWindow | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    [self addTrackingArea:area];
    [area release];
}

#pragma mark dealloc
- (void)dealloc {
    self.deleteButton = nil;
    self.editButton = nil;
    [super dealloc];
}
@end

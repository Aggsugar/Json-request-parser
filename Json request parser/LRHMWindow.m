//
//  testWindow.m
//  testPopupView
//
//  Created by aggsugar on 15/4/27.
//  Copyright (c) 2015年 tangj. All rights reserved.
//

#import "LRHMWindow.h"

@implementation LRHMWindow
@synthesize initialLocation;
- (BOOL)canBecomeKeyWindow{
    return YES;
}

- (BOOL)canBecomeMainWindow
{
    return YES;
}


- (void)mouseDown:(NSEvent *)theEvent {
    
    // Get the mouse location in window coordinates.
    self.initialLocation = [theEvent locationInWindow];
}

/*
 Once the user starts dragging the mouse, move the window with it. The window has no title bar for
 the user to drag (so we have to implement dragging ourselves)
 */
- (void)mouseDragged:(NSEvent *)theEvent {
    
    NSRect screenVisibleFrame = [[NSScreen mainScreen] visibleFrame];
    NSRect windowFrame = [self frame];
    NSPoint newOrigin = windowFrame.origin;
    
    // Get the mouse location in window coordinates.
    NSPoint currentLocation = [theEvent locationInWindow];
    // Update the origin with the difference between the new mouse location and the old mouse location.
    newOrigin.x += (currentLocation.x - initialLocation.x);
    newOrigin.y += (currentLocation.y - initialLocation.y);
    
    // Don't let window get dragged up under the menu bar
    if ((newOrigin.y + windowFrame.size.height) > (screenVisibleFrame.origin.y + screenVisibleFrame.size.height)) {
        newOrigin.y = screenVisibleFrame.origin.y + (screenVisibleFrame.size.height - windowFrame.size.height);
    }
    
    // Move the window to the new location
    [self setFrameOrigin:newOrigin];
}

@end

//
//  MPViewController.m
//  MediaPlayer
//
//  Created by tangj on 15/4/23.
//  Copyright (c) 2015年 Jorn Dan. All rights reserved.
//

#import "LRHMViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LRHMWindow.h"
@interface LRHMViewController ()
{
    LRHMWindow *_popupWnd;
}
@end

@implementation LRHMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.wantsLayer = YES;
    // Do view setup here.
}

- (void)popupView
{
    [self initPopupWnd];
    [self shakeAnimationWnd];
//    [_popupWnd becomeFirstResponder];
}

- (void)initPopupWnd
{
    if (!_popupWnd) {
        _popupWnd = [[LRHMWindow alloc] initWithContentRect:self.view.frame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
        [_popupWnd setOpaque:NO];
        [_popupWnd setBackgroundColor:[NSColor clearColor]];
        [[_popupWnd contentView] addSubview:self.view];
    }
}


- (void)closePopupView
{
    [_popupWnd orderOut:nil];
    [NSApp stopModal];
}

- (NSRect)startFrameOfPopupWnd
{
    NSRect startFrame = [[NSApp mainWindow] frame];
    startFrame.origin.x = (NSWidth(startFrame) - NSWidth(self.view.frame)) * 0.5 + NSMinX(startFrame);
    startFrame.origin.y = NSMaxY(startFrame);
    startFrame.size = self.view.frame.size;
    
    return startFrame;
}

- (NSRect)endFrameOfPopupWnd
{
    NSRect endRect = [self startFrameOfPopupWnd];
    endRect.origin.y = (NSHeight([[NSApp mainWindow] frame]) - NSHeight(self.view.frame)) * 0.5 + NSMinY([[NSApp mainWindow] frame]);
    return endRect;
}

- (void)shakeAnimationWnd
{
    NSRect startFrame = [self startFrameOfPopupWnd];
    NSRect endFrame = [self endFrameOfPopupWnd];
    
    [_popupWnd setFrame:startFrame display:YES];
    [_popupWnd orderFront:nil];
    
    static int numberOfShakes = 2;
    static float durationOfShake = 0.5f;
    static float vigourOfShake = 0.05f;
    
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];
    
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, NSMinX(startFrame), NSMinY(startFrame));
    CGPathAddLineToPoint(shakePath, NULL, NSMinX(endFrame), NSMinY(endFrame));
    for (NSInteger index = 0; index < numberOfShakes; index++){
        CGPathAddLineToPoint(shakePath, NULL, NSMinX(endFrame) - endFrame.size.width * vigourOfShake, NSMinY(endFrame));
        CGPathAddLineToPoint(shakePath, NULL, NSMinX(endFrame) + endFrame.size.width * vigourOfShake, NSMinY(endFrame));
    }
    //    CGPathCloseSubpath(shakePath);
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = durationOfShake;
    
    [_popupWnd setAnimations:[NSDictionary dictionaryWithObject: shakeAnimation forKey:@"frameOrigin"]];
    [[_popupWnd animator] setFrameOrigin:endFrame.origin];
    
    [NSApp runModalForWindow:_popupWnd];
}

- (void)fadeInView
{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    animation.duration = 1.0;
////    animation.autoreverses = NO;
////    animation.repeatCount = 1;
//    animation.fromValue = [NSNumber numberWithFloat:1];
//    animation.toValue = [NSNumber numberWithFloat:0];
////    animation.removedOnCompletion = YES;
//    animation.delegate = self;
//    [self.view.layer addAnimation:animation forKey:@""];
    [NSAnimationContext beginGrouping];
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:self.view,NSViewAnimationTargetKey,NSViewAnimationFadeOutEffect,NSViewAnimationEffectKey, nil];
    NSViewAnimation *viewAnimation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObject:attribute]];
    [viewAnimation setDuration:0.8f];
    [viewAnimation startAnimation];
    [NSAnimationContext endGrouping];
}

- (void)fadeOutAnimation
{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    animation.duration = 1.0;
////    animation.autoreverses = YES;
//    //    animation.repeatCount = 1;
//    animation.fromValue = [NSNumber numberWithFloat:0];
//    animation.toValue = [NSNumber numberWithFloat:1];
//    animation.delegate = self;
//    [self.view.layer addAnimation:animation forKey:@""];
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:self.view,NSViewAnimationTargetKey,NSViewAnimationFadeInEffect,NSViewAnimationEffectKey, nil];
    NSViewAnimation *viewAnimation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObject:attribute]];
    [viewAnimation setDuration:0.8f];
    [viewAnimation startAnimation];
}
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    if (flag && !([self.view isHidden])) {
//        [self.view setHidden:YES];
//    }else if(flag && [self.view isHidden]){
//        [self.view setHidden:NO];
//    }
//}
@end

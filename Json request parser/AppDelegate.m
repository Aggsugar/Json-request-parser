//
//  AppDelegate.m
//  Json request parser
//
//  Created by 蓝锐黑梦 on 15/4/7.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "AppDelegate.h"
#import "LRHMHttpRequest.h"
#import "LRHMRequestInfo.h"
#import "LRHMRequestCollectionMgr.h"
#import "LRHMTableCellView.h"
#import "LRHMRequestHistoryMgr.h"

#import "LRHMCollectionUI.h"
#import "LRHMHistoryUI.h"
#import "LRHMHttpRequestUI.h"
#import "LRHMTitleBar.h"
@interface AppDelegate ()
@property IBOutlet NSView *leftHeaderView;
@property IBOutlet NSView *leftInfoView;
@property IBOutlet NSWindow *window;
@end

@implementation AppDelegate
{
    LRHMCollectionUI  *_collectionUICtrl;
    LRHMHistoryUI *_historyUICtrl;
    LRHMHttpRequestUI *_httpRequestUICtrl;
    IBOutlet NSButton  *_historyBtn;
    IBOutlet NSButton  *_colletionBtn;
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void)awakeFromNib
{
    [self addleftInfoView];
    [self addHttpRequestView];
    [self addHistoryView];
    [self addCollectionView];
    [self initTitlebar];
    [self addNotification];
    [[self historyUICtrl].view setHidden:NO];
    [[self collectionUICtrl].view setHidden:YES];
    
    [_historyBtn setImage:[NSImage imageNamed:@"History_selection"]];
    [_colletionBtn setImage:[NSImage imageNamed:@"Collection"]];
}

-(void) initTitlebar
{
    NSRect windowFrame = [NSWindow  frameRectForContentRect:[[self.window contentView] bounds] styleMask:[self.window styleMask]];
    NSRect contentBounds = [[self.window contentView] bounds];
    
    NSRect titlebarRect = NSMakeRect(0, 0, windowFrame.size.width, windowFrame.size.height - contentBounds.size.height);
    titlebarRect.origin.y = windowFrame.size.height - titlebarRect.size.height;
    
    LRHMTitleBar* titleBar = [[LRHMTitleBar alloc]initWithFrame:titlebarRect];
    [titleBar setAutoresizingMask:(NSViewWidthSizable | NSViewMinYMargin)];
    [titleBar setFillColor:[NSColor whiteColor]];
    [titleBar setBorderColor:[NSColor whiteColor]];
    [titleBar setTitleColor:[NSColor blackColor]];
    
    [[[self.window contentView] superview] addSubview:titleBar positioned:NSWindowBelow relativeTo:[[[[self.window contentView] superview] subviews] objectAtIndex:0]];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveJsonData:) name:LRHMHttpRequestResultNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:LRHMScalingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCollectionCompleted) name:LRHMAddCollectionCompletedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRequest:) name:LRHMStartSendRequestNotification object:nil];
}

- (void)startRequest:(NSNotification *)notification
{
    [[LRHMHttpRequest shareHttpRequest] sendRequest:[notification object]];
    [[LRHMRequestHistoryMgr shareHistoryMgr] addRequstInfo:[notification object]];
    [[self historyUICtrl] reloadHistoryUI];
}

- (void)addCollectionCompleted
{
    [[self collectionUICtrl] updateCollectionUI];
}

- (void)updateUI:(NSNotification *)obj
{
    LRHMScalingType type = [[obj object]intValue];
    switch (type) {
        case LRHMScalingType_collapse:
        {
            NSRect leftNewFrame = [self frameOfLeftInfoView];
            leftNewFrame.origin.x = -NSWidth(leftNewFrame);
            [[self.leftInfoView animator] setFrame:leftNewFrame];
            [[self httpRequestUICtrl].view setFrame:[self.window.contentView bounds]];
        }
            break;
        case LRHMScalingType_expand:
        {
            [[self.leftInfoView animator] setFrame:[self frameOfLeftInfoView]];
            [[[self httpRequestUICtrl].view animator] setFrame:[self frameOfHttpRequestView]];
        }
            break;
        default:
            break;
    }
}

- (void)receiveJsonData:(NSNotification *)notification
{
    NSString *jsonStr = [notification object];
    [[self httpRequestUICtrl] setReceiveJsonData:jsonStr];
}

#pragma mark leftViewFrame
- (NSRect)frameOfLeftInfoView
{
    NSRect rect = [self.window.contentView bounds];
    
    return NSMakeRect(0, 0, 2*NSWidth(rect)/7, NSHeight(rect));
}

- (NSRect)frameOfLeftItemView
{
    NSRect rect = [self frameOfLeftInfoView];
    rect.size.height = NSHeight(rect) - NSHeight(self.leftHeaderView.frame);
    return rect;
}

- (NSRect)frameOfHttpRequestView
{
    NSRect rect = [self frameOfLeftInfoView];
    return NSMakeRect(NSMaxX(rect), NSMinY(rect), 5*NSWidth(rect)/2, NSHeight(rect));
}
#pragma mark button action
- (IBAction)changedLeftItemView:(id)sender
{
    if ([[sender identifier] isEqualToString:@"history"]) {
        [[self historyUICtrl].view setHidden:NO];
        [[self collectionUICtrl].view setHidden:YES];
        
        [sender setImage:[NSImage imageNamed:@"History_selection"]];
        [_colletionBtn setImage:[NSImage imageNamed:@"Collection"]];
    }
    
    if ([[sender identifier] isEqualToString:@"collection"]) {
        [[self historyUICtrl].view setHidden:YES];
        [[self collectionUICtrl].view setHidden:NO];
        [sender setImage:[NSImage imageNamed:@"Collection_selection"]];
        [_historyBtn setImage:[NSImage imageNamed:@"history"]];
    }
    
//    if ([sender selectedSegment] == 0) {
//        [[self historyUICtrl].view setHidden:NO];
//        [[self collectionUICtrl].view setHidden:YES];
//    }
    
//    if ([sender selectedSegment] == 1) {
//        [[self historyUICtrl].view setHidden:YES];
//        [[self collectionUICtrl].view setHidden:NO];
//    }
}

#pragma mark item UI
- (LRHMHistoryUI *)historyUICtrl
{
    if (!_historyUICtrl) {
        _historyUICtrl = [[LRHMHistoryUI alloc] initWithNibName:@"LRHMHistoryUI" bundle:nil];
    }
    return _historyUICtrl;
}

- (LRHMCollectionUI *)collectionUICtrl
{
    if (!_collectionUICtrl) {
        _collectionUICtrl = [[LRHMCollectionUI alloc] initWithNibName:@"LRHMCollectionUI" bundle:nil];
    }
    return _collectionUICtrl;
}

- (LRHMHttpRequestUI *)httpRequestUICtrl
{
    if (!_httpRequestUICtrl) {
        _httpRequestUICtrl = [[LRHMHttpRequestUI alloc] initWithNibName:@"LRHMHttpRequestUI" bundle:nil];
    }
    return _httpRequestUICtrl;
}

#pragma mark add item view
- (void)addleftInfoView
{
    NSRect infoFrame = [self frameOfLeftInfoView];
    [self.leftInfoView setFrame:infoFrame];
    [self.window.contentView addSubview:self.leftInfoView];
}

- (void)addHistoryView
{
    LRHMHistoryUI *historyUI = [self historyUICtrl];
    NSRect historyViewFrame = [self frameOfLeftItemView];
    [historyUI.view setFrame:historyViewFrame];
    [self.leftInfoView addSubview:historyUI.view];
}

- (void)addCollectionView
{
    LRHMCollectionUI *collectionUI = [self collectionUICtrl];
    NSRect collectionViewFrame = [self frameOfLeftItemView];
    [collectionUI.view setFrame:collectionViewFrame];
    [self.leftInfoView addSubview:collectionUI.view];
}

- (void)addHttpRequestView
{
    LRHMHttpRequestUI *httpRequestUI = [self httpRequestUICtrl];
    NSRect httpRequestViewFrame = [self frameOfHttpRequestView];
    [httpRequestUI.view setFrame:httpRequestViewFrame];
    [self.window.contentView addSubview:httpRequestUI.view];
}
@end

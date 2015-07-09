//
//  LRHMDictionaryFieldCtrl.m
//  testss
//
//  Created by tangj on 15/4/3.
//  Copyright (c) 2015年 tangj. All rights reserved.
//

#import "LRHMDictionaryFieldView.h"
#import "LRHMDictionaryField.h"
#define _default_horizontal_space_   5
#define _default_vertical_space_ 2

typedef enum{
    LRHMDictionaryFieldActionType_add,
    LRHMDictionaryFieldActionType_remove,
}LRHMDictionaryFieldActionType;

@interface LRHMDictionaryFieldView ()
{
    NSScrollView  *_scrollView;
}
@property (assign) CGFloat verticalSpace;
@property (assign) CGFloat horizontalSpace;
@end

@implementation LRHMDictionaryFieldView
@synthesize fieldStringInfo;
- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [[NSColor colorWithDeviceRed:96.0/255 green:92.0/255 blue:93.0/255 alpha:1.0f] set];
    NSRectFill(self.bounds);
}

- (void)awakeFromNib
{
//     [self addScrollView];
    [self setFieldViewBaseData];
    [self setDefaultFieldItem];
   
}

- (void)setDefaultFieldItem
{
    [self ensureCreateFieldMgr];
    if ([_dictionaryFieldMgr count] == 0) {
        NSRect newFrame = [self frameOfnewDicFieldItemByOriginItem:nil];
        LRHMDictionaryField *field = [self createDictionaryField];
        [field.view setFrame:newFrame];
        [self addSubview:field.view];
        
        [self insertFieldItemToMgr:field withPreItem:nil];
    }
}

-(void)addScrollView
{
    if (!_scrollView) {
        _scrollView = [[NSScrollView alloc] initWithFrame:self.frame];
        [_scrollView setAutoresizingMask:[self autoresizingMask]];
        NSView *superView = [self superview];
        [superView addSubview:_scrollView];
        [self removeFromSuperview];
        [_scrollView setDocumentView:self];
//        [self setFrame:NSMakeRect(0, 0, NSWidth(self.frame), NSHeight(self.frame))];
        [self setAutoresizingMask:NSViewWidthSizable];
        [_scrollView setAutohidesScrollers:YES];
        [_scrollView setHasVerticalScroller:YES];
        [_scrollView setHasHorizontalScroller:NO];
        
      //  [[_scrollView contentView] setDrawsBackground:YES];
//        [[_scrollView contentView] setBackgroundColor:[NSColor colorWithDeviceRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1.0f]];
    }
}

- (void)setFieldViewBaseData
{
    self.verticalSpace = _default_vertical_space_;
    self.horizontalSpace = _default_horizontal_space_;
}

- (void)ensureCreateFieldMgr
{
    if (!_dictionaryFieldMgr) {
        _dictionaryFieldMgr = [[NSMutableArray alloc] init];
    }
}

- (void)updateFieldViewFrame
{
    NSSize originSize = self.frame.size;
    NSSize filedSize = ((LRHMDictionaryField *)[_dictionaryFieldMgr objectAtIndex:0]).view.frame.size;
    
    NSSize frameSize = NSZeroSize;
    frameSize.width = filedSize.width + 2*self.horizontalSpace;
    frameSize.height = [_dictionaryFieldMgr count]*filedSize.height +([_dictionaryFieldMgr count]+1)*self.verticalSpace;
    
    if (frameSize.height < [_scrollView contentSize].height) {
        frameSize = originSize;
    }
    [[self animator]setFrameSize:frameSize];
}

- (LRHMDictionaryField *)createDictionaryField
{
    LRHMDictionaryField *field = [[LRHMDictionaryField alloc] initWithNibName:@"LRHMDictionaryField" bundle:nil];
    [field setIdentify:[NSString stringWithFormat:@"%ld",random()]];
    [field setDelegate:self];
    return field;
}

#pragma mark LRHMDictionaryField delegate
- (void)removeDictionaryFieldItem:(LRHMDictionaryField *)fieldItem
{
//    NSRect currentFrame = fieldItem.view.frame;
    if ([_dictionaryFieldMgr count] > 1) {
        [[fieldItem.view animator] removeFromSuperview];
        
        [self updateFieldItemsFrameBy:fieldItem withActionType:LRHMDictionaryFieldActionType_remove];
        [self removeDicFieldItemWith:fieldItem.identify];
    }
//    [self updateFieldViewFrame];
}

- (void)addDictionaryFieldItem:(LRHMDictionaryField *)fieldItem
{
    NSRect currentFrame = fieldItem.view.frame;
    
    LRHMDictionaryField *newField = [self createDictionaryField];
    [newField.view setFrame:currentFrame];
    [self addSubview:newField.view];
    
    NSRect newFrame = [self frameOfnewDicFieldItemByOriginItem:fieldItem];
    [[newField.view animator] setFrame:newFrame];
    
    [self insertFieldItemToMgr:newField withPreItem:fieldItem];
    [self updateFieldItemsFrameBy:fieldItem withActionType:LRHMDictionaryFieldActionType_add];
//    [self updateFieldViewFrame];
}

#pragma mark update itemFieldFrame
- (void)updateFieldItemsFrameBy:(LRHMDictionaryField *)fieldItem withActionType:(LRHMDictionaryFieldActionType)type
{
    switch (type) {
        case LRHMDictionaryFieldActionType_add:
        {
            [self updateFieldItemsFrameByAddItem:fieldItem];
        }
            break;
        case LRHMDictionaryFieldActionType_remove:
        {
            [self updateFieldItemsFrameByRemoveItem:fieldItem];
        }
            break;
        default:
            break;
    }
}

- (void)updateFieldItemsFrameByAddItem:(LRHMDictionaryField *)fieldItem
{
    NSInteger currentIndex = [_dictionaryFieldMgr indexOfObject:fieldItem];
    for (NSInteger index = currentIndex+1;index < [_dictionaryFieldMgr count];index++) {
        LRHMDictionaryField *item = [_dictionaryFieldMgr objectAtIndex:index];
        NSRect itemFrame = item.view.frame;
        itemFrame.origin.y = NSMinY(itemFrame) - NSHeight(itemFrame) - self.verticalSpace;
        [[item.view animator] setFrame:itemFrame];
    }
}

- (void)updateFieldItemsFrameByRemoveItem:(LRHMDictionaryField *)fieldItem
{
    NSInteger currentIndex = [_dictionaryFieldMgr indexOfObject:fieldItem];
    for (NSInteger index = currentIndex+1;index < [_dictionaryFieldMgr count];index++ ) {
        LRHMDictionaryField *item = [_dictionaryFieldMgr objectAtIndex:index];
        NSRect itemFrame = item.view.frame;
        itemFrame.origin.y = NSMinY(itemFrame) + NSHeight(itemFrame) + self.verticalSpace;
        [[item.view animator] setFrame:itemFrame];
    }
}

#pragma mark manager fieldItem
- (void)insertFieldItemToMgr:(LRHMDictionaryField *)item withPreItem:(LRHMDictionaryField *)preItem
{
     [self ensureCreateFieldMgr];
    if (item && preItem) {
        NSInteger index = [_dictionaryFieldMgr indexOfObject:preItem];
        NSString *identify = [self checkIdentify:item.identify];
        [item setIdentify:identify];
        [_dictionaryFieldMgr insertObject:item atIndex:index+1];
        [item release];
    }
    
    if (!preItem) {
        NSString *identify = [self checkIdentify:item.identify];
        [item setIdentify:identify];
        [_dictionaryFieldMgr addObject:item];
        [item release];

    }
}

- (NSString *)checkIdentify:(NSString *)identify
{
    if (!identify) {
        identify = [NSString stringWithFormat:@"%ld",random()];
    }
   
    for (LRHMDictionaryField *field in _dictionaryFieldMgr) {
        if ([field.identify isEqualToString:identify]) {
            identify = [self checkIdentify:[NSString stringWithFormat:@"%ld",random()]];
        }
    }
    return identify;
}

#pragma mark base Frame
- (NSRect)frameOfLastFieldItem
{
    NSInteger itemsCount = [_dictionaryFieldMgr count];
    if (itemsCount == 0) {
        NSRect frame = NSZeroRect;
        LRHMDictionaryField *field = [self createDictionaryField];
        frame.size = field.view.frame.size;
        frame.origin.y = NSHeight(self.frame);
        [field release];
        return frame;
    }
    return [((LRHMDictionaryField *)[_dictionaryFieldMgr objectAtIndex:itemsCount-1]).view frame];
}

- (NSRect)frameOfnewDicFieldItemByOriginItem:(LRHMDictionaryField *)fieldItem
{
    NSRect preItemFrame = NSZeroRect;
    if (fieldItem) {
        preItemFrame = fieldItem.view.frame;
    }else{
        preItemFrame = [self frameOfLastFieldItem];
    }
    
    NSRect newFrame = preItemFrame;
    newFrame.origin.x = self.horizontalSpace;
    newFrame.origin.y = NSMinY(preItemFrame) - self.verticalSpace - NSHeight(preItemFrame);
    return newFrame;
}

#pragma mark --
- (void)removeDicFieldItemWith:(NSString *)identify
{
        for (LRHMDictionaryField *dicField in _dictionaryFieldMgr) {
            if ([dicField.identify isEqualToString:identify]) {
                [_dictionaryFieldMgr removeObject:dicField];
                return;
            }
        }
}

#pragma mark fieldView String Info
- (NSString *)fieldStringInfo
{
    NSString *dicStr = nil;
    for (LRHMDictionaryField *fielditem in _dictionaryFieldMgr) {
       NSString * itemDicStr = [NSString stringWithFormat:@"%@=%@",fielditem.keyStr,fielditem.valueStr];
        if (([_dictionaryFieldMgr count]-1) != ([_dictionaryFieldMgr indexOfObject:fielditem])) {
            dicStr = [itemDicStr stringByAppendingString:@"&"];
        }
    }
    return dicStr;
}

- (NSArray *)dictionaryValues
{
    NSMutableArray * dictionaryArr = [[[NSMutableArray alloc] init] autorelease];
    for (LRHMDictionaryField *item in _dictionaryFieldMgr) {
        if (item.valueStr && item.keyStr) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:item.valueStr forKey:item.keyStr];
            [dictionaryArr addObject:dic];
        }
    }
    return dictionaryArr;
}

- (void)updateFiledViewBy:(NSArray *)datas
{
    if ([datas count] > [_dictionaryFieldMgr count]) {
        for (NSInteger index = 0; index < [_dictionaryFieldMgr count]; index++) {
            LRHMDictionaryField *field = [_dictionaryFieldMgr objectAtIndex:index];
            NSDictionary *value = [datas objectAtIndex:index];
            [field setKeyStr:[[value allKeys] objectAtIndex:0]];
            [field setValueStr:[[value allValues] objectAtIndex:0]];
        }
        
        for (NSInteger index = [_dictionaryFieldMgr count];index < [datas count];index++) {
            [self addDictionaryFieldItem:[_dictionaryFieldMgr objectAtIndex:[_dictionaryFieldMgr count]-1]];
            LRHMDictionaryField *field = [_dictionaryFieldMgr objectAtIndex:[_dictionaryFieldMgr count]-1];
            
            NSDictionary *value = [datas objectAtIndex:index];
            [field setKeyStr:[[value allKeys] objectAtIndex:0]];
            [field setValueStr:[[value allValues] objectAtIndex:0]];
        }
    }else{
        for (NSInteger index = 0; index < [datas count]; index++) {
            LRHMDictionaryField *field = [_dictionaryFieldMgr objectAtIndex:index];
            NSDictionary *value = [datas objectAtIndex:index];
            [field setKeyStr:[[value allKeys] objectAtIndex:0]];
            [field setValueStr:[[value allValues] objectAtIndex:0]];
        }
        
        for (NSInteger index = [_dictionaryFieldMgr count]-1; index >= [datas count]; index--) {
            [self removeDictionaryFieldItem:[_dictionaryFieldMgr objectAtIndex:index]];
        }
    }
}
@end

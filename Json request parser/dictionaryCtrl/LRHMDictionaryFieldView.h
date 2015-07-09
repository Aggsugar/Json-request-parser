//
//  LRHMDictionaryFieldCtrl.h
//  testss
//
//  Created by tangj on 15/4/3.
//  Copyright (c) 2015年 tangj. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LRHMDictionaryField.h"
@interface LRHMDictionaryFieldView : NSView<LRHMDictionaryFieldDelegate>
{
    NSMutableArray * _dictionaryFieldMgr;
}

@property (readonly) NSString * fieldStringInfo;
@property (readonly) NSArray *dictionaryValues;

- (void)updateFiledViewBy:(NSArray *)datas;
@end

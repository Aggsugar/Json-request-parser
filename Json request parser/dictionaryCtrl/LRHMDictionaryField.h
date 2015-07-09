//
//  LRHMDictionaryField.h
//  testss
//
//  Created by tangj on 15/4/3.
//  Copyright (c) 2015年 tangj. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LRHMDictionaryField;
@protocol LRHMDictionaryFieldDelegate<NSObject>
- (void)removeDictionaryFieldItem:(LRHMDictionaryField *)fieldItem;
- (void)addDictionaryFieldItem:(LRHMDictionaryField *)fieldItem;
@end
@interface LRHMDictionaryField : NSViewController
@property (readwrite,copy)  NSString *identify;
@property (assign)  BOOL isCanRemove;
@property (assign) id<LRHMDictionaryFieldDelegate>delegate;

@property (readwrite,copy) NSString * keyStr;
@property (readwrite,copy) NSString * valueStr;
@end

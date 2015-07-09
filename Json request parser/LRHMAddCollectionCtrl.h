//
//  LRHMAddCollectionCtrl.h
//  Json request parser
//
//  Created by 蓝锐黑梦 on 15/4/21.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LRHMViewController.h"
@protocol LRHMAddCollectionCtrlDelegate<NSObject>
- (void)addToCollection:(NSString *)collectionName withRequestName:(NSString *)requestName;
@end
@interface LRHMAddCollectionCtrl : LRHMViewController
@property (assign) id<LRHMAddCollectionCtrlDelegate>delegate;

- (void)popupAddCollectionView;
@end

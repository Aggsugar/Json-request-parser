//
//  LRHMEditCollectionUI.h
//  Json request parser
//
//  Created by tangj on 15/5/4.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMViewController.h"
@class LRHMEditCollectionUI;
@protocol LRHMEditCollectionUIDelegate<NSObject>
- (void)editCollectionUI:(LRHMEditCollectionUI *)collectionUI withName:(NSString *)name;
@end
@interface LRHMEditCollectionUI : LRHMViewController
- (void)popupEditCollectionView;
@property (readwrite,copy) NSString *viewTitle;
@property (readwrite,copy) NSString *returnName;
@property (readwrite,copy) NSString *oldName;
@property (assign) id<LRHMEditCollectionUIDelegate>delegate;
@end

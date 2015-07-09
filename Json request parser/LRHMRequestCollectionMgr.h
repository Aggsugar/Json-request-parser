//
//  LRHMRequestCollectionMgr.h
//  Json request parser
//
//  Created by tangj on 15/4/10.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const  kLRHMRequestCollectionMgr;
@class LRHMRequestInfo;
@interface LRHMRequestCollectionMgr : NSObject//<NSCoding>

+ (LRHMRequestCollectionMgr *)shareCollectionMgr;
/**
 add collection
 **/
- (void)createCollectionBy:(NSString *)name;

/**
 remove collection
 **/

- (BOOL)removeCollectionBy:(NSString *)collectionName;

/**
 add requstInfo
 **/
- (void)addRequestInfo:(LRHMRequestInfo *)requestInfo toCollection:(NSString *)collectionName;

/**
 get requestInfo
 **/
- (NSString *)requestMethodAt:(NSInteger)index inCollection:(NSString *)collectionName;
- (NSString *)requestDescriptionAt:(NSInteger)index inCollection:(NSString *)collectionName;

- (NSString *)requestMethodOf:(id)requestInfo;
- (NSString *)requestDescriptionOf:(id)requestInfo;

/**
 edit requestInfo
 **/
- (void)editCollection:(NSString *)oldCollectionName withNewCollectionName:(NSString *)theNewCollectionName;
- (void)editCollection:(NSString *)collectionName AtItem:(NSString *)identify withNewRequestName:(NSString *)theNewRequestName;
/**
 remove requestInfo
 **/
- (BOOL)removeRequestInfoAt:(NSInteger)index inCollection:(NSString *)collectionName;
- (BOOL)removeRequestInfoBy:(NSString *)identify inCollection:(NSString *)collectionName;


- (NSArray *)collectItemsBy:(NSString *)item;
- (NSArray *)parentCollections;
- (NSString *)parentNameOfItem:(LRHMRequestInfo *)requestInfo;
@end

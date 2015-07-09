//
//  LRHMRequestCollectionMgr.m
//  Json request parser
//
//  Created by tangj on 15/4/10.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMRequestCollectionMgr.h"
#import "LRHMRequestInfo.h"

NSString *const  kLRHMRequestCollectionMgr = @"LRHMRequestCollectionMgr";
@implementation LRHMRequestCollectionMgr
{
    NSMutableDictionary   *_requestCollections;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self unarchiverCollections];
    }
    return self;
}
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super init];
//    if (self) {
//        _requestCollections = [[aDecoder decodeObjectForKey:kLRHMRequestCollectionMgr] retain];
//    }
//    return self;   
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:_requestCollections forKey:kLRHMRequestCollectionMgr];
//}

- (void)ensureCreateRequestCollections
{
    if (!_requestCollections) {
        _requestCollections = [[NSMutableDictionary alloc] init];
    }
}

+ (LRHMRequestCollectionMgr *)shareCollectionMgr
{
    static LRHMRequestCollectionMgr *shareCollction = nil;
    static dispatch_once_t oncToken = 0;
    dispatch_once(&oncToken, ^{
        shareCollction = [[LRHMRequestCollectionMgr alloc] init];
    });
    return shareCollction;
}

#pragma mark create collection
- (void)createCollectionBy:(NSString *)name
{
    if (name) {
        [self ensureCreateRequestCollections];
        [_requestCollections setValue:[NSArray array] forKey:name];
    }
}

#pragma mark remove collection
- (BOOL)removeCollectionBy:(NSString *)collectionName
{
    if (collectionName && _requestCollections) {
        [_requestCollections removeObjectForKey:collectionName];
        return YES;
    }
    return NO;
}

#pragma add requestInfo
- (void)addRequestInfo:(LRHMRequestInfo *)requestInfo toCollection:(NSString *)collectionName
{
    if (requestInfo && collectionName) {
        [self ensureCreateRequestCollections];
        NSArray *requestInfos = [_requestCollections objectForKey:collectionName];
        NSMutableArray *temp = [NSMutableArray arrayWithArray:requestInfos];
        [requestInfo setIdentify:[self requestItemIdentify]];
        [temp addObject:requestInfo];
        [_requestCollections setObject:temp forKey:collectionName];
    }
    [self archiverCollections];

}

- (NSString *)requestItemIdentify
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    return strDate;
}

- (void)archiverCollections
{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_requestCollections];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"restoreCollections"];
}

- (void)unarchiverCollections{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"restoreCollections"];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"restoreCollections"];
    _requestCollections = [[NSKeyedUnarchiver unarchiveObjectWithData:data] retain];
}

#pragma mark get requestInfo
- (NSString *)requestMethodAt:(NSInteger)index inCollection:(NSString *)collectionName
{
    if (collectionName) {
        NSArray *requsetInfos = [_requestCollections objectForKey:collectionName];
        if (requsetInfos && (index >= 0) && (index < [requsetInfos count])) {
            LRHMRequestInfo *itemInfo = [requsetInfos objectAtIndex:index];
            return itemInfo.requestMethod;
        }
    }
    return nil;
}

- (NSString *)requestDescriptionAt:(NSInteger)index inCollection:(NSString *)collectionName
{
    if (collectionName) {
        NSArray *requsetInfos = [_requestCollections objectForKey:collectionName];
        if (requsetInfos && (index >= 0) && (index < [requsetInfos count])) {
            LRHMRequestInfo *itemInfo = [requsetInfos objectAtIndex:index];
            return itemInfo.requestHttpPath;
        }
    }
    return nil;
}

- (NSString *)requestMethodOf:(id)requestInfo
{
    if (requestInfo && [requestInfo isKindOfClass:[LRHMRequestInfo class]]) {
        return ((LRHMRequestInfo *)requestInfo).requestMethod;
    }
    return nil;
}

- (NSString *)requestDescriptionOf:(id)requestInfo
{
    if (requestInfo && [requestInfo isKindOfClass:[LRHMRequestInfo class]]) {
        if (((LRHMRequestInfo *)requestInfo).requestName && ![((LRHMRequestInfo *)requestInfo).requestName isEqualToString:@""]) {
            return ((LRHMRequestInfo *)requestInfo).requestName;
        }else{
            return ((LRHMRequestInfo *)requestInfo).requestHttpPath;
        }
    }
    return nil;
}

#pragma mark remove requestInfo
- (BOOL)removeRequestInfoAt:(NSInteger)index inCollection:(NSString *)collectionName
{
    BOOL sucees = NO;
    if (index < 0 && collectionName) {
        [_requestCollections removeObjectForKey:collectionName];
        sucees = YES;
    }
    if (collectionName) {
        NSArray *requsetInfos = [_requestCollections objectForKey:collectionName];
        if (requsetInfos && (index >= 0) && (index < [requsetInfos count])) {
            NSMutableArray *temp = [NSMutableArray arrayWithArray:requsetInfos];
            [temp removeObjectAtIndex:index];
            [_requestCollections setObject:temp forKey:collectionName];
            
            sucees = YES;
        }
    }
    [self archiverCollections];
    return sucees;
}

- (BOOL)removeRequestInfoBy:(NSString *)identify inCollection:(NSString *)collectionName
{
    BOOL sucees = NO;
    if (!identify && collectionName) {
        [_requestCollections removeObjectForKey:collectionName];
        sucees = YES;
    }
    if (collectionName && identify) {
        NSArray *requsetInfos = [_requestCollections objectForKey:collectionName];
        for (LRHMRequestInfo * info in requsetInfos) {
            if ([info.identify isEqualToString:identify]) {
                NSMutableArray *temp = [NSMutableArray arrayWithArray:requsetInfos];
                [temp removeObject:info];
                [_requestCollections setObject:temp forKey:collectionName];
                sucees = YES;
                break;
            }
        }
    }
    [self archiverCollections];
    return sucees;
}

#pragma mark edit collection
- (void)editCollection:(NSString *)oldCollectionName withNewCollectionName:(NSString *)theNewCollectionName
{
    if ((oldCollectionName && theNewCollectionName) && (![oldCollectionName isEqualToString:theNewCollectionName])) {
        NSArray *requestInfos = [_requestCollections objectForKey:oldCollectionName];
        [_requestCollections setObject:requestInfos forKey:theNewCollectionName];
        [_requestCollections removeObjectForKey:oldCollectionName];
    }
}
- (void)editCollection:(NSString *)collectionName AtItem:(NSString *)identify withNewRequestName:(NSString *)theNewRequestName
{
    if ( collectionName && identify && theNewRequestName) {
        NSArray *requsetInfos = [_requestCollections objectForKey:collectionName];
        for (LRHMRequestInfo * info in requsetInfos) {
            if ([info.identify isEqualToString:identify]) {
                info.requestName = theNewRequestName;
            }
        }
    }
}

- (NSArray *)collectItemsBy:(NSString *)item
{
    if (!item) {
        return [_requestCollections allKeys];
    }else{
        return [_requestCollections objectForKey:item];
    }
}

- (NSArray *)parentCollections
{
    return [self collectItemsBy:nil];
}

- (NSString *)parentNameOfItem:(LRHMRequestInfo *)requestInfo
{
    NSArray *parentNames = [self parentCollections];
    for (NSString *parentName in parentNames) {
        NSArray *childs = [self collectItemsBy:parentName];
        for (LRHMRequestInfo *info in childs) {
            if (info == requestInfo) {
                return parentName;
            }
        }
    }
    return nil;
}
@end

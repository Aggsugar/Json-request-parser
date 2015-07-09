//
//  LRHMRequestMgr.m
//  Json request parser
//
//  Created by tangj on 15/4/9.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMRequestHistoryMgr.h"
#import "LRHMRequestInfo.h"
NSString *const kRequestHistory = @"kRequestHistory";
@implementation LRHMRequestHistoryMgr
{
    NSMutableArray  *_requestHistorys;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self unarchiverHistorys];
    }
    return self;
}

+ (LRHMRequestHistoryMgr *)shareHistoryMgr
{
    static LRHMRequestHistoryMgr *historyMgr = nil;
    static dispatch_once_t oncToken = 0;
    dispatch_once(&oncToken, ^{
        historyMgr = [[LRHMRequestHistoryMgr alloc] init];
    });
    return historyMgr;
}

- (void)ensureCreateRequestHistorys
{
    if (!_requestHistorys) {
        _requestHistorys = [[NSMutableArray alloc] init];
    }
}

- (void)addRequstInfo:(LRHMRequestInfo *)requestInfo
{
    if (requestInfo) {
        [self ensureCreateRequestHistorys];
        [_requestHistorys addObject:requestInfo];
        [self archiverHistorys];
    }
}

- (NSString *)requestMethodAtHistory:(NSInteger)index
{
    LRHMRequestInfo *requestInfo = [self requestInfoAt:index];
    if (requestInfo) {
        return requestInfo.requestMethod;
    }
    return nil;
}
- (NSString *)requestDescriptionAtHistory:(NSInteger)index
{
    LRHMRequestInfo *requestInfo = [self requestInfoAt:index];
    if (requestInfo) {
        return requestInfo.requestHttpPath;
    }
    return nil;
}

- (void)removeHistoryAt:(NSInteger)index
{
    if ((index >= 0) && (index < [self historysCount])) {
        [_requestHistorys removeObjectAtIndex:index];
        [self archiverHistorys];
    }
}


- (LRHMRequestInfo *)requestInfoAt:(NSInteger)index
{
    if ((index >= 0) && (index < [_requestHistorys count])) {
        return [_requestHistorys objectAtIndex:index];
    }
    return nil;
}

- (NSInteger)historysCount{
    return [_requestHistorys count];
}

#pragma mark archiver Or Unarchiver
- (void)archiverHistorys
{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_requestHistorys];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kRequestHistory];
}

- (void)unarchiverHistorys{
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRequestHistory];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kRequestHistory];
    if (data) {
         _requestHistorys = [[NSKeyedUnarchiver unarchiveObjectWithData:data] retain];
    }
   
}
@end

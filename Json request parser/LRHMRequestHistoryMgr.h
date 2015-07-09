//
//  LRHMRequestMgr.h
//  Json request parser
//
//  Created by aggsugar on 15/4/9.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LRHMRequestInfo;
@interface LRHMRequestHistoryMgr : NSObject
{
    
}
+ (LRHMRequestHistoryMgr *)shareHistoryMgr;

- (void)addRequstInfo:(LRHMRequestInfo *)requestInfo;
- (NSInteger)historysCount;

- (NSString *)requestMethodAtHistory:(NSInteger)index;
- (NSString *)requestDescriptionAtHistory:(NSInteger)index;
- (void)removeHistoryAt:(NSInteger)index;

- (LRHMRequestInfo *)requestInfoAt:(NSInteger)index;
@end

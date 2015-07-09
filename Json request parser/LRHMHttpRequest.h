//
//  LRHMHttpRequest.h
//  Json request parser
//
//  Created by 蓝锐黑梦 on 15/4/7.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const LRHMHttpRequestResultNotification;
@class LRHMRequestInfo;
@interface LRHMHttpRequest : NSObject
{
}

@property (copy) NSString * requestMethod;
@property (copy) NSString * requestHttpPath;
@property (copy) NSString * requestData;

@property (assign) BOOL isFile;

+ (LRHMHttpRequest *)shareHttpRequest;
- (void)sendRequest:(LRHMRequestInfo *)requestInfo;
@end



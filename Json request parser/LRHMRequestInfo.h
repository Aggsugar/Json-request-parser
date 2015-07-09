//
//  LRHMRequestInfo.h
//  Json request parser
//
//  Created by aggsugar on 15/4/9.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRHMHttpKeyValueInfo : NSObject<NSCoding>
@property (readwrite,copy)  NSString *infoValue;
@property (readwrite,copy)  NSString *infoKey;
@end


@interface LRHMRequestInfo : NSObject<NSCoding>
{
    
}
@property (readwrite,copy) NSString *identify;
@property (copy) NSString * requestMethod;
@property (readonly) NSString * requestParamStr;;
@property (readonly) NSArray * requestParams;
@property (readonly) NSArray  * requestHeaders;
@property (copy) NSString * requestHttpPath;
@property (readonly) NSArray *requestFormUrlencodeds;
@property (readwrite,copy) NSString *requestRawBody;

@property (readonly) NSString *requestBody;
@property (copy) NSString *requestName;
@property (copy) NSString *requestDescription;
//@property (copy) NSString *requestData

- (void)addRequestHeadersWithValue:(NSString *)value withKey:(NSString *)key;
- (void)addRequestParamsWithValue:(NSString *)value withKey:(NSString *)key;
- (void)addRequestFormUrlencodeds:(NSString *)value withKey:(NSString *)key;

- (NSArray *)requestParamDics;
- (NSArray *)requestHeaderDics;
- (id)requestBodys;
@end

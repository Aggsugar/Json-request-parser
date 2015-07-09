//
//  LRHMRequestInfo.m
//  Json request parser
//
//  Created by tangj on 15/4/9.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMRequestInfo.h"

NSString *const kRequestMethod = @"requestMethod";
NSString *const kRequestHeaders = @"requestHeaders";
NSString *const kRequestHttpPath = @"requestHttpPath";
NSString *const kRequestParams = @"requestParams";
NSString *const kRequestName = @"requestName";
NSString *const kRequestDes = @"requestDescription";
NSString *const kRequestIdentify = @"requestIdentify";
NSString *const kRequestBody = @"requestBody";
NSString *const kRequestFormUrlencodeds = @"requestFormUrlencodeds";

NSString *const kHttpInfoKeyIdentify = @"httpInfoKeyIdentify";
NSString *const kHttpInfoValueIdentify = @"httpInfoValueIdentify";

@implementation LRHMHttpKeyValueInfo
@synthesize infoValue;
@synthesize infoKey;

- (id)initWithHeaderValue:(NSString *)value withHeaderKey:(NSString *)key
{
    self = [super init];
    if (self) {
        self.infoKey = key;
        self.infoValue = value;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    self.infoKey = nil;
    self.infoValue = nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.infoKey = [[aDecoder decodeObjectForKey:kHttpInfoKeyIdentify] retain];
        self.infoValue = [[aDecoder decodeObjectForKey:kHttpInfoValueIdentify] retain];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.infoValue forKey:kHttpInfoValueIdentify];
    [aCoder encodeObject:self.infoKey forKey:kHttpInfoKeyIdentify];
}
@end


@implementation LRHMRequestInfo
{
    NSMutableArray *_requestHeaders;
    NSMutableArray * _requstParams;
    NSMutableArray *_requestFormUrlencodeds;
}
@synthesize identify;
@synthesize requestParamStr;
@synthesize requestParams = _requstParams;
@synthesize requestHeaders = _requestHeaders;
@synthesize requestMethod;
@synthesize requestHttpPath;
@synthesize requestRawBody;
@synthesize requestBody;
@synthesize requestDescription;
@synthesize requestName;

- (id)init
{
    self = [super init];
    if (self) {
//        [self ensureCreateHeaders];
    }
    return self;
}
- (void)ensureCreateParams
{
    if (!_requstParams) {
        _requstParams = [[NSMutableArray alloc] init];
    }
}

- (void)ensureCreateFormUrlencodeds
{
    if (!_requestFormUrlencodeds) {
        _requestFormUrlencodeds = [[NSMutableArray alloc] init];
    }
}

- (void)addRequestParamsWithValue:(NSString *)value withKey:(NSString *)key
{
    if (value && key) {
        [self ensureCreateParams];
        LRHMHttpKeyValueInfo *params = [[LRHMHttpKeyValueInfo alloc] initWithHeaderValue:value withHeaderKey:key];
        [_requstParams addObject:params];
        [params release];
    }
}

- (void)addRequestFormUrlencodeds:(NSString *)value withKey:(NSString *)key
{
    if (value && key) {
        [self ensureCreateFormUrlencodeds];
        LRHMHttpKeyValueInfo *params = [[LRHMHttpKeyValueInfo alloc] initWithHeaderValue:value withHeaderKey:key];
        [_requestFormUrlencodeds addObject:params];
        [params release];
    }
}

- (void)ensureCreateHeaders
{
    if (!_requestHeaders) {
        _requestHeaders = [[NSMutableArray alloc] init];
//        [self addDefaultHeaders];
    }
}

- (void)addDefaultHeaders
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json",@"Content-Type",@"application/json",@"Accept", nil];
    for (NSString *key in dic.allKeys) {
        LRHMHttpKeyValueInfo *header = [[LRHMHttpKeyValueInfo alloc] initWithHeaderValue:[dic objectForKey:key] withHeaderKey:key];
        [_requestHeaders addObject:header];
        [header release];
    }
}

- (void)addRequestHeadersWithValue:(NSString *)value withKey:(NSString *)key
{
    if (value && key) {
        [self ensureCreateHeaders];
        LRHMHttpKeyValueInfo *header = [[LRHMHttpKeyValueInfo alloc] initWithHeaderValue:value withHeaderKey:key];
        [_requestHeaders addObject:header];
        [header release];
    }
}

- (NSArray *)requestHeaders
{
    return _requestHeaders;
}

- (NSArray *)requestParams
{
    return _requstParams;
}

- (NSArray *)requestParamDics
{
    NSMutableArray *params = [[[NSMutableArray alloc] init] autorelease];
    for (LRHMHttpKeyValueInfo * keyValue in _requstParams) {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:keyValue.infoValue forKey:keyValue.infoKey];
        [params addObject:dic];
    }
    return params;
}

- (NSArray *)requestHeaderDics
{
    NSMutableArray *headers = [[[NSMutableArray alloc] init] autorelease];
    for (LRHMHttpKeyValueInfo * keyValue in _requestHeaders) {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:keyValue.infoValue forKey:keyValue.infoKey];
        [headers addObject:dic];
    }
    return headers;
}

- (NSArray *)requestFormUrlencodedDics
{
    NSMutableArray *headers = [[[NSMutableArray alloc] init] autorelease];
    for (LRHMHttpKeyValueInfo * keyValue in _requestFormUrlencodeds) {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:keyValue.infoValue forKey:keyValue.infoKey];
        [headers addObject:dic];
    }
    return headers;
}

- (id)requestBodys
{
    if (self.requestRawBody) {
        return self.requestRawBody;
    }else{
        return [self requestFormUrlencodedDics];
    }
}

- (NSString *)requestBody
{
    if (self.requestRawBody) {
        return self.requestRawBody;
    }else{
        NSString *paramStr = [NSString string];
        for (LRHMHttpKeyValueInfo *info in self.requestFormUrlencodeds) {
            NSString *str = [NSString stringWithFormat:@"%@=%@&",info.infoKey,info.infoValue];
            paramStr = [paramStr stringByAppendingString:str];
        }
        
        if ([paramStr length] > 0) {
            paramStr = [paramStr substringToIndex:[paramStr length]-1];
        }
        
        return paramStr;
    }
}

- (NSString *)requestParamStr
{
    NSString *paramStr = [NSString string];
    for (LRHMHttpKeyValueInfo *info in self.requestParams) {
        NSString *str = [NSString stringWithFormat:@"%@=%@&",info.infoKey,info.infoValue];
        paramStr = [paramStr stringByAppendingString:str];
    }
    
    if ([paramStr length] > 0) {
        paramStr = [paramStr substringToIndex:[paramStr length]-1];
    }
  
    return paramStr;
}


#pragma mark code protocol
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.requestMethod = [aDecoder decodeObjectForKey:kRequestMethod];
        self.requestHttpPath = [aDecoder decodeObjectForKey:kRequestHttpPath];
        _requestHeaders = [[aDecoder decodeObjectForKey:kRequestHeaders] retain];
        _requstParams = [[aDecoder decodeObjectForKey:kRequestParams] retain];
        self.requestName = [[aDecoder decodeObjectForKey:kRequestName] retain];
        self.requestDescription = [[aDecoder decodeObjectForKey:kRequestDes] retain];
        self.identify = [[aDecoder decodeObjectForKey:kRequestIdentify] retain];
        self.requestRawBody = [[aDecoder decodeObjectForKey:kRequestBody] retain];
        _requestFormUrlencodeds = [[aDecoder decodeObjectForKey:kRequestFormUrlencodeds] retain];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.requestHeaders forKey:kRequestHeaders];
    [aCoder encodeObject:self.requestHttpPath forKey:kRequestHttpPath];
    [aCoder encodeObject:self.requestMethod forKey:kRequestMethod];
    [aCoder encodeObject:self.requestParams forKey:kRequestParams];
    [aCoder encodeObject:self.requestName forKey:kRequestName];
    [aCoder encodeObject:self.requestDescription forKey:kRequestDes];
    [aCoder encodeObject:self.identify forKey:kRequestIdentify];
    [aCoder encodeObject:self.requestRawBody forKey:kRequestBody];
    [aCoder encodeObject:_requestFormUrlencodeds forKey:kRequestFormUrlencodeds];
}
@end

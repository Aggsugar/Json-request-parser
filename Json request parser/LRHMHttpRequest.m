//
//  LRHMHttpRequest.m
//request parser
//
//  Created by 蓝锐黑梦 on 15/4/7.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMHttpRequest.h"
#import "LRHMHttpDataParser.h"
#import "LRHMRequestInfo.h"
NSString *const LRHMHttpRequestResultNotification = @"LRHMHttpRequestResultNotification";
@interface LRHMHttpHeader : NSObject
@property (readwrite,copy)  NSString *headerValue;
@property (readwrite,copy)  NSString *headerKey;
//+ (id)initWithHeaderValue:(NSString *)value withHeaderKey:(NSString *)key;
@end

@implementation LRHMHttpHeader
@synthesize headerValue;
@synthesize headerKey;

- (id)initWithHeaderValue:(NSString *)value withHeaderKey:(NSString *)key
{
    self = [super init];
    if (self) {
        self.headerKey = key;
        self.headerValue = value;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    self.headerKey = nil;
    self.headerValue = nil;
}
@end

@interface LRHMHttpRequest()
@property (assign) NSThread * requestThread;
@property (assign) NSThread * parserDataThread;
@property (copy) id returnContent;
@property (readonly) LRHMRequestInfo *requestInfo;
@end

@implementation LRHMHttpRequest
{
    NSMutableArray *_requestHeaders;
    LRHMRequestInfo *_requestInfo;
}
@synthesize requestData;
@synthesize requestMethod;
@synthesize requestHttpPath;
@synthesize returnContent;
@synthesize requestInfo = _requestInfo;

+ (LRHMHttpRequest *)shareHttpRequest
{
    static dispatch_once_t onceToken;
    static LRHMHttpRequest *shareRequest;
    dispatch_once(&onceToken, ^{
        shareRequest = [[LRHMHttpRequest alloc] init];
    });
    return shareRequest;
}

- (void)setRequestInfo:(LRHMRequestInfo *)requestInfo
{
    if (_requestInfo) {
        [_requestInfo release];
    }
    
    _requestInfo = [requestInfo retain];
}

- (void)sendRequest:(LRHMRequestInfo *)requestInfo
{
    [self setRequestInfo:requestInfo];
    [self sendRequest];
}

- (void)ensureCreateHeaders
{
    if (!_requestHeaders) {
        _requestHeaders = [[NSMutableArray alloc] init];
    }
}
- (void)addRequestHeadersWithValue:(NSString *)value withKey:(NSString *)key
{
    if (value && key) {
        [self ensureCreateHeaders];
        LRHMHttpHeader *header = [[LRHMHttpHeader alloc] initWithHeaderValue:value withHeaderKey:key];
        [_requestHeaders addObject:header];
        [header release];
    }

}

- (LRHMRequestInfo *)requestInfo
{
    return _requestInfo;
}

#pragma mark send request
- (void)sendRequest
{
    if (self.requestThread) {
        [self.requestThread cancel];
        self.requestThread = nil;
    }
    self.requestThread = [[NSThread alloc] initWithTarget:self selector:@selector(sendRequestInBackground) object:nil];
    [self.requestThread start];
}

- (void)sendRequestInBackground
{
    @autoreleasepool {
        NSString *address = self.requestInfo.requestHttpPath;
        
        if (self.requestInfo.requestParamStr.length) {
            address = [address stringByAppendingFormat:@"?%@", self.requestInfo.requestParamStr];
        }
        
        NSURL *requestUrl = [NSURL URLWithString:address];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:requestUrl];
        
        for (LRHMHttpKeyValueInfo *headerInfo in self.requestInfo.requestHeaders) {
            [request setValue:headerInfo.infoValue forHTTPHeaderField:headerInfo.infoKey];
        }
        
        if (self.requestInfo.requestMethod && ![[self.requestInfo.requestMethod uppercaseString] isEqualToString:@"GET"]) {
            [request setHTTPMethod:self.requestInfo.requestMethod];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
            [request setHTTPBody:[self.requestInfo.requestBody dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        NSError *error = nil;
        NSData *data =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
           if (data && !error) {
               NSString *returnDataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
               self.returnContent = returnDataStr;
               [returnDataStr release];
           }else{
               self.returnContent = error;
           }
           [self performSelectorOnMainThread:@selector(requestFinished) withObject:nil waitUntilDone:NO];
    }
}

- (void)requestFinished
{
    if (!self.returnContent)  return;
    if ([self.returnContent isKindOfClass:[NSError class]]) {
//        self.returnContent = [self.returnContent description];//[NSString stringWithFormat:@"Error %@",self.returnContent];
        [self parserFinished:self.returnContent];
    }else{
        [self parserReturnData];
    }
}

- (void)parserReturnData
{
    if (self.parserDataThread) {
        [self.parserDataThread cancel];
        [self.parserDataThread release];
    }
    self.parserDataThread = [[NSThread alloc] initWithTarget:self selector:@selector(parserDataInBackground) object:nil];
    [self.parserDataThread start];
}

- (void)parserDataInBackground
{
    id parserData = [[LRHMHttpDataParser shareHttpDataParser] structuredDataFromRawDataString:self.returnContent];
    [self performSelectorOnMainThread:@selector(parserFinished:) withObject:parserData waitUntilDone:NO];
}

- (void)parserFinished:(id)parserData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LRHMHttpRequestResultNotification object:[parserData description]];
}

- (void)dealloc
{
    if (self.parserDataThread) {
        [self.parserDataThread cancel];
        [self.parserDataThread release];
    }
    
    if (self.requestThread) {
        [self.requestThread cancel];
        [self.requestThread release];
    }
    
    if (_requestHeaders) {
        [_requestHeaders release];
    }
    
    self.returnContent = nil;
    self.requestMethod = nil;
    self.requestHttpPath = nil;
    
    [super dealloc];
}
@end

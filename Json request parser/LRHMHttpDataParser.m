//
//  LRHMHttpDataParser.m
//  Json request parser
//
//  Created by 蓝锐黑梦 on 15/4/7.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMHttpDataParser.h"
#import "ObjectXML.h"
@implementation LRHMHttpDataParser
+ (LRHMHttpDataParser *)shareHttpDataParser
{
    static LRHMHttpDataParser *shareDataParserObj = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        shareDataParserObj = [[LRHMHttpDataParser alloc] init];
    });
    return shareDataParserObj;
}

- (id)structuredDataFromRawDataString:(NSString *)rawData
{
    id structData = nil;
    if ([self isValidXmlData:rawData]) {
        structData = [self xmlStructuredDataFromRawDataString:rawData];
    }else if ([self isValidJsonData:rawData]){
        structData = [self jsonStructuredDataFromRawDataString:rawData];
    }
    return structData;
}

- (id)jsonStructuredDataFromRawDataString:(NSString *)rawData
{
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:[rawData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    if (error != nil) {
        obj = @{@"class": error.className, @"code": [NSNumber numberWithInteger:error.code], @"domain": error.domain, @"reason":error.localizedFailureReason};
    }
    return obj;
}

- (id)xmlStructuredDataFromRawDataString:(NSString *)rawData {
    OXNode *node = [OXNode nodeWithString:rawData];
    return node;
}

- (BOOL)isValidJsonData:(NSString *)rawData
{
    NSInteger index = 0;
    unichar chr;
    do {
        if (index >= rawData.length) {
            return NO;
        }
        chr = [rawData characterAtIndex:index];
        index += 1;
    } while ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:chr]);
    
    return chr == '[' || chr == '{';
}

- (BOOL)isValidXmlData:(NSString *)rawData
{
    NSInteger index = 0;
    unichar chr;
    do {
        if (index >= rawData.length) {
            return NO;
        }
        chr = [rawData characterAtIndex:index];
        index += 1;
    } while ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:chr]);
    
    return chr == '<';
}
@end

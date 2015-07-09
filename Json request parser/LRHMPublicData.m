//
//  LRHMPublicData.m
//  Json request parser
//
//  Created by aggsugar on 15/4/10.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMPublicData.h"

@implementation LRHMPublicData
//@synthesize httpMethodImages;
//@synthesize httpMethods;

+ (LRHMPublicData *)sharePublicData
{
    static LRHMPublicData *shareData = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        shareData = [[LRHMPublicData alloc] init];
    });
    return shareData;
}

- (NSArray *)httpMethods
{
    return [NSArray arrayWithObjects:@"get",@"post",@"put",@"delete",@"patch",@"copy",@"head",@"options",@"link",@"unlink",@"purge", nil];
}

- (NSArray *)httpMethodImages
{
    return [NSArray arrayWithObjects:[NSImage imageNamed:@"getMethod"],
            [NSImage imageNamed:@"postMethod"],
            [NSImage imageNamed:@"putMethod"],
            [NSImage imageNamed:@"deleteMethod"],
            [NSImage imageNamed:@"patchMethod"],
            [NSImage imageNamed:@"copyMethod"],
            [NSImage imageNamed:@"headMethod"],
            [NSImage imageNamed:@"optionsMethod"],
            [NSImage imageNamed:@"linkMethod"],
            [NSImage imageNamed:@"unlinkMethod"],
            [NSImage imageNamed:@"purgeMethod"],nil];
}

- (NSImage *)imageByMethod:(NSString *)method
{
    NSString *httpMethod = [method lowercaseString];
    NSInteger index = [[self httpMethods] indexOfObject:httpMethod];
    if ((index >=0) && (index < [[self httpMethodImages] count])) {
        return [[self httpMethodImages] objectAtIndex:index];
    }
    return nil;
}
@end

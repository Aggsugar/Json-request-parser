//
//  LRHMPublicData.h
//  Json request parser
//
//  Created by aggsugar on 15/4/10.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LRHMPublicData : NSObject
//@property (readonly) NSArray * httpMethods;
//@property (readonly) NSArray * httpMethodImages;
+ (LRHMPublicData *)sharePublicData;
- (NSImage *)imageByMethod:(NSString *)method;
- (NSArray *)httpMethods;
@end

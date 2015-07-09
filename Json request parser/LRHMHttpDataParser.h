//
//  LRHMHttpDataParser.h
//  Json request parser
//
//  Created by aggsugar on 15/4/7.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRHMHttpDataParser : NSObject

+ (LRHMHttpDataParser *)shareHttpDataParser;
- (id)structuredDataFromRawDataString:(NSString *)rawData;
@end

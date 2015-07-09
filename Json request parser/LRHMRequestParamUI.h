//
//  LRHMRequestParamUI.h
//  Json request parser
//
//  Created by tangj on 15/4/27.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LRHMRequestParamUI : NSViewController
- (void)setHeaders:(NSArray *)headers;
- (void)setParams:(NSArray *)params;
- (void)setRequestBody:(id)body;

- (NSArray *)headers;
- (NSArray *)params;
- (id)requestBody;
@end

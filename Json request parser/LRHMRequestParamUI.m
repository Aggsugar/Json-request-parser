//
//  LRHMRequestParamUI.m
//  Json request parser
//
//  Created by tangj on 15/4/27.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMRequestParamUI.h"
#import "LRHMDictionaryFieldView.h"
@interface LRHMRequestParamUI ()
{
    IBOutlet LRHMDictionaryFieldView  *_headerView;
    IBOutlet LRHMDictionaryFieldView  *_paramsView;
    IBOutlet LRHMDictionaryFieldView  *_formView;
    IBOutlet NSTextView               *_rawTextView;
    
    IBOutlet NSTabView *_bodyTabView;
}
@end

@implementation LRHMRequestParamUI
- (id)init
{
    self = [super init];
    if (self) {
        [NSBundle loadNibNamed:@"LRHMRequestParamUI" owner:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (NSArray *)headers;
{
    return [_headerView dictionaryValues];
}

- (NSArray *)params
{
    return [_paramsView dictionaryValues];
}

- (void)setHeaders:(NSArray *)headers
{
    [_headerView updateFiledViewBy:headers];
}

- (void)setParams:(NSArray *)params
{
    [_paramsView updateFiledViewBy:params];
}

- (id)requestBody
{
    if ([[[_bodyTabView selectedTabViewItem] label] isEqualToString:@"x-www-form-urlencoded"]) {
        return [_formView dictionaryValues];
    }else if ([[[_bodyTabView selectedTabViewItem] label] isEqualToString:@"raw"]) {
        return [_rawTextView string];
    }
    return nil;
}

- (void)setRequestBody:(id)body
{
    if ([body isKindOfClass:[NSArray class]]) {
        [_formView updateFiledViewBy:body];
    }else if([body isKindOfClass:[NSString class]]){
        _rawTextView.string = body;
    }
}
@end

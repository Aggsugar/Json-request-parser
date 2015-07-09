//
//  LRHMHttpRequestUI.h
//  Json request parser
//
//  Created by tangj on 15/4/10.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LRHMHttpRequestUI;
@class LRHMRequestInfo;
extern NSString *const LRHMScalingNotification;
extern NSString *const LRHMAddCollectionCompletedNotification;
extern NSString *const LRHMStartSendRequestNotification;

typedef enum {
    LRHMScalingType_expand,
    LRHMScalingType_collapse,
}LRHMScalingType;


@interface LRHMHttpRequestUI : NSViewController
@property (assign) IBOutlet NSTextView  *resultView;
- (void)setReceiveJsonData:(NSString *)receiveData;
@end

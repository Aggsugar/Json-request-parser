//
//  LRHMHttpRequestUI.m
//  Json request parser
//
//  Created by aggsugar on 15/4/10.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMHttpRequestUI.h"
#import "LRHMPublicData.h"
#import "LRHMAddCollectionCtrl.h"
#import "LRHMRequestParamUI.h"
#import "JRPPreviewCtrl.h"
#import "LRHMRequestInfo.h"
#import "LRHMCollectionUI.h"
#import "LRHMRequestCollectionMgr.h"
#import "LRHMHistoryUI.h"
NSString *const LRHMScalingNotification = @"LRHMScalingNotification";
NSString *const LRHMAddCollectionCompletedNotification  = @"LRHMAddCollectionCompletedNotification";
NSString *const LRHMStartSendRequestNotification = @"LRHMShouldAddRequestHistoryNotification";

@interface LRHMHttpRequestUI ()<LRHMAddCollectionCtrlDelegate>
{
    LRHMAddCollectionCtrl *_collectionCtrl;
    LRHMRequestParamUI    *_requestParamCtrl;
    JRPPreviewCtrl        *_previewCtrl;
    
    NSDrawer              *_drawer;
    IBOutlet  NSProgressIndicator *_circleProgress;
}
@property (readonly) NSArray *requestMethods;
@property (readwrite,copy) NSString *address;
@property (readwrite,copy) NSString *selectMethod;
@property (assign) BOOL isEnableOfGoBtn;
@end

@implementation LRHMHttpRequestUI

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}


- (void)awakeFromNib
{
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCollectionDidChange:) name:LRHMSelelctDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCollectionDidChange:) name:LRHMHistorySelectDidChangeNotification object:nil];
    self.selectMethod = @"get";
    
    [_circleProgress setHidden:YES];
}

- (void)initDrawer
{
    if (!_drawer) {
        _drawer = [[NSDrawer alloc] initWithContentSize:NSMakeSize(NSWidth([self requestParamCtrl].view.frame), NSHeight([[NSApp mainWindow] frame])*0.9) preferredEdge:NSMaxXEdge];
        [_drawer setContentView:[self requestParamCtrl].view];
        [_drawer setParentWindow:[NSApp mainWindow]];
    }
}

- (LRHMAddCollectionCtrl *)collectionCtrl
{
    if (!_collectionCtrl) {
        _collectionCtrl = [[LRHMAddCollectionCtrl alloc] initWithNibName:@"LRHMAddCollectionCtrl" bundle:nil];
        [_collectionCtrl setDelegate:self];
    }
    return _collectionCtrl;
}

- (LRHMRequestParamUI *)requestParamCtrl
{
    if (!_requestParamCtrl) {
        _requestParamCtrl = [[LRHMRequestParamUI alloc] init];//initWithNibName:@"LRHMRequestParamUI" bundle:nil];
    }
    return _requestParamCtrl;
}

- (JRPPreviewCtrl *)previewCtrl
{
    if (!_previewCtrl) {
        _previewCtrl = [[JRPPreviewCtrl alloc] initWithNibName:@"JRPPreviewCtrl" bundle:nil];
    }
    return _previewCtrl;
}

- (void)setReceiveJsonData:(NSString *)receiveData
{
    if (receiveData) {
        self.resultView.string = receiveData;
    }
    [_circleProgress setHidden:YES];
    [_circleProgress stopAnimation:nil];
}

- (NSArray *)requestMethods
{
    return [[LRHMPublicData sharePublicData] httpMethods];
}

- (IBAction)scaleAction:(id)sender
{
    LRHMScalingType type = -1;
    if (NSEqualPoints(NSZeroPoint,self.view.frame.origin )) {
        type = LRHMScalingType_expand;
    }else{
        type = LRHMScalingType_collapse;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LRHMScalingNotification object:[NSNumber numberWithInt:type]];
}

- (IBAction)addCollectionAction:(id)sender
{
    [[self collectionCtrl] popupAddCollectionView];
}

- (IBAction)previewAction:(id)sender
{
    [[self previewCtrl] popPreview];
}

- (IBAction)requestParamsAction:(id)sender
{
    if ([[sender identifier] isEqualToString:@"urlParams"]) {
        
    }
    
    if ([[sender identifier] isEqualToString:@"headers"]) {
        
    }
    [self drawerToggle];
}

- (IBAction)startRequest:(id)sender
{
    [_circleProgress setHidden:NO];
    [_circleProgress startAnimation:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:LRHMStartSendRequestNotification object:[self sendRequestInfo]];
}

- (void)controlTextDidChange:(NSNotification *)aNotification
{
    self.address = [[aNotification object] stringValue];
    if ([self.address isEqualToString:@""] || !self.address) {
        self.isEnableOfGoBtn = NO;
    }else{
        self.isEnableOfGoBtn = YES;
    }
}

- (void)drawerToggle
{
    [self initDrawer];
    [_drawer toggle:nil];
}

- (void)addToCollection:(NSString *)collectionName withRequestName:(NSString *)requestName
{
    LRHMRequestInfo *requestInfo = [self sendRequestInfo];
    requestInfo.requestName = requestName;
    
    [[LRHMRequestCollectionMgr shareCollectionMgr] addRequestInfo:requestInfo toCollection:collectionName];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LRHMAddCollectionCompletedNotification object:nil];
}

- (LRHMRequestInfo *)sendRequestInfo
{
    LRHMRequestInfo *requestInfo = [[[LRHMRequestInfo alloc] init] autorelease];
    requestInfo.requestHttpPath = self.address;
    requestInfo.requestMethod = self.selectMethod;
    
    NSArray *headers = [[self requestParamCtrl] headers];
    for (NSDictionary * header in headers) {
        [requestInfo addRequestHeadersWithValue:[[header allValues] objectAtIndex:0] withKey:[[header allKeys] objectAtIndex:0]];
    }
    
    NSArray *params = [[self requestParamCtrl] params];
    for (NSDictionary *param in params) {
        [requestInfo addRequestParamsWithValue:[[param allValues] objectAtIndex:0] withKey:[[param allKeys] objectAtIndex:0]];
    }
    
    id body = [[self requestParamCtrl] requestBody];
    if ([body isKindOfClass:[NSString class]]) {
        [requestInfo setRequestRawBody:body];
    }else if([body isKindOfClass:[NSArray class]]){
        for (NSDictionary *item in body) {
            [requestInfo addRequestFormUrlencodeds:[[item allValues] objectAtIndex:0] withKey:[[item allKeys] objectAtIndex:0]];
        }
    }
    return requestInfo;
}

- (void)selectCollectionDidChange:(NSNotification *)obj
{
    LRHMRequestInfo *requestInfo = [obj object];
    self.address = requestInfo.requestHttpPath;
    self.selectMethod = requestInfo.requestMethod;
    
    if ([self.address isEqualToString:@""] || !self.address) {
        self.isEnableOfGoBtn = NO;
    }else{
        self.isEnableOfGoBtn = YES;
    }
    
    if ([[requestInfo requestHeaderDics] count] > 0) {
        [[self requestParamCtrl] setHeaders:[requestInfo requestHeaderDics]];
    }
    
    if ([requestInfo.requestParamDics count] > 0 ) {
        [[self requestParamCtrl] setParams:requestInfo.requestParamDics];
    }
    
    
    [[self requestParamCtrl] setRequestBody:[requestInfo requestBodys]];
}
@end

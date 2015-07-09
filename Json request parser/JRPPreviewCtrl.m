//
//  JRPPreviewCtrl.m
//  Json request parser
//
//  Created by tangj on 15/4/27.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "JRPPreviewCtrl.h"

@interface JRPPreviewCtrl ()

@end

@implementation JRPPreviewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)popPreview
{
    [self popupView];
}

- (IBAction)closePreview:(id)sender
{
    [self closePopupView];
}
@end

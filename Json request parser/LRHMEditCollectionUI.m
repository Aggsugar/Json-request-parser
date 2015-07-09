//
//  LRHMEditCollectionUI.m
//  Json request parser
//
//  Created by tangj on 15/5/4.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMEditCollectionUI.h"

@interface LRHMEditCollectionUI ()

@end

@implementation LRHMEditCollectionUI
@synthesize viewTitle;
@synthesize returnName;
@synthesize oldName;
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)popupEditCollectionView
{
    [self popupView];
}

- (IBAction)closeEditCollectionView:(id)sender
{
    [self closePopupView];
}

- (IBAction)edited:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editCollectionUI:withName:)]) {
        [self.delegate editCollectionUI:self withName:self.returnName];
    }
    [self closePopupView];
}

- (void)controlTextDidChange:(NSNotification *)aNotification
{
    self.returnName = [[aNotification object] stringValue];
}

@end

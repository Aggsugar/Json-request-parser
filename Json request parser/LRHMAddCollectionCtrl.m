//
//  LRHMAddCollectionCtrl.m
//  Json request parser
//
//  Created by aggsugar on 15/4/21.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMAddCollectionCtrl.h"
#import "LRHMRequestCollectionMgr.h"
@interface LRHMAddCollectionCtrl ()
{
    NSArray * _existingCollections;
    IBOutlet NSPopUpButton  *_popupBtn;
}
@property (readonly) NSArray *existingCollections;
@property (readwrite,copy) NSString *theNewCollectionName;
@property (readwrite,copy) NSString *requestName;
@property (readonly,copy) NSString *selectExistCollection;
@end

@implementation LRHMAddCollectionCtrl
{
    NSString *_selectExistCollection;
   
}
@synthesize selectExistCollection = _selectExistCollection;
@synthesize existingCollections = _existingCollections;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.theNewCollectionName = nil;
    // Do view setup here.
}

- (void)awakeFromNib
{
    [self updatePopupBtnData];
    if ([[[LRHMRequestCollectionMgr shareCollectionMgr] parentCollections] count] > 0) {
        _selectExistCollection = [[[LRHMRequestCollectionMgr shareCollectionMgr] parentCollections] objectAtIndex:0];
    }else{
        _selectExistCollection = @"Default";
    }
}

- (void)updatePopupBtnData
{
    [_popupBtn removeAllItems];
    if ([[[LRHMRequestCollectionMgr shareCollectionMgr] parentCollections] count] > 0) {
        [_popupBtn addItemsWithTitles:[[LRHMRequestCollectionMgr shareCollectionMgr] parentCollections]];
    }else{
        [_popupBtn addItemWithTitle:@"Default"];
    }
    
}

- (NSString *)selectExistCollection
{
    return _selectExistCollection;
}

- (NSArray *)existingCollections
{
    return _existingCollections;
}

- (IBAction)closeCollectionCtrl:(id)sender
{
    
}

- (IBAction)addToCollection:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addToCollection:withRequestName:)]) {
        NSString *collectionName = self.selectExistCollection;
        if (self.theNewCollectionName) {
            collectionName = self.theNewCollectionName;
        }
        [self.delegate addToCollection:collectionName withRequestName:self.requestName];
    }
    [self closePopupView];
}

- (void)controlTextDidChange:(NSNotification *)aNotification
{
    NSTextField *field = [aNotification object];
    if ([[field identifier] isEqualToString:@"requestName"]) {
        self.requestName = [field stringValue];
    }else if([[field identifier] isEqualToString:@"theNewCollection"]){
        self.theNewCollectionName = [field stringValue];
    }
}

- (void)popupAddCollectionView
{
    self.requestName = nil;
    self.theNewCollectionName = nil;
    [self updatePopupBtnData];
    
    [self popupView];
}

- (IBAction)cancelAction:(id)sender
{
    [self closePopupView];
}
@end

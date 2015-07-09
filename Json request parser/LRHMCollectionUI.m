//
//  LRHMCollectionUI.m
//  Json request parser
//
//  Created by tangj on 15/4/10.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMCollectionUI.h"
#import "LRHMRequestCollectionMgr.h"
#import "LRHMTableCellView.h"
#import "LRHMPublicData.h"
#import "LRHMRequestInfo.h"
#import "LRHMEditCollectionUI.h"
NSString *const collectionHeaderPrefix = @"collectionHeader_";
NSString *const LRHMSelelctDidChangeNotification = @"selectDidChangeNotification";

@interface LRHMCollectionUI ()<LRHMEditCollectionUIDelegate>
{
    IBOutlet NSOutlineView  *_collectionsView;
     LRHMEditCollectionUI *_editCollectionUI;
}
@end

@implementation LRHMCollectionUI

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do view setup here.
}

- (void)awakeFromNib{
     [_collectionsView reloadData];
}

- (LRHMEditCollectionUI *)editCollectionUI
{
    if (!_editCollectionUI) {
        _editCollectionUI = [[LRHMEditCollectionUI alloc] initWithNibName:@"LRHMEditCollectionUI" bundle:nil];
        [_editCollectionUI setDelegate:self];
    }
    return _editCollectionUI;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    return [[[LRHMRequestCollectionMgr shareCollectionMgr] collectItemsBy:item] objectAtIndex:index];
}

- (NSInteger) outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    return [[[LRHMRequestCollectionMgr shareCollectionMgr] collectItemsBy:item] count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    return [[[LRHMRequestCollectionMgr shareCollectionMgr] parentCollections] containsObject:item];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if ([outlineView parentForItem:item] == nil) {
        return YES;
    } else {
        return NO;
    }
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    NSString *identify = nil;
    LRHMTableCellView *result = nil;
    if ([[[LRHMRequestCollectionMgr shareCollectionMgr] parentCollections] containsObject:item]) {
        result = [outlineView makeViewWithIdentifier:@"headerCell" owner:self];
        result.textField.stringValue = item;
//        result.editButton.image = [NSImage imageNamed:@"Untitled"];
        identify = [collectionHeaderPrefix stringByAppendingString:item];
        result.editButton.identifier = [collectionHeaderPrefix stringByAppendingString:item];
        result.deleteButton.identifier = [collectionHeaderPrefix stringByAppendingString:item];
    } else  {
        result = [outlineView makeViewWithIdentifier:@"recordCell" owner:self];
        result.imageView.image = [[LRHMPublicData sharePublicData] imageByMethod:[[LRHMRequestCollectionMgr shareCollectionMgr] requestMethodOf:item]];
        result.textField.stringValue = [[LRHMRequestCollectionMgr shareCollectionMgr] requestDescriptionOf:item];
        identify = [collectionHeaderPrefix stringByAppendingString:[[LRHMRequestCollectionMgr shareCollectionMgr] parentNameOfItem:item]];
        identify = [identify stringByAppendingFormat:@"_%@",((LRHMRequestInfo *)item).identify];
    }
    
    result.editButton.identifier = identify;
    result.editButton.target = self;
    result.editButton.action = @selector(deleteCollection:);
    
    result.deleteButton.identifier = identify;
    result.deleteButton.target = self;
    result.deleteButton.action = @selector(editCollection:);
     return result;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
  id item = [_collectionsView itemAtRow:[_collectionsView selectedRow]];
  if([item isKindOfClass:[LRHMRequestInfo class]]){
        [[NSNotificationCenter defaultCenter] postNotificationName:LRHMSelelctDidChangeNotification object:item];
    }
}

- (void)deleteCollection:(id)sender
{
    NSString *identify = [sender identifier];
    NSArray * filteredStrs = [identify componentsSeparatedByString:@"_"];
    NSString *collectionName = nil;
    NSString *requestIdentify = nil;
    if ([filteredStrs count] > 2) {
        collectionName = [filteredStrs objectAtIndex:1];
        requestIdentify = [filteredStrs objectAtIndex:2];
    }else{
        collectionName = [filteredStrs objectAtIndex:1];
        requestIdentify = nil;
    }
    [[LRHMRequestCollectionMgr shareCollectionMgr]removeRequestInfoBy:requestIdentify inCollection:collectionName];
    [self updateCollectionUI];
}

- (void)editCollection:(id)sender
{
    NSString *identify = [sender identifier];
    NSArray * filteredStrs = [identify componentsSeparatedByString:@"_"];
    if ([filteredStrs count] > 2) {
        [[self editCollectionUI] setViewTitle:@"Edit Request"];
        [[self editCollectionUI] setOldName:[NSString stringWithFormat:@"%@_%@",[filteredStrs objectAtIndex:1],[filteredStrs objectAtIndex:2]]];
    }else{
        [[self editCollectionUI] setViewTitle:@"Edit Collection"];
        [[self editCollectionUI] setOldName:[filteredStrs objectAtIndex:1]];
    }
    [[self editCollectionUI] popupEditCollectionView];
}

- (void)editCollectionUI:(LRHMEditCollectionUI *)collectionUI withName:(NSString *)name
{
    if ([collectionUI.viewTitle isEqualToString:@"Edit Request"]) {
        NSArray * strs = [collectionUI.oldName componentsSeparatedByString:@"_"];
        [[LRHMRequestCollectionMgr shareCollectionMgr] editCollection:[strs objectAtIndex:0] AtItem:[strs objectAtIndex:1] withNewRequestName:name];
    }else{
        [[LRHMRequestCollectionMgr shareCollectionMgr] editCollection:collectionUI.oldName withNewCollectionName:name];
    }
    [self updateCollectionUI];
}

- (void)updateCollectionUI
{
    [_collectionsView reloadData];
}
@end

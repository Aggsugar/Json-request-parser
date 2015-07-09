//
//  LRHMHistoryUI.m
//  Json request parser
//
//  Created by tangj on 15/4/10.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "LRHMHistoryUI.h"
#import "LRHMRequestHistoryMgr.h"
#import "LRHMTableCellView.h"
#import "LRHMPublicData.h"
NSString *const LRHMHistorySelectDidChangeNotification = @"historySelectDidChangeNotification";
@interface LRHMHistoryUI ()
{
    IBOutlet NSTableView *_tableView;
}
@end

@implementation LRHMHistoryUI

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [[LRHMRequestHistoryMgr shareHistoryMgr] historysCount];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    return [[LRHMRequestHistoryMgr shareHistoryMgr] requestDescriptionAtHistory:rowIndex];
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    LRHMTableCellView *tableCell = [tableView makeViewWithIdentifier:@"historyItemCell" owner:self];
    tableCell.imageView.image = [[LRHMPublicData sharePublicData] imageByMethod:[[LRHMRequestHistoryMgr shareHistoryMgr] requestMethodAtHistory:row]];
    tableCell.textField.stringValue = [[LRHMRequestHistoryMgr shareHistoryMgr] requestDescriptionAtHistory:row];
    tableCell.deleteButton.tag = row;
    tableCell.deleteButton.target = self;
    tableCell.deleteButton.action = @selector(deleteHistory:);
    return tableCell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LRHMHistorySelectDidChangeNotification object:[[LRHMRequestHistoryMgr shareHistoryMgr] requestInfoAt:[_tableView selectedRow]]];
}

- (void)deleteHistory:(id)sender
{
    [[LRHMRequestHistoryMgr shareHistoryMgr] removeHistoryAt:[sender tag]];
    [self reloadHistoryUI];
}

- (void)reloadHistoryUI
{
    [_tableView reloadData];
}
@end

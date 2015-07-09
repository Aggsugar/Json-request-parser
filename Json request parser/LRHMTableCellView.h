//
//  LRHMTableCellView.h
//  Json request parser
//
//  Created by aggsugar on 15/4/9.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LRHMTableCellView : NSTableCellView
{
@private
    NSButton   *_editButton;
    NSButton   *_deleteButton;
}
@property (retain) IBOutlet NSButton *editButton;
@property (retain) IBOutlet NSButton *deleteButton;
@end

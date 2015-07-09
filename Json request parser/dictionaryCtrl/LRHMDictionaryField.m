//
//  LRHMDictionaryField.m
//  testss
//
//  Created by tangj on 15/4/3.
//  Copyright (c) 2015年 tangj. All rights reserved.
//

#import "LRHMDictionaryField.h"

@interface LRHMDictionaryField ()
{
    IBOutlet NSTextField *keyField;
    IBOutlet NSTextField  *valueField;
}
@end

@implementation LRHMDictionaryField
@synthesize identify;
@synthesize isCanRemove;
@synthesize delegate;

@synthesize keyStr ;//= _keyStr;
@synthesize valueStr;// = _valueStr;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)awakeFromNib
{
     [keyField.cell setPlaceholderString:@"key"];
    [valueField setPlaceholderString:@"value"];
}
- (IBAction)removeFieldItem:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeDictionaryFieldItem:)]) {
        [self.delegate removeDictionaryFieldItem:self];
    }
}

- (IBAction)addFieldItem:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addDictionaryFieldItem:)]) {
        [self.delegate addDictionaryFieldItem:self];
    }
}

- (void)controlTextDidChange:(NSNotification *)aNotification
{
    NSTextField *field = [aNotification object];
    if ([[field identifier] isEqualToString:@"value"]) {
        self.valueStr = [field stringValue];
    }else if ([[field identifier] isEqualToString:@"key"]){
        self.keyStr = [field stringValue];
    }
}
@end

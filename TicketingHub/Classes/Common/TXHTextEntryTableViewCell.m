//
//  TXHTextEntryTableViewCell.m
//  TicketingHub
//
//  Created by Mark on 16/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTextEntryTableViewCell.h"

@interface TXHTextEntryTableViewCell () <UITextFieldDelegate>

@property TXHTextEntryView *placeholder;

@end

@implementation TXHTextEntryTableViewCell

- (void)setupDataContent {
    [super setupDataContent];
    self.placeholder = [[TXHTextEntryView alloc] initWithFrame:CGRectInset(self.bounds, 8.0f, 0.0f)];
    [self.contentView addSubview:self.placeholder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[UIApplication sharedApplication] sendAction:@selector(makeCellVisible:) to:nil from:self forEvent:nil];
    
    if (self.errorMessage.length) {
        // If there is an error message associated with this data item, clear it when editing occurs.
        self.errorMessage = @"";
    }
}

- (TXHTextEntryView *)textField {
    return self.placeholder;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.textField reset];
}

@end

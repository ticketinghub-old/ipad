//
//  TXHTextEntryView.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTextEntryView.h"

@interface TXHTextEntryView () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textField;

@end

@implementation TXHTextEntryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupDataContent {
    [super setupDataContent];
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    _textField.delegate = self;
    [self updateDataContentView:_textField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[UIApplication sharedApplication] sendAction:@selector(makeCellVisible:) to:nil from:self forEvent:nil];
    
    if (self.errorMessage.length) {
        // If there is an error message associated with this data item, clear it when editing occurs.
        self.errorMessage = @"";
    }
}

- (NSString *)text {
    return self.textField.text;
}

- (void)setText:(NSString *)text {
    self.textField.text = text;
}

- (NSString *)placeholder {
    return self.textField.placeholder;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.textField.placeholder = placeholder;
}

- (UIKeyboardType)keyboardType {
    return self.textField.keyboardType;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    self.textField.keyboardType = keyboardType;
}

- (void)reset {
    self.textField.text = @"";
}

@end

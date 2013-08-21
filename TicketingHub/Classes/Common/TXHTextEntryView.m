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

- (void)setupDataContent {
    [super setupDataContent];
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    _textField.delegate = self;
    [self updateDataContentView:_textField];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.delegate) {
        return [self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[UIApplication sharedApplication] sendAction:@selector(makeCellVisible:) to:nil from:self forEvent:nil];
    
    if (self.errorMessage.length) {
        // If there is an error message associated with this data item, clear it when editing occurs.
        self.errorMessage = @"";
    }
    [self.delegate textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.delegate textFieldDidEndEditing:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.delegate) {
        return [self.delegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.delegate) {
        return [self.delegate textFieldShouldClear:textField];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate) {
        return [self.delegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.delegate) {
        return [self.delegate textFieldShouldReturn:textField];
    }
    return YES;
}

@end

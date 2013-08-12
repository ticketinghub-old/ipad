//
//  TXHTextCollectionViewCell.m
//  TicketingHub
//
//  Created by Mark on 09/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTextCollectionViewCell.h"

@interface TXHTextCollectionViewCell () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textField;

@end

@implementation TXHTextCollectionViewCell

- (void)setupDataContent {
    [super setupDataContent];
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    _textField.delegate = self;
    [self updateDataContentView:_textField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[UIApplication sharedApplication] sendAction:@selector(makeCellVisible:) to:nil from:self forEvent:nil];
//    [self performSelector:@selector(focusView:) withObject:self];
    
    if (self.errorMessage.length) {
        // If there is an error message associated with this data item, clear it when editing occurs.
        self.errorMessage = @"";
    }
}

- (void)focusView:(id)sender {
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.textField.text = @"";
}

@end

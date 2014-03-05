//
//  TXHSalesInformationTextCell.m
//  TicketingHub
//
//  Created by Mark on 08/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesInformationTextCell.h"

@import QuartzCore;

#import "TXHDataEntryFieldErrorView.h"
#import "UIColor+TicketingHub.h"

@interface TXHSalesInformationTextCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *backingView;

@property (weak, nonatomic) IBOutlet TXHDataEntryFieldErrorView *dataErrorView;

@end

@implementation TXHSalesInformationTextCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backingView.layer.cornerRadius = 4.0;
    self.dataErrorView.layer.cornerRadius = 3.0;
    
    self.textField.delegate = self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.textField.placeholder = placeholder;
}

- (void)setText:(NSString *)text
{
    self.textField.text = text;
}

- (NSString *)text
{
    return self.textField.text;
}

- (void)setErrorMessage:(NSString *)errorMessage
{
    self.dataErrorView.message = errorMessage;
    [self updateColors];
}

- (void)updateColors
{
    BOOL hasError = [self hasErrors];
    
    self.textField.backgroundColor   = hasError ? [UIColor txhFieldErrorBackgroundColor] : [UIColor txhFieldNormalBackgroundColor];
    self.backingView.backgroundColor = self.textField.backgroundColor;
    self.textField.textColor         = hasError ? [UIColor txhFieldErrorTextColor] : [UIColor txhFieldNormalTextColor];
}

- (BOOL)hasErrors
{
    return (self.dataErrorView.message.length > 0);
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.dataErrorView.message = @"";
    self.textField.text = @"";
}

- (IBAction)textValueChanged:(id)sender
{
    [self.delegate txhSalesInformationTextCellDidChangeText:self];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


@end

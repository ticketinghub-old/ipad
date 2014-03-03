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

@interface TXHSalesInformationTextCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *backingView;

@property (weak, nonatomic) IBOutlet TXHDataEntryFieldErrorView *dataErrorView;

@end

@implementation TXHSalesInformationTextCell

+ (UIColor *)errorBackgroundColor
{
    static UIColor *_errorBackgroundColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _errorBackgroundColor = [UIColor colorWithRed:255.0f / 255.0f
                                                green:213.0f / 255.0f
                                                 blue:216.0f / 255.0f
                                                alpha:1.0f];
    });
    return _errorBackgroundColor;
}

+ (UIColor *)normalBackgroundColor
{
    static UIColor *_normalBackgroundColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _normalBackgroundColor = [UIColor colorWithRed:238.0f / 255.0f
                                                 green:241.0f / 255.0f
                                                  blue:243.0f / 255.0f
                                                 alpha:1.0f];
    });
    return _normalBackgroundColor;
}

+ (UIColor *)errorTextColor
{
    static UIColor *_errorTextColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _errorTextColor = [UIColor redColor];
    });
    return _errorTextColor;
}

+ (UIColor *)normalTextColor
{
    static UIColor *_normalTextColor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _normalTextColor = [UIColor colorWithRed:37.0f / 255.0f
                                           green:16.0f / 255.0f
                                            blue:87.0f / 255.0f
                                           alpha:1.0f];
    });
    return _normalTextColor;
}

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
    
    self.textField.backgroundColor   = hasError ? [[self class] errorBackgroundColor] : [[self class] normalBackgroundColor];
    self.backingView.backgroundColor = self.textField.backgroundColor;
    self.textField.textColor         = hasError ? [[self class] errorTextColor] : [[self class] normalTextColor];
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

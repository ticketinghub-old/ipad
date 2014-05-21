//
//  TXHCardBackView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHCardBackView.h"

#import <PaymentKit/PKCardCVC.h>
#import <PaymentKit/PKCardNumber.h>
#import <PaymentKit/PKTextField.h>

#import "UIColor+TicketingHub.h"


@interface TXHCardBackView ()

@property (strong, nonatomic) UIColor *validColor;
@property (strong, nonatomic) UIColor *invalidColor;

@property (weak, nonatomic) IBOutlet UITextField *cardCVCField;

@property (nonatomic, assign, getter = isValid) BOOL valid;

@end

@implementation TXHCardBackView

- (void)reset
{
    self.cardCVCField.text = nil;
}

- (void)setCardCvcFont:(UIFont *)font
{
    self.cardCVCField.font = font;
}

- (void)setValidTextColor:(UIColor *)color
{
    self.validTextColor = color;
}

- (void)setInvalidTextColor:(UIColor *)color
{
    self.invalidTextColor = color;
}

- (UIColor *)invalidColor
{
    if (!_invalidColor)
        return [UIColor redColor];
    
    return _invalidColor;
}

- (UIColor *)validColor
{
    if (!_validColor)
        return [UIColor txhDarkBlueColor];
    
    return _validColor;
}

// Code extracted From PKView

#pragma mark - Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(txhCardBackViewDidStartEditing:)])
        [self.delegate txhCardBackViewDidStartEditing:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    if ([textField isEqual:self.cardCVCField])
        return [self cardCVCShouldChangeCharactersInRange:range replacementString:replacementString];
    
    return YES;
}

- (BOOL)cardCVCShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.cardCVCField.text stringByReplacingCharactersInRange:range
                                                                             withString:replacementString];
    resultString           = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardCVC *cardCVC     = [PKCardCVC cardCVCWithString:resultString];
    PKCardType cardType    = self.cardType;
    
    // Restrict length
    if (![cardCVC isPartiallyValidWithType:cardType]) return NO;
    
    // Strip non-digits
    self.cardCVCField.text = [cardCVC string];
    
    if ([cardCVC isValidWithType:cardType])
    {
        [self textFieldIsValid:self.cardCVCField];
        [self.cardCVCField resignFirstResponder];
        
        if ([self.delegate respondsToSelector:@selector(txhCardBackView:didFinishValid:)])
            [self.delegate txhCardBackView:self didFinishValid:YES];
    }
    else
    {
        
        [self textFieldIsInvalid:self.cardCVCField withErrors:NO];
    }
    
    return NO;
}

#pragma mark - Validations

- (void)checkValid
{
    self.valid = [self areAllFieldsValid];
}

- (BOOL)areAllFieldsValid
{
    return [self.cardCVC isValid];
}

- (void)textFieldIsValid:(UITextField *)textField
{
    textField.textColor = self.validColor;
    [self checkValid];
}

- (void)textFieldIsInvalid:(UITextField *)textField withErrors:(BOOL)errors
{
    if (errors)
        textField.textColor = self.invalidColor;
    else
        textField.textColor = self.validColor;
    
    [self checkValid];
}

- (PKCardCVC *)cardCVC
{
    return [PKCardCVC cardCVCWithString:self.cardCVCField.text];
}

#pragma mark -
#pragma mark UIResponder

- (BOOL)isFirstResponder;
{
    return self.cardCVCField.isFirstResponder;
}

- (BOOL)canBecomeFirstResponder;
{
    return self.cardCVCField.canBecomeFirstResponder;
}

- (BOOL)becomeFirstResponder;
{
    return [self.cardCVCField becomeFirstResponder];
}

- (BOOL)canResignFirstResponder;
{
    return self.cardCVCField.canResignFirstResponder;
}

- (BOOL)resignFirstResponder;
{
    return [self.cardCVCField resignFirstResponder];
}

@end

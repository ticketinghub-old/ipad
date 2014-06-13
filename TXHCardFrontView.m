//
//  TXHCardFrontView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHCardFrontView.h"
#import "UIColor+TicketingHub.h"

@interface TXHCardFrontView () <UITextFieldDelegate>

@property (strong, nonatomic) UIColor *validColor;
@property (strong, nonatomic) UIColor *invalidColor;

@property (weak, nonatomic) IBOutlet UITextField *cardNumberField;
@property (weak, nonatomic) IBOutlet UITextField *cardExpiryField;

@property (weak, nonatomic) UITextField *currentField;

@property (readwrite, assign, nonatomic, getter = isValid) BOOL valid;

@end

@implementation TXHCardFrontView

- (void)reset
{
    self.cardNumberField.text = nil;
    self.cardExpiryField.text = nil;
}

- (void)setCardNumberFont:(UIFont *)font
{
    self.cardNumberField.font = font;
}

- (void)setCardExpiryFont:(UIFont *)font
{
    self.cardExpiryField.font = font;
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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentField = textField;
    
    if ([self.delegate respondsToSelector:@selector(txhCardFrontViewDidStartEditing:)])
        [self.delegate txhCardFrontViewDidStartEditing:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.currentField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.cardExpiryField])
    {
        PKCardExpiry *cardExpiry = [PKCardExpiry cardExpiryWithString:textField.text];
        if ([cardExpiry isValid])
        {
            [self textFieldIsValid:self.cardExpiryField];
            [[self nextFirstResponder] becomeFirstResponder];
        } else if ([cardExpiry isValidLength] && ![cardExpiry isValidDate]) {
            [self textFieldIsInvalid:self.cardExpiryField withErrors:YES];
        } else if (![cardExpiry isValidLength]) {
            [self textFieldIsInvalid:self.cardExpiryField withErrors:NO];
        }
    }
    if ([textField isEqual:self.cardNumberField])
    {
        PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:textField.text];
        if ([cardNumber isValid])
        {
            [self textFieldIsValid:self.cardNumberField];
            [[self nextFirstResponder] becomeFirstResponder];
        } else if ([cardNumber isValidLength] && ![cardNumber isValidLuhn]) {
            [self textFieldIsInvalid:self.cardNumberField withErrors:YES];
        } else if (![cardNumber isValidLength]) {
            [self textFieldIsInvalid:self.cardNumberField withErrors:NO];
        }
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    if ([textField isEqual:self.cardNumberField])
        return [self cardNumberFieldShouldChangeCharactersInRange:range replacementString:replacementString];
    else if ([textField isEqual:self.cardExpiryField])
        return [self cardExpiryShouldChangeCharactersInRange:range replacementString:replacementString];
    
    return YES;
}

- (BOOL)cardNumberFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.cardNumberField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardNumber *cardNumber = [PKCardNumber cardNumberWithString:resultString];
    
    if (![cardNumber isPartiallyValid])
        return NO;
    
    if (replacementString.length > 0)
        self.cardNumberField.text = [cardNumber formattedStringWithTrail];
    else
        self.cardNumberField.text = [cardNumber formattedString];
    
    self.cardNumberField.text = [self.cardNumberField.text stringByReplacingOccurrencesOfString:@" " withString:@"  "];

    [self textFieldIsInvalid:self.cardNumberField withErrors:NO];
    
    return NO;
}

- (BOOL)cardExpiryShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.cardExpiryField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [PKTextField textByRemovingUselessSpacesFromString:resultString];
    PKCardExpiry *cardExpiry = [PKCardExpiry cardExpiryWithString:resultString];
    
    if (![cardExpiry isPartiallyValid]) return NO;
    
    // Only support shorthand year
    if ([cardExpiry formattedString].length > 5) return NO;
    
    if (replacementString.length > 0) {
        self.cardExpiryField.text = [cardExpiry formattedStringWithTrail];
    } else {
        self.cardExpiryField.text = [cardExpiry formattedString];
    }
    
    [self textFieldIsInvalid:self.cardExpiryField withErrors:NO];
    
    return NO;
}

- (void)textFieldIsValid:(UITextField *)textField
{
    textField.textColor = self.validColor;
    [self checkValid];
}

- (void)textFieldIsInvalid:(UITextField *)textField withErrors:(BOOL)errors
{
    if (errors) {
        textField.textColor = self.invalidColor;
    } else {
        textField.textColor = self.validColor;
    }

}

- (void)setValid:(BOOL)valid
{
    _valid = valid;
    
    if (valid && [self.delegate respondsToSelector:@selector(txhCardFrontView:didFinishValid:)])
        [self.delegate txhCardFrontView:self didFinishValid:YES];
}

- (void)checkValid
{
    self.valid = [self areAllFieldsValid];
}

- (BOOL)areAllFieldsValid
{
    return [self.cardNumber isValid] && [self.cardExpiry isValid];
}

- (PKCardNumber *)cardNumber
{
    return [PKCardNumber cardNumberWithString:self.cardNumberField.text];
}

- (PKCardExpiry *)cardExpiry
{
    return [PKCardExpiry cardExpiryWithString:self.cardExpiryField.text];
}

#pragma mark -
#pragma mark UIResponder
- (UIResponder *)firstResponderField;
{
    NSArray *responders = @[self.cardNumberField, self.cardExpiryField];
    for (UIResponder *responder in responders) {
        if (responder.isFirstResponder) {
            return responder;
        }
    }
    
    return nil;
}

- (UITextField *)firstInvalidField;
{
    if (![[PKCardNumber cardNumberWithString:self.cardNumberField.text] isValid])
        return self.cardNumberField;
    else if (![[PKCardExpiry cardExpiryWithString:self.cardExpiryField.text] isValid])
        return self.cardExpiryField;
    
    return nil;
}

- (UITextField *)nextFirstResponder;
{
    return [self firstInvalidField];
}

- (BOOL)isFirstResponder;
{
    return self.firstResponderField.isFirstResponder;
}

- (BOOL)canBecomeFirstResponder;
{
    return self.nextFirstResponder.canBecomeFirstResponder;
}

- (BOOL)becomeFirstResponder;
{
    return [self.nextFirstResponder becomeFirstResponder];
}

- (BOOL)canResignFirstResponder;
{
    return self.firstResponderField.canResignFirstResponder;
}

- (BOOL)resignFirstResponder;
{
    return [self.firstResponderField resignFirstResponder];
}


@end

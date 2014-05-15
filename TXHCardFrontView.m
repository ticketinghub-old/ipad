//
//  TXHCardFrontView.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 13/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHCardFrontView.h"
#import <PaymentKit/PKTextField.h>

@interface TXHCardFrontView () <PKTextFieldDelegate>

@property (weak, nonatomic) IBOutlet PKTextField *cardNumberField;
@property (weak, nonatomic) IBOutlet PKTextField *cardExpiryField;

@property (readwrite, assign, nonatomic, getter = isValid) BOOL valid;

@end

@implementation TXHCardFrontView

#pragma mark - PKTextFieldDelegate

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
    
    if ([cardNumber isValid])
    {
        [self textFieldIsValid:self.cardNumberField];
        [self.cardExpiryField becomeFirstResponder];
    }
    else if ([cardNumber isValidLength] && ![cardNumber isValidLuhn])
        [self textFieldIsInvalid:self.cardNumberField withErrors:YES];
    else if (![cardNumber isValidLength])
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
    
    if ([cardExpiry isValid]) {
        [self textFieldIsValid:self.cardExpiryField];
        // todo: switch to back side
    } else if ([cardExpiry isValidLength] && ![cardExpiry isValidDate]) {
        [self textFieldIsInvalid:self.cardExpiryField withErrors:YES];
    } else if (![cardExpiry isValidLength]) {
        [self textFieldIsInvalid:self.cardExpiryField withErrors:NO];
    }
    
    return NO;
}

- (void)textFieldIsValid:(UITextField *)textField
{
    textField.textColor = [UIColor blackColor];
    [self checkValid];
}

- (void)textFieldIsInvalid:(UITextField *)textField withErrors:(BOOL)errors
{
    if (errors) {
        textField.textColor = [UIColor redColor];
    } else {
        textField.textColor = [UIColor blackColor];
    }
    
    [self checkValid];
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

@end

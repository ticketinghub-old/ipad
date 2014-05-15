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


@interface TXHCardBackView () <PKTextFieldDelegate>

@property (weak, nonatomic) IBOutlet PKTextField *cardCVCField;

@property (readwrite, assign, nonatomic, getter = isValid) BOOL valid;

@end

@implementation TXHCardBackView

// Code extracted From PKView

#pragma mark - Delegates

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
    }
    else
        [self textFieldIsInvalid:self.cardCVCField withErrors:NO];
    
    [self checkValid];
    
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
    textField.textColor = [UIColor blackColor];
    [self checkValid];
}

- (void)textFieldIsInvalid:(UITextField *)textField withErrors:(BOOL)errors
{
    if (errors)
        textField.textColor = [UIColor redColor];
    else
        textField.textColor = [UIColor blackColor];
    
    [self checkValid];
}

- (PKCardCVC *)cardCVC
{
    return [PKCardCVC cardCVCWithString:self.cardCVCField.text];
}


- (BOOL)becomeFirstResponder
{
    [self.cardCVCField becomeFirstResponder];
    return NO;
}


@end

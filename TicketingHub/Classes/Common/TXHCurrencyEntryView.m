//
//  TXHCurrencyEntryView.m
//  TicketingHub
//
//  Created by Mark on 21/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHCurrencyEntryView.h"

@interface UITextField (Selection)
- (NSRange) selectedRange;
- (void) setSelectedRange:(NSRange) range;
@end

@implementation UITextField (Selection)
- (NSRange) selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void) setSelectedRange:(NSRange) range
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}

@end

@interface TXHCurrencyEntryView ()

// Redefine the underlying textfield so we can work with it
@property UITextField *textField;

// A backing string to hold characters entered
@property (strong, nonatomic) NSString *enteredText;

// Count of formatting characters added to the entered text
@property (assign, nonatomic) NSUInteger formattingCharacterCount;

// A currency formatter for user facing presentation
@property (strong, nonatomic) NSNumberFormatter *currencyFormatter;

@end

@implementation TXHCurrencyEntryView

- (void)setupDataContent {
    [super setupDataContent];
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.textField.textAlignment = NSTextAlignmentRight;
    // Create a currency formatter (with the default currency).
    self.currencyFormatter = [[NSNumberFormatter alloc] init];
    self.currencyFormatter.formatterBehavior = NSNumberFormatterBehavior10_4;
    self.currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.currencyFormatter.currencyCode = @"GBP";
    self.enteredText = @"";
    self.amount = @(0);
    self.textField.placeholder = [self formattedAmount];
}

- (void)setCurrencyCode:(NSString *)currencyCode {
    _currencyCode = currencyCode;
    
    // Apply this currency to our formatter
    self.currencyFormatter.currencyCode = currencyCode;
}

- (void)setAmount:(NSNumber *)amount {
    _amount = amount;
}

- (NSString *)formattedAmount {
    return [self.currencyFormatter stringFromNumber:self.amount];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    // Get previously entered text from the backing field
    NSString *text = self.enteredText;
    
    // If string is equal to decimal separator, disallow if entered text already contains one
    NSRange decimalRange = [text rangeOfString:self.currencyFormatter.decimalSeparator];
    if ((decimalRange.location != NSNotFound) && ([string isEqualToString:self.currencyFormatter.decimalSeparator])) {
        return NO;
    }
    
    // If there is currently nothing entered and we are processing a backspace there is nothing to do
    if ((text.length == 0) && (string.length < 1)) {
        return NO;
    }

    // range indicates the text field cursor & is relative to the formatted text presented in the textfield; not the entered text we are storing.
    // We need to adjust the cursor location relative to the backing text held in enteredText.
    
    range.location -= self.formattingCharacterCount;
    
    // Create a new string holding the proposed text
    NSString *proposedText = [text stringByReplacingCharactersInRange:range withString:string];
    
    // If the proposed text is an empty string, reset underlying amount & return
    if (proposedText.length == 0) {
        textField.text = proposedText;
        self.enteredText = proposedText;
        self.formattingCharacterCount = 0;
        self.amount = @(0);
        return NO;
    }
    
    // The proposed text contains something
    
    // Appropriate currencySymbol can be found via our currency formatter.
    NSString *currencySymbol = self.currencyFormatter.currencySymbol;
    
    // If the proposed text contains just the currency symbol then we eat it.
    if ((proposedText.length == 1) && ([proposedText isEqualToString:currencySymbol])) {
        return NO;
    }
    
    // Appropriate decimalSeperator can be found via our currency formatter.
    NSString *decimalSeperator = self.currencyFormatter.decimalSeparator;
    
    // If the proposed text contains a single character and it is the decimal separator, insert a zero before it
    if ((proposedText.length == 1) && ([proposedText isEqualToString:decimalSeperator])) {
        proposedText = [NSString stringWithFormat:@"0%@", proposedText];
    }

    NSNumber *amount = [NSNumber numberWithDouble:proposedText.doubleValue];
    if (amount) {
        // We have a valid number, so assign backing values.
        self.enteredText = proposedText;
        self.amount = amount;
        textField.text = [self formattedAmount];
        // Set the range according to currency formatting
        self.formattingCharacterCount = 0;
        if ([self.currencyFormatter.positivePrefix isEqualToString:self.currencyFormatter.currencySymbol]) {
            // Add the size of the currency prefix
            self.formattingCharacterCount += self.currencyFormatter.currencySymbol.length;
        }
        // Add 1 to the range for each group separator
        NSString *temp = textField.text;
        NSRange groupRange = [temp rangeOfString:self.currencyFormatter.groupingSeparator];
        while (groupRange.location != NSNotFound) {
            self.formattingCharacterCount += 1;
            temp = [temp substringFromIndex:groupRange.location + groupRange.length];
            groupRange = [temp rangeOfString:self.currencyFormatter.groupingSeparator];
        }
        [textField setSelectedRange:NSMakeRange(self.formattingCharacterCount + self.enteredText.length, 0)];
        return NO;
    }
    
    // We couldn't make a number out of the entered text by adding the string, so just eat it
    return NO;
}

@end

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

// The cursor location for our textfield after formatting has been applied
@property (assign, nonatomic) NSUInteger cursorLocation;

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
    
    // If the string is equal to group separator then eat it
    if ([string isEqualToString:self.currencyFormatter.groupingSeparator]) {
        return NO;
    }
    
    // If string is equal to decimal separator, disallow if entered text already contains one
    NSRange decimalRange = [text rangeOfString:self.currencyFormatter.decimalSeparator];
    if ((decimalRange.location != NSNotFound) && ([string isEqualToString:self.currencyFormatter.decimalSeparator])) {
        return NO;
    }
    
    // If there is currently nothing entered and we are processing a backspace there is nothing to do
    if ((text.length == 0) && (string.length < 1)) {
        return NO;
    }
    
    // Grab the range we were given - we need it to work out where the cursor should go after formatting our currency value.
    NSRange adjustedRange = range;
    
    // range indicates the text field cursor & is relative to the formatted text presented in the textfield; not the entered text we are storing.
    // We need to adjust the cursor location relative to the backing text held in enteredText.
    adjustedRange.location -= self.formattingCharacterCount;
    
    // Create a new string holding the proposed text
    NSString *proposedText = [text stringByReplacingCharactersInRange:adjustedRange withString:string];
    
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

    // Switch the currency formatter style temporarily in order to extract a number in the appropriate locale
    self.currencyFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *numberFromProposedText = [self.currencyFormatter numberFromString:proposedText];
    // Now switch it back to currency style so that text displayed to the user will be presented as a currency 
    self.currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    double proposedValue = numberFromProposedText.doubleValue;
    NSLog(@"proposed text:%@ value:%f", proposedText, proposedValue);
    NSNumber *amount = [NSNumber numberWithDouble:proposedValue];
    
    if (amount) {
        // We have a valid number, so assign backing values.
        self.enteredText = proposedText;
        self.amount = amount;
        textField.text = [self formattedAmount];
        
        // We need to estimate the cursor location after formatting in order to work out how many group characters, if any, affect the final cursor position
        NSUInteger expectedCursorLocation;
        if (range.location != self.cursorLocation) {
            expectedCursorLocation = range.location + string.length;
        } else {
            expectedCursorLocation = self.cursorLocation + string.length;
        }

        // Set the range according to currency formatting
        self.formattingCharacterCount = 0;
        if ([self.currencyFormatter.positivePrefix isEqualToString:self.currencyFormatter.currencySymbol]) {
            // Add the size of the currency prefix
            self.formattingCharacterCount += self.currencyFormatter.currencySymbol.length;
        }
        
        // Add 1 to the range for each group separator encountered in the formatted text before the expected cursor location
        NSString *temp = textField.text;
        NSRange groupRange = [temp rangeOfString:self.currencyFormatter.groupingSeparator];
        while (groupRange.location != NSNotFound) {
            if (groupRange.location > expectedCursorLocation) {
                break;
            }
            self.formattingCharacterCount += 1;
            temp = [temp substringFromIndex:groupRange.location + groupRange.length];
            groupRange = [temp rangeOfString:self.currencyFormatter.groupingSeparator];
        }
        
        // If the range location is different to the range location we calculated last time, use the range provided to determine cursor position
        if (range.location != self.cursorLocation) {
            // User amended cursor position, so reuse that instead
            self.cursorLocation = expectedCursorLocation;
        } else {
            // Reset cursor position allowing for formatting characters
            self.cursorLocation = self.formattingCharacterCount + self.enteredText.length;
        }
        
        // Apply the cursor to the current location
        [textField setSelectedRange:NSMakeRange(self.cursorLocation, 0)];
        return NO;
    }
    
    // We couldn't make a number out of the entered text by adding the string, so just eat it
    return NO;
}

@end

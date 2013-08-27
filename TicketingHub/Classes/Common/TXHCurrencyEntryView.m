//
//  TXHCurrencyEntryView.m
//  TicketingHub
//
//  Created by Mark on 21/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHCurrencyEntryView.h"

@interface TXHTextEntryView (currencyExtension)

// Expose the underlying textfield property getter method so we can work with it here
- (UITextField *)textField;

@end

@interface TXHCurrencyEntryView ()

// A currency formatter for user facing presentation
@property (strong, nonatomic) NSNumberFormatter *currencyFormatter;

// The cursor location for our textfield after formatting has been applied
@property (assign, nonatomic) NSInteger cursorLocation;

// Count of formatting characters added to the entered text
//@property (assign, nonatomic) NSUInteger formattingCharacterCount;

// A flag indicating that we are updating the amount
// needed to suppress update from textField:shouldChangeCharactersInRange:replacementString: which also updates the amount
@property (assign, nonatomic) BOOL updatingAmountIndirectly;

// A dictionary of formatting information for our currency text
// containing:
//  key         contining
//  Currency    NSRange String
//  Grouping    NSArray of NSRange Strings
//  Decimal     NSRange String
@property (strong, nonatomic) NSDictionary *formattingCharacters;

@end

@implementation TXHCurrencyEntryView

- (void)setupDataContent {
    [super setupDataContent];
    
    UITextField *textField = [self textField];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.textAlignment = NSTextAlignmentRight;
    textField.clearsOnBeginEditing = YES;
    
    // Set the locale to be the default device locale
    self.locale = [NSLocale currentLocale];
    
    // Create a currency formatter (with the default currency).
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    currencyFormatter.formatterBehavior = NSNumberFormatterBehavior10_4;
    currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.currencyFormatter = currencyFormatter;

    self.textField.placeholder = [self formattedAmount];
}

#pragma mark - Property Getter / Setter Methods

- (NSDictionary *)formattingCharacters {
    if (_formattingCharacters == nil) {
        return [NSDictionary dictionary];
    }
    return _formattingCharacters;
}

- (void)setAmount:(NSNumber *)amount {
    _amount = amount;
    NSString *formattedText = [self formattedAmount];
    self.textField.text = formattedText;
    // Keep a record of the formatting
    [self updateFormattingDictionary];
}

- (void)setCurrencyCode:(NSString *)currencyCode {
    _currencyCode = currencyCode;
    
    // Apply this currency to our formatter
    self.currencyFormatter.currencyCode = currencyCode;
}

- (void)setLocale:(NSLocale *)locale {
    _locale = locale;
    self.currencyFormatter.locale = locale;
    
    // If a currency has already been specified, override the locale's currency
    if (self.currencyCode.length > 0) {
        self.currencyFormatter.currencyCode = self.currencyCode;
    }
}

#pragma mark - Private methods

- (void)updateFormattingDictionary {
    NSMutableDictionary *formatting = [NSMutableDictionary dictionary];

    NSString *formattedText = [self formattedAmount];
    
    if (formattedText.length == 0) {
        self.formattingCharacters = formatting;
        return;
    }
    
    // Appropriate currencySymbol can be found via our currency formatter.
    NSString *currencySymbol = self.currencyFormatter.currencySymbol;
    
    // Appropriate grouping separator can be found from the currency formatter
    NSString *groupSeparator = self.currencyFormatter.groupingSeparator;
    
    // Find a location for the currency symbol if it appears in the text
    NSRange range = [formattedText rangeOfString:currencySymbol];
    if (range.location != NSNotFound) {
        // If the currency symbol is not located at the start allow for space padding
        if (range.location > 0) {
            range.length += 1;
            range.location -= 1;
        }
        
        formatting[@"Currency"] = NSStringFromRange(range);
    }
    
    // Look for a decimal separator
    range = [formattedText rangeOfString:self.currencyFormatter.decimalSeparator];
    if (range.location != NSNotFound) {
        formatting[@"Decimal"] = NSStringFromRange(range);
    }

    
    // Check for group separator
    NSMutableArray *groupings = [NSMutableArray array];
    
    NSUInteger offset = 0;
    range = [formattedText rangeOfString:groupSeparator];
    while (range.location != NSNotFound) {
        formattedText = [formattedText substringFromIndex:range.location + 1];
        offset += range.location;
        range.location = offset;
        [groupings addObject:NSStringFromRange(range)];
        range = [formattedText rangeOfString:groupSeparator];
    }
    
    if (groupings.count > 0) {
        formatting[@"Grouping"] = groupings;
    }
    
    self.formattingCharacters = formatting;
}

- (NSString *)formattedAmount {
    return [self.currencyFormatter stringFromNumber:self.amount];
}

#pragma mark - UITextField selected range methods

- (NSRange)selectedRangeForTextField:(UITextField *)textField {
    UITextPosition* beginning = textField.beginningOfDocument;
    
    UITextRange* selectedRange = textField.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [textField offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [textField offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

- (void)applySelectedRange:(NSRange)range toTextField:(UITextField *)textField {
    UITextPosition* beginning = textField.beginningOfDocument;
    
    UITextPosition* startPosition = [textField positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [textField positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [textField textRangeFromPosition:startPosition toPosition:endPosition];
    
    [textField setSelectedTextRange:selectionRange];
}

#pragma mark UITextField delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *text = textField.text;
    
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

    NSString *proposedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // Strip out any formatting characters
    
    NSString *currencySymbol = self.currencyFormatter.currencySymbol;
    
    NSRange deleteRange = [proposedText rangeOfString:currencySymbol];
    if (deleteRange.location != NSNotFound) {
        proposedText = [proposedText stringByReplacingCharactersInRange:deleteRange withString:@""];
    }
    
    NSString *groupSeparator = self.currencyFormatter.groupingSeparator;
    deleteRange = [proposedText rangeOfString:groupSeparator];
    while (deleteRange.location != NSNotFound) {
        proposedText = [proposedText stringByReplacingCharactersInRange:deleteRange withString:@""];
        deleteRange = [proposedText rangeOfString:groupSeparator];
    }
    
    proposedText = [proposedText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    

    // Convert this text into a number
    
    // Switch the currency formatter style temporarily in order to extract a number in the appropriate locale
    self.currencyFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *proposedNumber = [self.currencyFormatter numberFromString:proposedText];
    // Now switch the formatter back to currency style so that text displayed to the user will be presented as a currency
    self.currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.amount = proposedNumber;
    
    self.cursorLocation += (string.length - range.length);
    
    // Reposition the cursor to allow for formatting
    if (self.cursorLocation != range.location) {
        // Check for formatting earlier in the string than the cursor location
        NSString *rangeString = self.formattingCharacters[@"Currency"];
        if (rangeString.length > 0) {
            NSRange currencyRange = NSRangeFromString(rangeString);
            if (currencyRange.location < self.cursorLocation) {
                range.location += currencyRange.location + currencyRange.length;
            }
        }
        // Now check the decimal separator
        rangeString = self.formattingCharacters[@"Decimal"];
        decimalRange = NSRangeFromString(rangeString);
        if (decimalRange.location < self.cursorLocation) {
            range.location += 1;
        }
        
        // Finally check for grouping separators
        NSArray *groupings = self.formattingCharacters[@"Grouping"];
        for (NSString *thisRange in groupings) {
            if (thisRange.length > 0) {
                NSRange groupRange = NSRangeFromString(thisRange);
                if (groupRange.location < self.cursorLocation) {
                    range.location += 1;
                }
            }
        }
        
        // Finally subtract one from the new range
        if (range.location > 0) {
            range.location -= 1;
        }
        
        // Apply the cursor to the current location
        [self applySelectedRange:range toTextField:textField];
    }
    
    return NO;
}

@end

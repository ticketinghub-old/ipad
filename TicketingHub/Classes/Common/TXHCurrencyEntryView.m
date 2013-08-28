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

- (NSDictionary *)buildFormattingDifferencesWith:(NSDictionary *)formatting {
    // A dictionary to return containing keys for added & removed formatting ranges between what is passed in and the current formatting
    NSMutableDictionary *differences = [NSMutableDictionary dictionary];
    
    // Formatting ranges added in current formatting details that were not present in the formatting dictionary passed in
    NSMutableDictionary *formattingAdded = [NSMutableDictionary dictionary];
    
    // Formatting ranges deleted from the current formatting details that were present in the formatting dictionary passed in
    NSMutableDictionary *formattingRemoved = [NSMutableDictionary dictionary];
    
    // Check currency formatting
    NSString *currentRangeString = self.formattingCharacters[@"Currency"];
    NSString *comparedRangeString = formatting[@"Currency"];
    
    // Was currency formatting added
    if ((currentRangeString.length > 0) && (comparedRangeString.length == 0)) {
        formattingAdded[@"Currency"] = currentRangeString;
    }

    // Was currency formatting removed
    if ((currentRangeString.length == 0) && (comparedRangeString.length > 0)) {
        formattingRemoved[@"Currency"] = comparedRangeString;
    }
    
    // Check decimal formatting
    currentRangeString = self.formattingCharacters[@"Decimal"];
    comparedRangeString = formatting[@"Decimal"];
    
    // Was decimal formatting added
    if ((currentRangeString.length > 0) && (comparedRangeString.length == 0)) {
        formattingAdded[@"Decimal"] = currentRangeString;
    }
    
    // Was decimal formatting removed
    if ((currentRangeString.length == 0) && (comparedRangeString.length > 0)) {
        formattingRemoved[@"Decimal"] = comparedRangeString;
    }
    
    // Group details are a little different in that there may be more than one occurrence of the group separator
    NSArray *currentGroups = self.formattingCharacters[@"Grouping"];
    NSArray *comparedGroups = formatting[@"Grouping"];
    
    // Was grouping wholly added
    if ((currentGroups.count > 0) && (comparedGroups.count == 0)) {
        formattingAdded[@"Grouping"] = currentGroups;
    }

    // Was grouping wholly removed
    if ((currentGroups.count == 0) && (comparedGroups.count > 0)) {
        formattingRemoved[@"Grouping"] = comparedGroups;
    }
    
    // Has grouping changed at all
    if ((currentGroups.count > 0) && (comparedGroups.count > 0)) {
        // If there are a different number of entries, we definitely have a change.
        if (currentGroups.count != comparedGroups.count) {
            formattingAdded[@"Grouping"] = currentGroups;
            formattingRemoved[@"Grouping"] = comparedGroups;
        } else {
            // If there are the same number of entries compare each one looking for any changes.  If there are any then add & remmove
            for (int index = 0; index < currentGroups.count; index++) {
                // Check decimal formatting
                currentRangeString = (NSString *)[currentGroups objectAtIndex:index];
                comparedRangeString = (NSString *)[comparedGroups objectAtIndex:index];
                if ([currentRangeString isEqualToString:comparedRangeString] == NO) {
                    formattingAdded[@"Grouping"] = currentGroups;
                    formattingRemoved[@"Grouping"] = comparedGroups;
                    break;
                }
            }
        }
    }
    
    // Set contents of the differences dictionary
    differences[@"added"] = formattingAdded;
    differences[@"removed"] = formattingRemoved;
    
    return differences;
}

#pragma mark UITextField delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // Keep an indication of the current cursor location according to the range passed in.
    // We need this to determine whether any formatting characters added are 'downwind' of the cursor
    NSUInteger originalCursorLocation = range.location;
    
    // Keep a copy of the current formatting for comparison after updating the amount
    NSDictionary *originalFormatting = [self.formattingCharacters copy];

    // Start off with the current textfield contents
    NSString *text = textField.text;
    
    // If the string is equal to group separator then eat it
    if ([string isEqualToString:self.currencyFormatter.groupingSeparator]) {
        return NO;
    }
    
    // If string is equal to decimal separator, disallow if entered text already contains one in a different location
    NSRange decimalRange = [text rangeOfString:self.currencyFormatter.decimalSeparator];
    if ((decimalRange.location != NSNotFound) && ([string isEqualToString:self.currencyFormatter.decimalSeparator])) {
        if (decimalRange.location != range.location) {
            return NO;
        }
        
        // Amend the range to cover replacing the separator
        range.length += self.currencyFormatter.decimalSeparator.length;
    }
    
    // If there is currently nothing entered and we are processing a backspace there is nothing to do
    if ((text.length == 0) && (string.length < 1)) {
        return NO;
    }

    // Go ahead and replace string in the text, generating a proposed replacement
    NSString *proposedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"text:%@ proposed:%@ range:%@ string:%@", textField.text, proposedText, NSStringFromRange(range), string);
    
    // Strip out any formatting characters from the proposed text

    NSString *currencySymbol = self.currencyFormatter.currencySymbol;
    proposedText = [proposedText stringByReplacingOccurrencesOfString:currencySymbol withString:@""];
    
    NSString *groupSeparator = self.currencyFormatter.groupingSeparator;
    proposedText = [proposedText stringByReplacingOccurrencesOfString:groupSeparator withString:@""];

    proposedText = [proposedText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // Convert the resultant text into a number
    
    // Switch the currency formatter style temporarily in order to extract a number in the appropriate locale
    self.currencyFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *proposedNumber = [self.currencyFormatter numberFromString:proposedText];

    // Now switch the formatter back to currency style so that text displayed to the user will be presented as a currency
    self.currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    // Having reset the formatter we can go ahead and assign the number
    self.amount = proposedNumber;
    
    // Formatting will have been updated now, so we can determine what formatting was added or removed by the change to our number
    NSDictionary *formattingChanges = [self buildFormattingDifferencesWith:originalFormatting];
    
    NSDictionary *added = formattingChanges[@"added"];
    NSDictionary *removed = formattingChanges[@"removed"];

    // Update our placeholdor for where we think the cursor ought to be and the range provided
    self.cursorLocation += string.length;
    
    range.location += string.length;
    NSLog(@"inc range by %d to %d", string.length, range.location);
    
    // Reset range length; since we no longer have a selection once 'string' has replaced it
    range.length = 0;

    // If we have removed any formatting move cursor upstream as appropriate
    if (removed.count > 0) {
        NSString *rangeString = removed[@"Currency"];
        if (rangeString.length > 0) {
            NSRange currencyRange = NSRangeFromString(rangeString);
            if (currencyRange.location <= originalCursorLocation) {
                range.location -= currencyRange.location + currencyRange.length;
                NSLog(@"dec range by %d + %d to %d (for currency)", currencyRange.location, currencyRange.length, range.location);
                self.cursorLocation -= currencyRange.location + currencyRange.length;
                NSLog(@"dec cursor by %d + %d to %d (for currency)", currencyRange.location, currencyRange.length, self.cursorLocation);
            }
        }
        
        // Check for grouping separators
        NSArray *groupings = removed[@"Grouping"];
        for (NSString *thisRangeString in groupings) {
            if (thisRangeString.length > 0) {
                NSRange groupRange = NSRangeFromString(thisRangeString);
                if ((groupRange.location <= originalCursorLocation)) {
                    range.location -= 1;
                    NSLog(@"dec range by 1 (for group:%d)", groupRange.location);
                    self.cursorLocation -= 1;
                    NSLog(@"dec cursor by 1 to %d (for group:%d)", self.cursorLocation, groupRange.location);
                }
            }
        }
        
        // Finally check the decimal separator
        rangeString = removed[@"Decimal"];
        if (rangeString.length > 0) {
            decimalRange = NSRangeFromString(rangeString);
            if ((decimalRange.location <= originalCursorLocation)) {
                range.location -= 1;
                NSLog(@"dec range by 1 (for decimal:%d)", decimalRange.location);
                self.cursorLocation -= 1;
                NSLog(@"dec cursor by 1 to %d (for decimal:%d)", self.cursorLocation, decimalRange.location);
            }
        }
    }
    
    // If we have added any formatting move cursor downstream as appropriate
    if (added.count > 0) {
        NSString *rangeString = added[@"Currency"];
        if (rangeString.length > 0) {
            NSRange currencyRange = NSRangeFromString(rangeString);
            if (currencyRange.location <= originalCursorLocation) {
                range.location += currencyRange.location + currencyRange.length;
                NSLog(@"inc range by %d + %d to %d (for currency)", currencyRange.location, currencyRange.length, range.location);
                self.cursorLocation += (currencyRange.location + currencyRange.length);
                NSLog(@"inc cursor by %d + %d to %d (for currency)", currencyRange.location, currencyRange.length, self.cursorLocation);
            }
        }
        
        // Check for grouping separators
        NSArray *groupings = added[@"Grouping"];
        for (NSString *thisRangeString in groupings) {
            if (thisRangeString.length > 0) {
                NSRange groupRange = NSRangeFromString(thisRangeString);
                if ((groupRange.location <= originalCursorLocation)) {
                    range.location += 1;
                    NSLog(@"inc range by 1 (for group:%d)", groupRange.location);
                    self.cursorLocation += 1;
                    NSLog(@"inc cursor by 1 to %d (for group:%d)", self.cursorLocation, groupRange.location);
                }
            }
        }
        
        // Finally check the decimal separator
        rangeString = added[@"Decimal"];
        if (rangeString.length > 0) {
            decimalRange = NSRangeFromString(rangeString);
            if ((decimalRange.location <= originalCursorLocation)) {
                range.location += 1;
                NSLog(@"inc range by 1 (for decimal:%d)", decimalRange.location);
                self.cursorLocation += 1;
                NSLog(@"inc cursor by 1 to %d (for decimal:%d)", self.cursorLocation, decimalRange.location);
            }
        }
    }
    
    
   
    
//    // Is the cursor location aligned with entered data
//    BOOL cursorAligned = (self.cursorLocation == range.location);
//    NSUInteger formattedCharacterCount = 0;
//    
//    // Update our placeholdor for where we think the cursor ought to be
//    self.cursorLocation += string.length;
//    
//    NSLog(@"cursor position:%d range:%@", self.cursorLocation, NSStringFromRange(range));
//    
//    // Reposition the cursor to allow for formatting
//    // Check for formatting earlier in the string than the cursor location
//    NSString *rangeString = self.formattingCharacters[@"Currency"];
//    if (rangeString.length > 0) {
//        NSRange currencyRange = NSRangeFromString(rangeString);
//        if (currencyRange.location < self.cursorLocation) {
//            range.location += currencyRange.location + currencyRange.length;
//            NSLog(@"inc range by %d + %d", currencyRange.location, currencyRange.length);
//        }
//    }
//    // Now check the decimal separator
//    rangeString = self.formattingCharacters[@"Decimal"];
//    decimalRange = NSRangeFromString(rangeString);
//    if (decimalRange.location < self.cursorLocation) {
//        range.location += 1;
//        NSLog(@"inc range by 1");
//    }
//    
//    // Finally check for grouping separators
//    NSArray *groupings = self.formattingCharacters[@"Grouping"];
//    for (NSString *thisRange in groupings) {
//        if (thisRange.length > 0) {
//            NSRange groupRange = NSRangeFromString(thisRange);
//            if (groupRange.location < self.cursorLocation) {
//                range.location += 1;
//                NSLog(@"inc range by 1");
//                formattedCharacterCount +=1;
//            }
//        }
//    }
//
//    // Move the range to allow for the string entered
//    range.location += string.length;
//    NSLog(@"inc range by %d to %d", string.length, range.location);
//
//    // Reset range length; since we no longer have a selection once 'string' has replaced it
//    range.length = 0;
//    
//    // If we have added new formatting characters upstream of the cursor position then recalculate
//    NSString *rangeString = self.formattingCharacters[@"Currency"];
//    if (rangeString.length > 0) {
//        NSRange currencyRange = NSRangeFromString(rangeString);
//        if ((currencyRange.location < range.location) && (currencyRange.location >= originalCursorLocation)) {
//            range.location += currencyRange.location + currencyRange.length;
//            NSLog(@"inc range by %d + %d to %d (for currency)", currencyRange.location, currencyRange.length, range.location);
//        }
//        if (originalCursorLocation <= currencyRange.location) {
//            self.cursorLocation += currencyRange.location + currencyRange.length;
//            NSLog(@"inc cursor by %d + %d to %d (for currency)", currencyRange.location, currencyRange.length, self.cursorLocation);
//        }
//    }
//    // Check for grouping separators
//    NSArray *groupings = self.formattingCharacters[@"Grouping"];
//    for (NSString *thisRange in groupings) {
//        if (thisRange.length > 0) {
//            NSRange groupRange = NSRangeFromString(thisRange);
//            if ((groupRange.location < range.location) && (groupRange.location >= originalCursorLocation)) {
//                range.location += 1;
//                NSLog(@"inc range by 1 (for group:%d)", groupRange.location);
//            }
//            if (originalCursorLocation <= groupRange.location) {
//                self.cursorLocation += 1;
//                NSLog(@"inc cursor by 1 to %d (for group:%d)", self.cursorLocation, groupRange.location);
//            }
//        }
//    }
//    // Finally check the decimal separator
//    rangeString = self.formattingCharacters[@"Decimal"];
//    decimalRange = NSRangeFromString(rangeString);
//    if ((decimalRange.location < range.location) && (decimalRange.location >= originalCursorLocation)) {
//        range.location += 1;
//        NSLog(@"inc range by 1 (for decimal:%d)", decimalRange.location);
//    }
//    if ((decimalRange.location < range.location) && (originalCursorLocation < decimalRange.location)) {
//        self.cursorLocation += 1;
//        NSLog(@"inc cursor by 1 to %d (for decimal:%d)", self.cursorLocation, decimalRange.location);
//    }
//   
//    
//    if (cursorAligned) {
////        self.cursorLocation += formattedCharacterCount;
//        NSLog(@"revised cursor:%d inc:%d", self.cursorLocation, formattedCharacterCount);
//    }
//    
//    NSLog(@"revised range:%@", NSStringFromRange(range));
    
    // Apply the cursor to the current location
    [self applySelectedRange:range toTextField:textField];
    
    NSLog(@"Ending range:%@\n ", NSStringFromRange(range));
    
    return NO;
}

@end

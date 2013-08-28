//
//  TXHCurrencyEntryViewSpec.m
//  TicketingHub
//
//  Created by Mark on 22/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"

#import "TXHCurrencyEntryView.h"

// Cracker to give us access to the currency view's textField
@interface TXHCurrencyEntryView (Testing) <UITextFieldDelegate>

- (NSUInteger)cursorLocation;
- (UITextField *)textField;

@end

SpecBegin(TXHCurrencyEntryView)

__block TXHCurrencyEntryView *_currencyEntryView;
__block NSLocale *_locale;

beforeEach(^{
    _currencyEntryView = [[TXHCurrencyEntryView alloc] initWithFrame:CGRectZero];
});

afterEach(^{
    _currencyEntryView = nil;
});

describe(@"Creating a currency entry view", ^{
    
    it(@"returns a non-nil object", ^{
        expect(_currencyEntryView).toNot.beNil();
    });
});

describe(@"Using the default device locale", ^{
    
    it(@"expects the locale to be set", ^{
        expect(_currencyEntryView.locale).toNot.beNil();
    });
    
    it(@"expects the localeIdentifier to be the same as the default device localeIdentifier", ^{
        NSLocale *locale = [NSLocale currentLocale];
        expect(_currencyEntryView.locale.localeIdentifier).to.equal(locale.localeIdentifier);
    });
    
    it(@"expects text property to be not nil", ^{
        _currencyEntryView.amount = @(0);
        NSString *text = _currencyEntryView.text;
        expect(text).toNot.beNil();
    });
    
});

describe(@"Setting locale to en_GB", ^{
    
    beforeEach(^{
         _locale = [NSLocale localeWithLocaleIdentifier:@"en_GB"];
        _currencyEntryView.locale = _locale;
    });
    
    context(@"with no amount specified", ^{
        it(@"expects the locale to be set", ^{
            expect(_currencyEntryView.locale).toNot.beNil();
        });
        
        it(@"expects the localeIdentifier to be en_GB", ^{
            expect(_currencyEntryView.locale.localeIdentifier).to.equal(@"en_GB");
        });
        
        it(@"expects the currency symbol to be pound symbol", ^{
            NSString *localeSymbol = [_locale objectForKey:NSLocaleCurrencySymbol];
            NSString *symbol = [_currencyEntryView.locale objectForKey:NSLocaleCurrencySymbol];
            expect(symbol).to.equal(localeSymbol);
            expect(localeSymbol).to.equal(@"£");
        });
    });
    
    context(@"with an amount specified", ^{
        
        beforeEach(^{
            _currencyEntryView.amount = @(6543.21);
        });
        
        it(@"expects text property to be not nil", ^{
            NSString *text = _currencyEntryView.text;
            expect(text).toNot.beNil();
        });
        
        it(@"expects the currency symbol to be a prefix", ^{
            NSString *prefix = [_currencyEntryView.text substringToIndex:1];
            NSString *symbol = [_currencyEntryView.locale objectForKey:NSLocaleCurrencySymbol];
            expect(prefix).to.equal(symbol);
        });
        
        context(@"with the cursor positioned at the start", ^{
            
            context(@"with no selection", ^{
                
                beforeEach(^{
                    [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"7"];
                });
                
                it(@"expects the entered value to be added to the beginning", ^{
                    NSNumber *newValue = _currencyEntryView.amount;
                    expect(newValue.doubleValue).to.beCloseToWithin(@(76543.21), @(0.001));
                });
                
                it(@"expects the text to be correctly formatted", ^{
                    expect(_currencyEntryView.textField.text).to.equal(@"£76,543.21");
                });
                
            });
                
            context(@"with one character selected", ^{
                
                beforeEach(^{
                    [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(1, 1) replacementString:@"7"];
                });
                
                it(@"expects the first character to be substituted", ^{
                    NSNumber *newValue = _currencyEntryView.amount;
                    expect(newValue.doubleValue).to.beCloseToWithin(@(7543.21), @(0.001));
                });
                
                it(@"expects the text to be correctly formatted", ^{
                    expect(_currencyEntryView.textField.text).to.equal(@"£7,543.21");
                });
                
            });
            
            context(@"with multiple characters selected", ^{
                
                beforeEach(^{
                    [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(1, 4) replacementString:@"987"];
                });
                
                it(@"expects the selected characters to be substituted", ^{
                    NSNumber *newValue = _currencyEntryView.amount;
                    expect(newValue.doubleValue).to.beCloseToWithin(@(9873.21), @(0.001));
                });
                
                it(@"expects the text to be correctly formatted", ^{
                    expect(_currencyEntryView.textField.text).to.equal(@"£9,873.21");
                });
                
            });
            
        });
    
    });
    
    context(@"typing one character at a time", ^{
        it(@"entering 4 expects the amount the formatted text and the cursor location to be correct", ^{
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"4"];
            expect(_currencyEntryView.amount).to.beCloseToWithin(@(4), @(0.01));
            expect(_currencyEntryView.text).to.equal(@"£4.00");
            expect(_currencyEntryView.cursorLocation).to.equal(2);
        });

        it(@"entering 6 followed by 3 expects the amount formatted text and cursor location to be correct", ^{
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"6"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(2, 0) replacementString:@"3"];
            expect(_currencyEntryView.amount).to.beCloseToWithin(@(63), @(0.01));
            expect(_currencyEntryView.text).to.equal(@"£63.00");
            expect(_currencyEntryView.cursorLocation).to.equal(3);
        });
        
        it(@"entering 2 followed by 7 then 5 expects the amount formatted text and cursor location to be correct", ^{
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"2"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(2, 0) replacementString:@"7"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(3, 0) replacementString:@"5"];
            expect(_currencyEntryView.amount).to.beCloseToWithin(@(275), @(0.01));
            expect(_currencyEntryView.text).to.equal(@"£275.00");
            expect(_currencyEntryView.cursorLocation).to.equal(4);
        });
        
        it(@"entering 9 followed by 1 then 8 then 8 expects the amount the formatted text and cursor location to be correct", ^{
            
            NSRange range = NSMakeRange(0, 0);
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:range replacementString:@"9"];
            range.location = _currencyEntryView.cursorLocation;
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:range replacementString:@"1"];
            range.location = _currencyEntryView.cursorLocation;
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:range replacementString:@"8"];
            range.location = _currencyEntryView.cursorLocation;
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:range replacementString:@"8"];
            expect(_currencyEntryView.amount).to.beCloseToWithin(@(9188), @(0.01));
            expect(_currencyEntryView.text).to.equal(@"£9,188.00");
            expect(_currencyEntryView.cursorLocation).to.equal(6);
        });
        
        it(@"entering 4 followed by 3 then 5 then 8 then . then 2 then 7 expects the amount the formatted text and cursor location to be correct", ^{
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"4"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(2, 0) replacementString:@"3"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(3, 0) replacementString:@"5"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(4, 0) replacementString:@"8"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(6, 0) replacementString:@"."];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(7, 0) replacementString:@"2"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(8, 0) replacementString:@"7"];
            expect(_currencyEntryView.amount).to.beCloseToWithin(@(4358.27), @(0.01));
            expect(_currencyEntryView.text).to.equal(@"£4,358.27");
            expect(_currencyEntryView.cursorLocation).to.equal(9);
        });
        
    });
});

describe(@"Setting locale to el_GR", ^{
    
    beforeEach(^{
        _locale = [NSLocale localeWithLocaleIdentifier:@"el_GR"];
        _currencyEntryView.locale = _locale;
    });
    
    context(@"with no amount specified", ^{
        it(@"expects the locale to be set", ^{
            expect(_currencyEntryView.locale).toNot.beNil();
        });
        
        it(@"expects the localeIdentifier to be el_GR", ^{
            expect(_currencyEntryView.locale.localeIdentifier).to.equal(@"el_GR");
        });
        
        it(@"expects the currency symbol to be euro symbol", ^{
            NSString *localeSymbol = [_locale objectForKey:NSLocaleCurrencySymbol];
            NSString *symbol = [_currencyEntryView.locale objectForKey:NSLocaleCurrencySymbol];
            expect(symbol).to.equal(localeSymbol);
            expect(localeSymbol).to.equal(@"€");
        });
    });
    
    context(@"with an amount specified", ^{
        
        it(@"expects text property to be not nil", ^{
            _currencyEntryView.amount = @(0);
            NSString *text = _currencyEntryView.text;
            expect(text).toNot.beNil();
        });
        
        it(@"expects the currency symbol to be a suffix", ^{
            _currencyEntryView.amount = @(0);
            NSString *text = _currencyEntryView.text;
            NSString *suffix = [text substringFromIndex:text.length - 1];
            NSString *symbol = [_currencyEntryView.locale objectForKey:NSLocaleCurrencySymbol];
            expect(suffix).to.equal(symbol);
        });
        
        context(@"with the cursor positioned at the start", ^{
            
            beforeEach(^{
                // Add an amount with no decimal places then simulate adding some decimal places
                _currencyEntryView.amount = @(6719855);
                [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(9, 0) replacementString:@","];
                [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(10, 0) replacementString:@"3"];
            });

            context(@"with no selection", ^{
                
                beforeEach(^{
                    [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"4"];
                });
                
                it(@"expects the entered value to be added to the beginning", ^{
                    NSNumber *newValue = _currencyEntryView.amount;
                    expect(newValue.doubleValue).to.beCloseToWithin(@(46719855.3), @(0.001));
                });
                
                it(@"expects the text to be correctly formatted", ^{
                    expect(_currencyEntryView.textField.text).to.equal(@"46.719.855,30 €");
                });
                
            });
            
            context(@"with one character selected", ^{
                
                beforeEach(^{
                    [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(0, 1) replacementString:@"7"];
                });
                
                it(@"expects the first character to be substituted", ^{
                    NSNumber *newValue = _currencyEntryView.amount;
                    expect(newValue.doubleValue).to.beCloseToWithin(@(7719855.3), @(0.001));
                });
                
                it(@"expects the text to be correctly formatted", ^{
                    expect(_currencyEntryView.textField.text).to.equal(@"7.719.855,30 €");
                });
                
            });
            
            context(@"with multiple characters selected", ^{
                
                beforeEach(^{
                    [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(1, 4) replacementString:@"987"];
                });
                
                it(@"expects the selected characters to be substituted", ^{
                    NSNumber *newValue = _currencyEntryView.amount;
                    expect(newValue.doubleValue).to.beCloseToWithin(@(6987855.3), @(0.001));
                });
                
                it(@"expects the text to be correctly formatted", ^{
                    expect(_currencyEntryView.textField.text).to.equal(@"6.987.855,30 €");
                });
                
            });
            
        });
        
    });
    
    context(@"typing one character at a time", ^{
        it(@"entering 4 expects the amount and the formatted text to be correct", ^{
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"4"];
            expect(_currencyEntryView.amount).to.beCloseToWithin(@(4), @(0.01));
            expect(_currencyEntryView.text).to.equal(@"4,00 €");
        });
        
        it(@"entering 6 followed by 3 expects the amount and the formatted text to be correct", ^{
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"6"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(2, 0) replacementString:@"3"];
            expect(_currencyEntryView.amount).to.beCloseToWithin(@(6.3), @(0.01));
            expect(_currencyEntryView.text).to.equal(@"6,30 €");
        });
        
        it(@"entering 2 followed by 7 then 5 expects the amount and the formatted text to be correct", ^{
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"2"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(1, 0) replacementString:@"7"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(2, 0) replacementString:@"5"];
            expect(_currencyEntryView.amount).to.beCloseToWithin(@(275), @(0.01));
            expect(_currencyEntryView.text).to.equal(@"275,00 €");
        });
        
        it(@"entering 9 followed by 1 then 8 then 8 expects the amount and the formatted text to be correct", ^{
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"9"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(1, 0) replacementString:@"1"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(2, 0) replacementString:@"8"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(3, 0) replacementString:@"8"];
            expect(_currencyEntryView.amount).to.beCloseToWithin(@(9188), @(0.01));
            expect(_currencyEntryView.text).to.equal(@"9.188,00 €");
        });
        
        it(@"entering 4 followed by 3 then 5 then 8 then . then 2 then 7 expects the amount and the formatted text to be correct", ^{
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"4"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(1, 0) replacementString:@"3"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(2, 0) replacementString:@"5"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(3, 0) replacementString:@"8"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(5, 0) replacementString:@","];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(6, 0) replacementString:@"2"];
            [_currencyEntryView textField:_currencyEntryView.textField shouldChangeCharactersInRange:NSMakeRange(7, 0) replacementString:@"7"];
            expect(_currencyEntryView.amount).to.beCloseToWithin(@(4358.27), @(0.01));
            expect(_currencyEntryView.text).to.equal(@"4.358,27 €");
        });
        
    });
});

SpecEnd

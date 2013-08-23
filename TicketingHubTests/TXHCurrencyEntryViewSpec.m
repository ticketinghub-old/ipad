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
        
        it(@"expects text property to be not nil", ^{
            _currencyEntryView.amount = @(0);
            NSString *text = _currencyEntryView.text;
            expect(text).toNot.beNil();
        });
        
        it(@"expects the currency symbol to be a prefix", ^{
            _currencyEntryView.amount = @(0);
            NSString *prefix = [_currencyEntryView.text substringToIndex:1];
            NSString *symbol = [_currencyEntryView.locale objectForKey:NSLocaleCurrencySymbol];
            expect(prefix).to.equal(symbol);
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
        
    });
    
});

SpecEnd

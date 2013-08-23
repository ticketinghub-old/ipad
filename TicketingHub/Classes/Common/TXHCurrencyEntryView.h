//
//  TXHCurrencyEntryView.h
//  TicketingHub
//
//  Created by Mark on 21/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTextEntryView.h"

@interface TXHCurrencyEntryView : TXHTextEntryView

// The amount entered without any formatting
@property (strong, nonatomic) NSNumber *amount;

// The currency may be different to the currency associated with the locale
@property (strong, nonatomic) NSString *currencyCode;

// The locale to use for formatting (default's to device locale)
@property (strong, nonatomic) NSLocale *locale;

@end

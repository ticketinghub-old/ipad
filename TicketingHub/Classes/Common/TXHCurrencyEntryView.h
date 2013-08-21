//
//  TXHCurrencyEntryView.h
//  TicketingHub
//
//  Created by Mark on 21/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTextEntryView.h"

@interface TXHCurrencyEntryView : TXHTextEntryView

@property (strong, nonatomic) NSString *currencyCode;
@property (strong, nonatomic) NSNumber *amount;

@end

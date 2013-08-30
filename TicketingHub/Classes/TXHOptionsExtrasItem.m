//
//  TXHOptionsExtrasItem.m
//  TicketingHub
//
//  Created by Mark on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHOptionsExtrasItem.h"

@implementation TXHOptionsExtrasItem


- (NSString *)formattedPrice {
  static NSNumberFormatter *formatter = nil;
  if (formatter == nil) {
    formatter = [[NSNumberFormatter alloc] init];
    formatter.currencyCode = self.currencyCode;
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
  }
  return [formatter stringFromNumber:self.price];
}

- (NSString *)description {
  if (self.descriptionArray.count > 0) {
    return self.descriptionArray.description;
  }
  return _description;
}

@end

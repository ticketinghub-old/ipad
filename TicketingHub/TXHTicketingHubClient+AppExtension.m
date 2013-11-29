//
//  TXHTicketingHubClient+AppExtension.m
//  TicketingHub
//
//  Created by Abizer Nasir on 29/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient+AppExtension.h"

@implementation TXHTicketingHubClient (AppExtension)

- (NSArray *)timeSlotsFor:(NSDate *)date {
    return @[];
}

- (void)getTicketOptionsForTimeSlot:(TXHTimeSlot_old *)timeslot completionHandler:(void (^)(id))completion errorHandler:(void (^)(id))error {
    completion(nil);
}


- (NSString *)formatCurrencyValue:(NSNumber *)value {
    // get the current language for the user - will need to adopt kiosk language in due course

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;

    return [formatter stringFromNumber:value];
    
//    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
//    NSLocale *locale;
//    NSString *localeIdentifier = [NSString stringWithFormat:@"%@_%@", language, [self.currentProduct.supplier.country uppercaseString]];
//    NSUInteger index = [[NSLocale availableLocaleIdentifiers] indexOfObject:localeIdentifier];
//    if (index == NSNotFound) {
//        locale = [NSLocale currentLocale];
//    } else {
//        locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
//    }
//    formatter.currencyCode = self.currentProduct.supplier.currency;
//    if (locale) {
//        formatter.locale = locale;
//    }
}


@end

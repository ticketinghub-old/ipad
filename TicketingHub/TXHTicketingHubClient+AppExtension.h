//
//  TXHTicketingHubClient+AppExtension.h
//  TicketingHub
//
//  Created by Abizer Nasir on 29/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//
//  Category for library methods used by the app that aren't yet implemented in the library.
//  This is so that we can get the app built and running.

@class TXHTimeSlot_old;

@interface TXHTicketingHubClient (AppExtension)

- (NSArray *)timeSlotsFor:(NSDate *)date;

- (void)getTicketOptionsForTimeSlot:(TXHTimeSlot_old *)timeslot completionHandler:(void(^)(id))completion errorHandler:(void(^)(id))error;

- (NSString *)formatCurrencyValue:(NSNumber *)value;

@end

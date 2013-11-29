//
//  TXHTicketingHubClient+AppExtension.h
//  TicketingHub
//
//  Created by Abizer Nasir on 29/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <iOS-api/iOS-api.h>
@class TXHTimeSlot_old;

@interface TXHTicketingHubClient (AppExtension)

- (NSArray *)timeSlotsFor:(NSDate *)date;

- (void)getTicketOptionsForTimeSlot:(TXHTimeSlot_old *)timeslot completionHandler:(void(^)(id))completion errorHandler:(void(^)(id))error;

- (NSString *)formatCurrencyValue:(NSNumber *)value;

@end

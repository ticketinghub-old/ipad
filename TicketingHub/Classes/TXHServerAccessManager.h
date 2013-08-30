//
//  TXHServerAccessManager.h
//  TicketingHub
//
//  Created by Mark on 09/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import Foundation;

@class TXHVenue;
@class TXHTimeSlot_old;
@class TXHTicketDetail;

@interface TXHServerAccessManager : NSObject

@property (readonly, nonatomic) TXHVenue  *currentVenue;
@property (strong, nonatomic)   NSArray   *venues;

+ (TXHServerAccessManager *)sharedInstance;

- (NSArray *)timeSlotsFor:(NSDate *)date;

- (void)getTicketOptionsForTimeSlot:(TXHTimeSlot_old *)timeslot completionHandler:(void(^)(TXHTicketDetail *))completion errorHandler:(void(^)(id))error;

- (NSString *)formatCurrencyValue:(NSNumber *)value;

@end

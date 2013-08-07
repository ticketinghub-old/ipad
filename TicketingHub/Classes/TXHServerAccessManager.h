//
//  TXHServerAccessManager.h
//  TicketingHub
//
//  Created by Mark on 09/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import Foundation;

@class TXHVenue;
@class TXHTimeSlot;
@class TXHTicketDetail;

@interface TXHServerAccessManager : NSObject

@property (readonly, nonatomic) TXHVenue  *currentVenue;
@property (strong, nonatomic)   NSArray   *venues;

+ (TXHServerAccessManager *)sharedInstance;

- (void)generateAccessTokenFor:(NSString *)user password:(NSString *)password completion:(void(^)())completion error:(void(^)(id))error;

- (void)getVenuesWithCompletionHandler:(void(^)(NSArray *))completion errorHandler:(void(^)(id))error;

- (NSArray *)timeSlotsFor:(NSDate *)date;

- (void)getTicketOptionsForTimeSlot:(TXHTimeSlot *)timeslot completionHandler:(void(^)(TXHTicketDetail *))completion errorHandler:(void(^)(id))error;

- (NSString *)formatCurrencyValue:(NSNumber *)value;

@end

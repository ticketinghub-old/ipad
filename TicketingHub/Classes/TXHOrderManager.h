//
//  TXHOrderManager.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const TXHOrderDidExpireNotification;

#define TXHORDERMANAGER [TXHOrderManager sharedManager]

@interface TXHOrderManager : NSObject

@property (readonly, nonatomic) TXHOrder *order;
@property (readonly, nonatomic) NSDate *expirationDate;


+ (instancetype)sharedManager;

- (void)resetOrder;
- (NSNumber *)totalOrderPrice;

// helpers

- (TXHTicket *)ticketFromOrderWithID:(NSString *)ticketID;
- (NSDictionary *)customerErrorsForTicketId:(NSString *)ticketId;

// reserving tickets

- (void)reserveTicketsWithTierQuantities:(NSDictionary *)tierQuantities availability:(TXHAvailability *)availability completion:(void(^)(TXHOrder *order, NSError *error))completion;


// fields (customers info)

- (void)fieldsForCurrentOrderWithCompletion:(void(^)(NSDictionary *fields, NSError *error))completion;
- (void)updateOrderWithCustomersInfo:(NSDictionary *)customersInfo completion:(void (^)(TXHOrder *, NSError *))completion;


// upgrades

- (void)upgradesForCurrentOrderWithCompletion:(void(^)(NSDictionary *upgrades, NSError *error))completion;
- (void)updateOrderWithUpgradesInfo:(NSDictionary *)upgradesInfo completion:(void (^)(TXHOrder *order, NSError *error))completion;


@end

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

typedef void (^TXHOrderCompletion)(TXHOrder *order, NSError *error);
typedef void (^TXXDictionaryCompletion)(NSDictionary *dictionary, NSError *error);
typedef void (^TXHArrayCompletion)(NSArray *array, NSError *error);

@interface TXHOrderManager : NSObject

@property (readonly, nonatomic) TXHOrder *order;
@property (readonly, nonatomic) NSDate *expirationDate;


+ (instancetype)sharedManager;

- (void)resetOrder;
- (NSNumber *)totalOrderPrice;

- (void)stopExpirationTimer;

// stpring data
- (void)storeValue:(id)value forKey:(NSString *)key;
- (id)storedValueForKey:(NSString *)key;

// helpers

- (TXHTicket *)ticketFromOrderWithID:(NSString *)ticketID;
- (NSDictionary *)customerErrorsForTicketId:(NSString *)ticketId;

// reserving tickets

- (void)reserveTicketsWithTierQuantities:(NSDictionary *)tierQuantities availability:(TXHAvailability *)availability completion:(TXHOrderCompletion)completion;

// fields (customers info)

- (void)userInfoFieldsForCurrentOrderTicketsWithCompletion:(TXXDictionaryCompletion)completion;
- (void)updateOrderWithCustomersInfo:(NSDictionary *)customersInfo completion:(TXHOrderCompletion)completion;

// upgrades

- (void)upgradesForCurrentOrderWithCompletion:(TXXDictionaryCompletion)completion;
- (void)updateOrderWithUpgradesInfo:(NSDictionary *)upgradesInfo completion:(TXHOrderCompletion)completion;

// owner info

- (void)fieldsForCurrentOrderOwnerWithCompletion:(TXHArrayCompletion)completion;
- (void)updateOrderWithOwnerInfo:(NSDictionary *)customersInfo completion:(TXHOrderCompletion)completion;

// Payment

- (void)updateOrderWithPaymentMethod:(NSString *)paymentMethod completion:(TXHOrderCompletion)completion;

// confirmation

- (void)confirmOrderWithCompletion:(TXHOrderCompletion)completion;

//

- (void)downloadReciptWithWidth:(NSUInteger)width dpi:(NSUInteger)dpi completion:(void(^)(NSURL *url, NSError *error))completion;

- (void)getTicketTemplatesWithCompletion:(TXHArrayCompletion)completion;
- (void)downloadTicketWithTemplate:(TXHTicketTemplate *)template completion:(void(^)(NSURL *url, NSError *error))completion;


@end

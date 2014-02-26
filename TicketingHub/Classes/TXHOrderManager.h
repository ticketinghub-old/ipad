//
//  TXHOrderManager.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 26/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TXHORDERMANAGER [TXHOrderManager sharedManager]

@interface TXHOrderManager : NSObject

@property (readonly, nonatomic) TXHOrder *order;

+ (instancetype)sharedManager;

- (TXHTicket *)ticketFromOrderWithID:(NSString *)ticketID;

// fething data

- (void)reserveTicketsWithTierQuantities:(NSDictionary *)tierQuantities
                            availability:(TXHAvailability *)availability
                              completion:(void(^)(TXHOrder *order, NSError *error))completion;

- (void)fieldsForCurrentOrderWithCompletion:(void(^)(NSDictionary *fields, NSError *error))completion;

- (void)updateOrderWithCustomersInfo:(NSDictionary *)customersInfo completion:(void (^)(TXHOrder *, NSError *))completion;


@end

//
//  TXHPaymentOptionsManager.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 08/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TXHOrderManager;

@interface TXHPaymentOptionsManager : NSObject

- (instancetype)initWithOrderManager:(TXHOrderManager *)orderManger;

- (void)loadOptionsWithCompletion:(void(^)(NSArray *paymentOptions, NSError *error))completion;

@end

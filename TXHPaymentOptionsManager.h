//
//  TXHPaymentOptionsManager.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 08/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TXHOrderManager;
@class TXHPaymentOption;

@interface TXHPaymentOptionsManager : NSObject

@property (readonly, strong, nonatomic) NSArray *paymentOptions;

- (instancetype)initWithOrderManager:(TXHOrderManager *)orderManger;

- (void)loadPaymentOptionsWithCompletion:(void(^)(NSArray *paymentOptions, NSError *error))completion;
- (TXHPaymentOption *)paymentOptionsAtIndex:(NSUInteger)index;

@end

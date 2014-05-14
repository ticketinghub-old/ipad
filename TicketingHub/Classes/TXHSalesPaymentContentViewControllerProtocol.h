//
//  TXHSalesPaymentContentViewControllerProtocol.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 08/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TXHProductsManager;
@class TXHOrderManager;
@class TXHGateway;

@protocol TXHSalesPaymentContentViewControllerProtocol 

@property (readonly, nonatomic, getter = isValid) BOOL valid;

@optional

@property (strong, nonatomic) TXHProductsManager *productManager;
@property (strong, nonatomic) TXHOrderManager    *orderManager;
@property (strong, nonatomic) TXHGateway         *gateway;

@end

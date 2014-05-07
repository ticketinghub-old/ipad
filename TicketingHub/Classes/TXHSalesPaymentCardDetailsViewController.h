//
//  TXHSalesPaymentCardDetailsViewController.h
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHOrderManager;
@class TXHProductsManager;

@interface TXHSalesPaymentCardDetailsViewController : UIViewController

@property (readonly, nonatomic, getter = isValid) BOOL valid;

@property (strong, nonatomic) TXHProductsManager *productManager;
@property (strong, nonatomic) TXHOrderManager    *orderManager;

@property (strong, nonatomic) TXHGateway *gateway;

@end

//
//  TXHSalesPaymentCashDetailsViewController.h
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHProductsManager;
@class TXHOrderManager;

@interface TXHSalesPaymentCashDetailsViewController : UIViewController

@property (strong, nonatomic) TXHProductsManager *productManager;
@property (strong, nonatomic) TXHOrderManager    *orderManager;

@end

//
//  TXHSalesPaymentPaymentDetailsViewController.h
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXHOrderManager;
@class TXHProductsManager;

typedef NS_ENUM(NSInteger, TXHPaymentMethodType)
{
    TXHPaymentMethodTypeCard,
    TXHPaymentMethodTypeCash,
    TXHPaymentMethodTypeCreditCard
};

@interface TXHSalesPaymentPaymentDetailsViewController : UIViewController

@property (strong, nonatomic) TXHProductsManager *productManager;
@property (strong, nonatomic) TXHOrderManager    *orderManager;

- (void)setPaymentMethodType:(TXHPaymentMethodType)paymentType;

@end

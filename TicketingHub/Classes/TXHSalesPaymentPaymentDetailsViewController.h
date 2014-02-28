//
//  TXHSalesPaymentPaymentDetailsViewController.h
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TXHPaymentMethodType)
{
    TXHPaymentMethodTypeCard,
    TXHPaymentMethodTypeCash,
    TXHPaymentMethodTypeCreditCard
};

@interface TXHSalesPaymentPaymentDetailsViewController : UIViewController

- (void)setPaymentMethodType:(TXHPaymentMethodType)paymentType;

@end

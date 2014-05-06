//
//  TXHSalesPaymentPaymentDetailsViewController.m
//  TicketingHub
//
//  Created by Mark on 14/08/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSalesPaymentPaymentDetailsViewController.h"

#import "TXHEmbeddingSegue.h"
#import "TXHSalesPaymentCardDetailsViewController.h"
#import "TXHSalesPaymentCashDetailsViewController.h"
#import "TXHSalesPaymentCreditDetailsViewController.h"

#import <Block-KVO/MTKObserving.h>

@protocol DetailsViewControllerProtocol

@property (readonly, nonatomic, getter = isValid) BOOL valid;

@property (strong, nonatomic) TXHProductsManager *productManager;
@property (strong, nonatomic) TXHOrderManager    *orderManager;

@end


@interface TXHSalesPaymentPaymentDetailsViewController ()

@property (readwrite, nonatomic, getter = isValid) BOOL valid;

@property (weak, nonatomic) IBOutlet UIView *paymentContentView;
@property (weak, nonatomic) UIViewController<DetailsViewControllerProtocol> *currentControler;

@end



@implementation TXHSalesPaymentPaymentDetailsViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isMemberOfClass:[TXHEmbeddingSegue class]])
    {
        TXHEmbeddingSegue *transitionSegue = (TXHEmbeddingSegue *)segue;
        transitionSegue.containerView      = self.paymentContentView;
        transitionSegue.previousController = self.currentControler;
    }
    
    self.currentControler = segue.destinationViewController;
}

- (void)setCurrentControler:(UIViewController<DetailsViewControllerProtocol> *)currentControler
{
    currentControler.productManager = self.productManager;
    currentControler.orderManager   = self.orderManager;
    
    _currentControler = currentControler;
    
    [self map:@keypath(self.currentControler.valid) to:@keypath(self.valid) null:nil];
}

- (void)setPaymentType:(TXHPaymentMethodType)paymentType
{
    _paymentType = paymentType;
    
    NSString *sequeIdentifier = [self segueIdentifierForPaymentType:paymentType];
    
    @try{ [self performSegueWithIdentifier:sequeIdentifier sender:self]; }
    @finally{ }
}

- (NSString *)segueIdentifierForPaymentType:(TXHPaymentMethodType)paymentType
{
    switch (paymentType)
    {
        case TXHPaymentMethodTypeCard:          return @"TXHSalesPaymentCardDetailsViewController";
        case TXHPaymentMethodTypeCash:          return @"TXHSalesPaymentCashDetailsViewController";
        case TXHPaymentMethodTypeCreditCard:    return @"TXHSalesPaymentCreditDetailsViewController";
    }
    
    return nil;
}

@end
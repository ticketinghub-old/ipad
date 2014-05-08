//
//  TXHPaymentOptionsManager.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 08/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPaymentOptionsManager.h"
#import "TXHPaymentOption.h"

#import "TXHOrderManager.h"

static NSString *const kHandpointType = @"handpoint";
static NSString *const kStripeType    = @"stripe";

@interface TXHPaymentOptionsManager ()

@property (strong, nonatomic) TXHOrderManager *orderManager;
@property (strong, nonatomic) NSArray         *options;

@end

@implementation TXHPaymentOptionsManager

- (instancetype)initWithOrderManager:(TXHOrderManager *)orderManger
{
    if (!(self = [super init]))
        return nil;

    _orderManager = orderManger;
    
    return self;
}

- (void)loadOptionsWithCompletion:(void(^)(NSArray *paymentOptions, NSError *error))completion
{
    __weak typeof(self) wself = self;
    [self.orderManager getPaymentGatewaysWithCompletion:^(NSArray *gateways, NSError *error) {
        
        if (error)
        {
            if (completion)
                completion(nil, error);
            return ;
        }
        
        NSArray *prioritizeGateways = [self prioritizeGateways:gateways];
        NSArray *paymentOptions     = [self paymentOptionsFromGateways:prioritizeGateways];
        wself.options = paymentOptions;
        
        if (completion)
            completion(paymentOptions, error);
    }];
}

- (NSArray *)prioritizeGateways:(NSArray *)gateways
{
    NSArray *sortedGateways = [gateways sortedArrayUsingComparator:^NSComparisonResult(TXHGateway *g1, TXHGateway *g2) {
        if ([g1.type isEqualToString:kHandpointType])
            return NSOrderedAscending;
        if ([g2.type isEqualToString:kHandpointType])
            return NSOrderedDescending;
        if ([g1.type isEqualToString:kStripeType])
            return NSOrderedAscending;
        if ([g2.type isEqualToString:kStripeType])
            return NSOrderedDescending;
        return NSOrderedSame;
    }];
    
    return sortedGateways;
}

- (NSArray *)paymentOptionsFromGateways:(NSArray *)gateways
{
    NSMutableArray *paymentOptions = [NSMutableArray array];
    
    for (TXHGateway *gateway in gateways)
    {
        TXHPaymentOption *option = [[TXHPaymentOption alloc] init];
        
        option.gateway         = gateway;
        option.displayName     = [self displayNameForGateway:gateway];
        option.segueIdentifier = [self segueIdentifierForGateway:gateway];
        
        [paymentOptions addObject:option];
    }
    
    [paymentOptions addObject:[self cashOption]];
    
    return [paymentOptions copy];
}

- (TXHPaymentOption *)cashOption
{
    TXHPaymentOption *option = [[TXHPaymentOption alloc] init];

    option.displayName     = NSLocalizedString(@"PAYMENT_OPTION_CASH_TITLE", nil);
    option.segueIdentifier = @"TXHSalesPaymentCashDetailsViewController";

    return option;
}

- (NSString *)displayNameForGateway:(TXHGateway *)gateway
{
    if ([gateway.type isEqualToString:kHandpointType])
    {
        return NSLocalizedString(@"PAYMENT_OPTION_CARD_TITLE", nil);
    }
    
    if ([gateway.type isEqualToString:kStripeType])
    {
        return NSLocalizedString(@"PAYMENT_OPTION_CREDIT_TITLE", nil);
    }
 
    return nil;
}

- (NSString *)segueIdentifierForGateway:(TXHGateway *)gateway
{
    if ([gateway.type isEqualToString:kHandpointType])
    {
        return @"TXHSalesPaymentCardDetailsViewController";
    }
    
    if ([gateway.type isEqualToString:kStripeType])
    {
        return @"TXHSalesPaymentCreditDetailsViewController";
    }
    
    return nil;
}

@end

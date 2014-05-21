//
//  TXHPayment+PKCard.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 19/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPayment+PKCard.h"
#import <PaymentKit/PKCard.h>

@implementation TXHPayment (PKCard)

+ (instancetype)createWithCard:(PKCard *)card cardTrackData:(NSString *)cardTrackData inManagedObjectContext:(NSManagedObjectContext *)moc;
{
    if (!card || !moc)
        return nil;
    
    TXHPayment *payment = [TXHPayment insertInManagedObjectContext:moc];
    
    TXHCard *txhCard = [TXHCard insertInManagedObjectContext:moc];
    txhCard.number       = card.number;
    txhCard.securityCode = card.cvc;
    txhCard.month        = @(card.expMonth);
    txhCard.year         = @(card.expYear);
    txhCard.trackData    = cardTrackData;
    
    payment.card               = txhCard;
    payment.type               = @"card";
    payment.verificationMethod = @"security_code";
    payment.inputType          = @"CNP";

    return payment;
}

@end

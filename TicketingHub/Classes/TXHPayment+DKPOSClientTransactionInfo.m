//
//  TXHPayment+DKPOSClientTransactionInfo.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 07/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPayment+DKPOSClientTransactionInfo.h"
#import "DKPOSClientTransactionInfo.h"

@implementation TXHPayment (DKPOSClientTransactionInfo)

+ (instancetype)createWithTransactionInfo:(DKPOSClientTransactionInfo *)info inManagedObjectContext:(NSManagedObjectContext *)moc
{
    if (!info || !moc)
        return nil;
    
    TXHPayment *payment = [TXHPayment insertInManagedObjectContext:moc];
    
    NSString *deviceSerialNumber = info.userInfo[kDKPOSClientDeviceSerialKey];
    NSString *eFTTransactionID   = info.userInfo[kDKPOSClientTransactionEFTTransactionIDKey];
    
    TXHCard *card = [TXHCard insertInManagedObjectContext:moc];
    card.scheme = info.userInfo[kDKPOSClientTransactionCardIssuerNameKey];
    
    payment.card               = card;
    payment.type               = @"card";
    payment.verificationMethod = info.userInfo[kDKPOSClientTransactionCardVerificationMethodKey];
    payment.inputType          = info.userInfo[kDKPOSClientTransactionCardEntryTypeKey];
    payment.authorization      = info.userInfo[kDKPOSClientTransactionAuthorisationCodeKey];
    payment.reference          = [NSString stringWithFormat:@"%@|%@",deviceSerialNumber, eFTTransactionID];
    
    return payment;
}

@end

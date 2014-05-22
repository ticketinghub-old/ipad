//
//  TXHPayment+DKPOSClientTransactionInfo.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 07/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPayment+DKPOSClientTransactionInfo.h"
#import "DKPOSClientTransactionInfo.h"
#import "DKPOSClientTypes.h"

@implementation TXHPayment (DKPOSClientTransactionInfo)

+ (instancetype)createWithTransactionInfo:(DKPOSClientTransactionInfo *)info inManagedObjectContext:(NSManagedObjectContext *)moc
{
    if (!info || !moc)
        return nil;
    
    TXHPayment *payment = [TXHPayment insertInManagedObjectContext:moc];
    
    NSString *deviceSerialNumber = info.userInfo[kDKPOSClientDeviceSerialKey];
    NSString *eFTTransactionID   = info.userInfo[kDKPOSClientTransactionEFTTransactionIDKey];
    
    NSNumber *issuerID = info.userInfo[kDKPOSClientTransactionIssuerID];
    NSString *cardScheme = [self cardSchemeFor:(DKCardIssuer)[issuerID integerValue]];
    
    TXHCard *card = [TXHCard insertInManagedObjectContext:moc];
    card.scheme = cardScheme;
    
    payment.card               = card;
    payment.type               = @"card";
    payment.verificationMethod = [info.userInfo[kDKPOSClientTransactionCardVerificationMethodKey] lowercaseString];
    payment.inputType          = info.userInfo[kDKPOSClientTransactionCardEntryTypeKey];
    payment.authorization      = info.userInfo[kDKPOSClientTransactionAuthorisationCodeKey];
    payment.reference          = [NSString stringWithFormat:@"%@|%@",deviceSerialNumber, eFTTransactionID];
    
    return payment;
}

+ (NSString *)cardSchemeFor:(DKCardIssuer)issuer
{
    switch (issuer) {
        case DKCardIssuerElectron:      return @"visa_electron";
        case DKCardIssuerMasterCard:    return @"master_card";
        case DKCardIssuerVisa:          return @"visa";
        case DKCardIssuerMaestro:       return @"maestro";
        case DKCardIssuerDinersClub:    return @"diners_club";
        case DKCardIssuerJCB:           return @"jcb";
        case DKCardIssuerAMEX:          return @"amex";
        case DKCardIssuerEurocard:      return @"eurocard";
        case DKCardIssuerDankort:       return @"dankort";
        case DKCardIssuerUnionPay:      return @"union_pay";
        case DKCardIssuerDiscovery:     return @"discover";
        case DKCardIssuerUndefined:
        default:
            return @"unknown";
    }
    
    return nil;
}
@end

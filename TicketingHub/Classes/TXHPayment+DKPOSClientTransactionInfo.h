//
//  TXHPayment+DKPOSClientTransactionInfo.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 07/05/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHPayment.h"

@class DKPOSClientTransactionInfo;

@interface TXHPayment (DKPOSClientTransactionInfo)

+ (instancetype)createWithTransactionInfo:(DKPOSClientTransactionInfo *)info inManagedObjectContext:(NSManagedObjectContext *)moc;

@end

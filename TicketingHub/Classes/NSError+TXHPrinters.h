//
//  NSError+TXHPrinters.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 28/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const TXHPrinterErrorDomain;


typedef NS_ENUM(NSInteger, TXHPrinterErrorCode)
{
    kTXHPrinterFailToOpenPortError = 10000,
    kTXHPrinterOfflineError,
    kTXHPrinterTimedOutError,
    kTXHPrinterArgsInconsistencyError,
    
};

extern NSString * const TXHPrinterErrorDomain;

@interface NSError (TXHPrinters)

+ (NSError *)printerErrorWithCode:(TXHPrinterErrorCode)errorCode;

@end

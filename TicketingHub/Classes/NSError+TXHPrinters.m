//
//  NSError+TXHPrinters.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 28/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "NSError+TXHPrinters.h"

NSString * const TXHPrinterErrorDomain = @"TXHPrinterErrorDomain";

@implementation NSError (TXHPrinters)

+ (NSError *)printerErrorWithCode:(TXHPrinterErrorCode)errorCode
{
    NSDictionary *userInfo = [self userInfoWithCode:errorCode];
    return [NSError errorWithDomain:TXHPrinterErrorDomain
                               code:errorCode
                           userInfo:userInfo];
}

+ (NSDictionary *)userInfoWithCode:(TXHPrinterErrorCode)errorCode
{
    return @{NSLocalizedDescriptionKey:             [self localizedDescriptionForErrorCode:errorCode],
             NSLocalizedFailureReasonErrorKey:      [self localizedFailureReasonErrorCode:errorCode],
             NSLocalizedRecoverySuggestionErrorKey: [self localizedRecoverySuggestionForErrorCode:errorCode]
             };
}

+ (NSString *)localizedDescriptionForErrorCode:(TXHPrinterErrorCode)errorCode
{
    switch (errorCode)
    {
        case kTXHPrinterFailToOpenPortError:
            return NSLocalizedString(@"PRINTER_ERROR_FAIL_TO_OPEN_PORT_DESC", nil);
        case kTXHPrinterOfflineError:
            return NSLocalizedString(@"PRINTER_ERROR_PRINTER_OFFLINE_DESC", nil);
        case kTXHPrinterTimedOutError:
            return NSLocalizedString(@"PRINTER_ERROR_TIMED_OUT_DESC", nil);
    }
    
    return NSLocalizedString(@"PRINTER_ERROR_UNKNOWN_DESC", nil);
}

+ (NSString *)localizedFailureReasonErrorCode:(TXHPrinterErrorCode)errorCode
{
    switch (errorCode)
    {
        case kTXHPrinterFailToOpenPortError:
            return NSLocalizedString(@"PRINTER_ERROR_FAIL_TO_OPEN_PORT_REASON", nil);
        case kTXHPrinterOfflineError:
            return NSLocalizedString(@"PRINTER_ERROR_PRINTER_OFFLINE_REASON", nil);
        case kTXHPrinterTimedOutError:
            return NSLocalizedString(@"PRINTER_ERROR_TIMED_OUT_REASON", nil);
    }

    return NSLocalizedString(@"PRINTER_ERROR_UNKNOWN_REASON", nil);
}

+ (NSString *)localizedRecoverySuggestionForErrorCode:(TXHPrinterErrorCode)errorCode
{
    switch (errorCode)
    {
        case kTXHPrinterFailToOpenPortError:
            return NSLocalizedString(@"PRINTER_ERROR_FAIL_TO_OPEN_PORT_RECOVERY", nil);
        case kTXHPrinterOfflineError:
            return NSLocalizedString(@"PRINTER_ERROR_PRINTER_OFFLINE_RECOVER", nil);
        case kTXHPrinterTimedOutError:
            return NSLocalizedString(@"PRINTER_ERROR_TIMED_OUT_RECOVER", nil);
    }

    return NSLocalizedString(@"PRINTER_ERROR_UNKNOWN_RECOVERY", nil);
}

@end

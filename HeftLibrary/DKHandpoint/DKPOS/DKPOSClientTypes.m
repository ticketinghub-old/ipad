//
//  DKPosClientTypes.h
//  POSTest
//
//  Created by Hjalti Jakobsson on 4.9.2013.
//  Copyright (c) 2013 Hjalti Jakobsson. All rights reserved.
//

#import "DKPOSClientTypes.h"

NSString *const DKMobileErrorDomain = @"DKMobileErrorDomain";

@implementation DKPOSClientTypes 

+ (NSString*)localizedDescriptionForTransactionStatusCode:(DKPOSClientTransactionStatusCode)code
{
    switch(code)
    {
        case DKPOSClientTransactionStatusCodeWaitingForCard:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeWaitingForCard", @"");
            break;
        case DKPOSClientTransactionStatusCodeCardInserted:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeCardInserted", @"");
            break;
        case DKPOSClientTransactionStatusSignatureRequested:
            return NSLocalizedString(@"DKPOSClientTransactionStatusSignatureRequested", @"");
            break;
        case DKPOSClientTransactionStatusCodeApplicationSelection:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeApplicationSelection", @"");
            break;
        case DKPOSClientTransactionStatusCodeApplicationConfirmation:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeApplicationConfirmation", @"");
            break;
        case DKPOSClientTransactionStatusCodeAmountValidation:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeAmountValidation", @"");
            break;
        case DKPOSClientTransactionStatusCodePinInput:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodePinInput", @"");
            break;
        case DKPOSClientTransactionStatusCodeManualCardInput:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeManualCardInput", @"");
            break;
        case DKPOSClientTransactionStatusCodeWaitingCardRemoval:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeWaitingCardRemoval", @"");
            break;
        case DKPOSClientTransactionStatusCodeTipInput:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeTipInput", @"");
            break;
        case DKPOSClientTransactionStatusCodeConnecting:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeConnecting", @"");
            break;
        case DKPOSClientTransactionStatusCodeSending:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeSending", @"");
            break;
        case DKPOSClientTransactionStatusCodeReceiving:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeReceiving", @"");
            break;
        case DKPOSClientTransactionStatusCodeDisconnecting:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeDisconnecting", @"");
            break;
        case DKPOSClientTransactionStatusCodeTransactionApproved:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeTransactionApproved", @"");
            break;
        case DKPOSClientTransactionStatusCodeTransactionProcessed:
            return NSLocalizedString(@"DKPOSClientTransactionStatusCodeTransactionProcessed", @"");
            break;
    }
    
    return nil;
}

+ (NSString*)localizedDescriptionForTransactionErrorStatusCode:(DKPOSClientTransactionError)code
{
    switch(code)
    {
        case DKPOSClientTransactionErrorInvalidData:
            return NSLocalizedString(@"DKPOSClientTransactionErrorInvalidData", @"");
            break;
        case DKPOSClientTransactionErrorProcessingError:
            return NSLocalizedString(@"DKPOSClientTransactionErrorProcessingError", @"");
            break;
        case DKPOSClientTransactionErrorCommandNotAllowed:
            return NSLocalizedString(@"DKPOSClientTransactionErrorCommandNotAllowed", @"");
            break;
        case DKPOSClientTransactionErrorNotInitialized:
            return NSLocalizedString(@"DKPOSClientTransactionErrorNotInitialized", @"");
            break;
        case DKPOSClientTransactionErrorConnectionTimeout:
            return NSLocalizedString(@"DKPOSClientTransactionErrorConnectionTimeout", @"");
            break;
        case DKPOSClientTransactionErrorConnectionFailed:
            return NSLocalizedString(@"DKPOSClientTransactionErrorConnectionFailed", @"");
            break;
        case DKPOSClientTransactionErrorSendingFailed:
            return NSLocalizedString(@"DKPOSClientTransactionErrorSendingFailed", @"");
            break;
        case DKPOSClientTransactionErrorReceivingFailed:
            return NSLocalizedString(@"DKPOSClientTransactionErrorReceivingFailed", @"");
            break;
        case DKPOSClientTransactionErrorNoDataAvailable:
            return NSLocalizedString(@"DKPOSClientTransactionErrorNoDataAvailable", @"");
            break;
        case DKPOSClientTransactionErrorTransactionNotAllowed:
            return NSLocalizedString(@"DKPOSClientTransactionErrorTransactionNotAllowed", @"");
            break;
        case DKPOSClientTransactionErrorUnsupportedCurrency:
            return NSLocalizedString(@"DKPOSClientTransactionErrorUnsupportedCurrency", @"");
            break;
        case DKPOSClientTransactionErrorNoHostAvailable:
            return NSLocalizedString(@"DKPOSClientTransactionErrorNoHostAvailable", @"");
            break;
        case DKPOSClientTransactionErrorCardReaderError:
            return NSLocalizedString(@"DKPOSClientTransactionErrorCardReaderError", @"");
            break;
        case DKPOSClientTransactionErrorCardReadingFailed:
            return NSLocalizedString(@"DKPOSClientTransactionErrorCardReadingFailed", @"");
            break;
        case DKPOSClientTransactionErrorInvalidCard:
            return NSLocalizedString(@"DKPOSClientTransactionErrorInvalidCard", @"");
            break;
        case DKPOSClientTransactionErrorInputTimeout:
            return NSLocalizedString(@"DKPOSClientTransactionErrorInputTimeout", @"");
            break;
        case DKPOSClientTransactionErrorUserCancelled:
            return NSLocalizedString(@"DKPOSClientTransactionErrorUserCancelled", @"");
            break;
        case DKPOSClientTransactionErrorInvalidSignature:
            return NSLocalizedString(@"DKPOSClientTransactionErrorInvalidSignature", @"");
            break;
        case DKPOSClientTransactionErrorSharedSecretInvalid:
            return NSLocalizedString(@"DKPOSClientTransactionErrorSharedSecretInvalid", @"");
            break;
        case DKPOSClientTransactionErrorTransactionUndefined:
            return NSLocalizedString(@"DKPOSClientTransactionErrorTransactionUndefined", @"");
            break;
        case DKPOSClientTransactionErrorTransactionDeclined:
            return NSLocalizedString(@"DKPOSClientTransactionErrorTransactionDeclined", @"");
            break;
        case DKPOSClientTransactionErrorTransactionNotProcessed:
            return NSLocalizedString(@"DKPOSClientTransactionErrorTransactionNotProcessed", @"");
            break;
        case DKPOSClientTransactionErrorTransactionCancelled:
            return NSLocalizedString(@"DKPOSClientTransactionErrorTransactionCancelled", @"");
            break;
        case DKPOSClientTransactionErrorTransactionDeviceReset:
            return NSLocalizedString(@"DKPOSClientTransactionErrorTransactionDeviceReset", @"");
            break;
        case DKPOSCLientTransactionErrorUnknownError:
            return NSLocalizedString(@"DKPOSCLientTransactionErrorUnknownError", @"");
            break;
    }
    
    return nil;
}

@end
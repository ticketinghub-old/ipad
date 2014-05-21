//
//  DKPosClientTypes.h
//  POSTest
//
//  Created by Hjalti Jakobsson on 4.9.2013.
//  Copyright (c) 2013 Hjalti Jakobsson. All rights reserved.
//

extern NSString *const DKMobileErrorDomain;

typedef NS_ENUM(NSInteger, DKPOSClientError)
{
    DKPOSClientErrorNoAccessoryConnected = 1000
};

typedef NS_ENUM(NSInteger, DKPOSClientTransactionError)
{
    DKPOSClientTransactionErrorInvalidData = 3000,
    DKPOSClientTransactionErrorProcessingError, //01
    DKPOSClientTransactionErrorCommandNotAllowed,
    DKPOSClientTransactionErrorNotInitialized,
    DKPOSClientTransactionErrorConnectionTimeout,
    DKPOSClientTransactionErrorConnectionFailed,
    DKPOSClientTransactionErrorSendingFailed,
    DKPOSClientTransactionErrorReceivingFailed,
    DKPOSClientTransactionErrorNoDataAvailable,
    DKPOSClientTransactionErrorTransactionNotAllowed,
    DKPOSClientTransactionErrorUnsupportedCurrency, //10
    DKPOSClientTransactionErrorNoHostAvailable,
    DKPOSClientTransactionErrorCardReaderError,
    DKPOSClientTransactionErrorCardReadingFailed,
    DKPOSClientTransactionErrorInvalidCard,
    DKPOSClientTransactionErrorInputTimeout,
    DKPOSClientTransactionErrorUserCancelled,
    DKPOSClientTransactionErrorInvalidSignature,
    DKPOSClientTransactionErrorSharedSecretInvalid,
    DKPOSClientTransactionErrorTransactionUndefined,
    DKPOSClientTransactionErrorTransactionDeclined, //20
    DKPOSClientTransactionErrorTransactionNotProcessed,
    DKPOSClientTransactionErrorTransactionCancelled,
    DKPOSClientTransactionErrorTransactionDeviceReset,
    DKPOSCLientTransactionErrorUnknownError
};

typedef NS_ENUM(NSInteger, DKPOSClientTransactionStatusCode)
{
    DKPOSClientTransactionStatusCodeWaitingForCard = 2000,
    DKPOSClientTransactionStatusCodeCardInserted,
    DKPOSClientTransactionStatusSignatureRequested,
    DKPOSClientTransactionStatusCodeApplicationSelection,
    DKPOSClientTransactionStatusCodeApplicationConfirmation,
    DKPOSClientTransactionStatusCodeAmountValidation,
    DKPOSClientTransactionStatusCodePinInput,
    DKPOSClientTransactionStatusCodeManualCardInput,
    DKPOSClientTransactionStatusCodeWaitingCardRemoval,
    DKPOSClientTransactionStatusCodeTipInput,
    DKPOSClientTransactionStatusCodeConnecting,
    DKPOSClientTransactionStatusCodeSending,
    DKPOSClientTransactionStatusCodeReceiving,
    DKPOSClientTransactionStatusCodeDisconnecting,
    DKPOSClientTransactionStatusCodeTransactionApproved,
    DKPOSClientTransactionStatusCodeTransactionProcessed
};

typedef NS_ENUM(NSInteger, DKCardIssuer)
{
    DKCardIssuerUndefined = -1,
    DKCardIssuerElectron,
    DKCardIssuerMasterCard,
    DKCardIssuerVisa,
    DKCardIssuerMaestro,
    DKCardIssuerDinersClub,
    DKCardIssuerJCB,
    DKCardIssuerAMEX,
    DKCardIssuerEurocard,
    DKCardIssuerDankort,
    DKCardIssuerUnionPay,
    DKCardIssuerDiscovery
};


@interface DKPOSClientTypes : NSObject

+ (NSString*)localizedDescriptionForTransactionStatusCode:(DKPOSClientTransactionStatusCode)code;
+ (NSString*)localizedDescriptionForTransactionErrorStatusCode:(DKPOSClientTransactionError)code;

@end
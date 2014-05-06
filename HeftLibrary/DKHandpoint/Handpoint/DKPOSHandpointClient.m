//
//  DKPOSHandpointClient.m
//  POSTest
//
//  Created by Hjalti Jakobsson on 3.9.2013.
//  Copyright (c) 2013 Hjalti Jakobsson. All rights reserved.
//

#import "DKPOSHandpointClient.h"
#import "DKHandpointTypes.h"
#import "TXHConfiguration.h"
//#import "NSString+DKExtensions.h"


@interface DKPOSHandpointClient()
@property (nonatomic, strong) id<HeftClient> handpointClient;
@property (nonatomic, strong) NSData *secret;
@end

@implementation DKPOSHandpointClient

+ (instancetype)sharedClient
{
    static DKPOSHandpointClient *_sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[DKPOSHandpointClient alloc] init];
    });
    return _sharedClient;
}

- (void)initialize
{
    [[HeftManager sharedManager] setDelegate:self];
    
    if([self isAccessoryConnected] && ![self isConnected])
    {
        [self connectToAvailableDevice];
    }
}

- (void)connectToAvailableDevice
{
    NSArray *connectedDevices = [[HeftManager sharedManager] devicesCopy];
    
    if ([connectedDevices count] == 1)
    {
        [self connectToDevice:[connectedDevices firstObject]];
    }
    else if ([connectedDevices count] > 1)
    {
        // edge case
        // TODO: show selection list or set previously stored selected device (but no info for now)
    }
}

- (BOOL)saleWithAmount:(NSUInteger)amount currency:(NSString*)currency cardPresent:(BOOL)cardPresent reference:(NSString*)reference error:(NSError**)error
{
    if(!self.handpointClient || ![self isAccessoryConnected])
    {
        *error = [NSError errorWithDomain:DKMobileErrorDomain code:DKPOSClientErrorNoAccessoryConnected userInfo:nil];
        
        return NO;
    }
    
    //Silly Handpoint library crashes when passed nil as a reference
    
    if(reference)
        [self.handpointClient saleWithAmount:amount currency:currency cardholder:cardPresent reference:reference];
    else
        [self.handpointClient saleWithAmount:amount currency:currency cardholder:cardPresent];
    
    return YES;
}

- (BOOL)accessoryLinkActive
{
    return [self isAccessoryConnected];
}

- (BOOL)isConnected
{
    return ([self isAccessoryConnected] && self.handpointClient);
}

- (BOOL)isAccessoryConnected
{
    NSString* eaProtocol = @"com.datecs.pinpad";
    NSArray *accessories = [[EAAccessoryManager sharedAccessoryManager] connectedAccessories];
    
    if([accessories count] > 0)
    {
        for (EAAccessory* accessory in accessories)
        {
            BOOL isPinpad = [accessory.protocolStrings containsObject:eaProtocol];
        
            if (!isPinpad)
                continue;
            
            return isPinpad;
        }
    }
    
    return NO; 
}

- (void)cancelTransaction
{
    [self.handpointClient cancel];
}

- (BOOL)refundAmount:(NSUInteger)amount currency:(NSString*)currency cardPresent:(BOOL)cardPresent reference:(NSString*)reference error:(NSError**)error
{
    return NO; // GRUMPY LOL :)
}

- (void)setSharedSecret:(NSData*)secret
{
    self.secret = secret;
}

- (void)signatureAccepted
{
    [self.handpointClient acceptSignature:YES];
}

#pragma mark - Handpoint Helpers

- (void)connectToDevice:(HeftRemoteDevice*)device
{
	self.handpointClient = nil;
	[[HeftManager sharedManager] clientForDevice:device sharedSecret:[self deviceSecretData] delegate:self];
}

- (BOOL)isConfigured
{
    return ([self deviceSecretData] != nil);
}

- (NSData*)deviceSecretData
{
    return self.secret;
}

- (NSError*)errorWithStatusCode:(NSUInteger)statusCode info:(id)info
{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [DKPOSClientTypes localizedDescriptionForTransactionErrorStatusCode:statusCode], @"object": info};
    
    return [NSError errorWithDomain:DKMobileErrorDomain code:statusCode userInfo:userInfo];
}

#pragma mark - HeftDiscovery Delegate

//This doesn't do anything for native bluetooth but we need to implement it

- (void)hasSources
{
}

//This doesn't do anything for native bluetooth but we need to implement it

- (void)noSources
{
}

//This doesn't do anything for native bluetooth but we need to implement it

- (void)didDiscoverDevice:(HeftRemoteDevice*)newDevice
{
}

//This doesn't do anything for native bluetooth but we need to implement it

- (void)didDiscoverFinished
{
}

- (void)didFindAccessoryDevice:(HeftRemoteDevice*)newDevice
{
    if (!self.isConnected)
        [self connectToDevice:newDevice];
}

- (void)didLostAccessoryDevice:(HeftRemoteDevice*)oldDevice
{
    self.handpointClient = nil;
    
    if([self.delegate respondsToSelector:@selector(posClientDidDisconnectDevice)])
        [self.delegate posClientDidDisconnectDevice];
}

#pragma mark - HeftStatusReport delegate

- (void)didConnect:(id<HeftClient>)client
{
    self.handpointClient = client;
    
    if(self.handpointClient && [self.delegate respondsToSelector:@selector(posClientDidConnectDevice)])
        [self.delegate posClientDidConnectDevice];
}

- (void)responseScannerEvent:(id<ScannerEventResponseInfo>)info
{

}
- (void)responseEnableScanner:(id<EnableScannerResponseInfo>)info
{

}

- (void)responseStatus:(id<ResponseInfo>)info
{
    //This is not really an XML document, it's a dictionary :o
    NSDictionary *mappedInfo = [self mappedInfoDictionary:info.xml];
    
    switch(info.statusCode)
    {
        case EFT_PP_STATUS_INVALID_DATA:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorInvalidData info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_PROCESSING_ERROR:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorProcessingError info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_COMMAND_NOT_ALLOWED:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorCommandNotAllowed info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_NOT_INITIALISED:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorNotInitialized info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_CONNECT_TIMEOUT:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorConnectionTimeout info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_CONNECT_ERROR:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorConnectionFailed info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_SENDING_ERROR:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorSendingFailed info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_RECEIVEING_ERROR:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorReceivingFailed info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_NO_DATA_AVAILABLE:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorNoDataAvailable info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_TRANS_NOT_ALLOWED:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorTransactionNotAllowed info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_UNSUPPORTED_CURRENCY:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorUnsupportedCurrency info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_NO_HOST_AVAILABLE:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorNoHostAvailable info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_CARD_READER_ERROR:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorCardReaderError info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_CARD_READING_FAILED:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorCardReadingFailed info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_INVALID_CARD:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorInvalidCard info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_INPUT_TIMEOUT:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorInputTimeout info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_USER_CANCELLED:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorUserCancelled info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_INVALID_SIGNATURE:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorInvalidSignature info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_SHARED_SECRET_INVALID:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorSharedSecretInvalid info:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_WAITING_CARD:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionStatusChanged:)])
                [self.delegate posClient:self transactionStatusChanged:[DKPOSClientTransactionInfo infoWithStatusCode:DKPOSClientTransactionStatusCodeWaitingForCard userInfo:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_CARD_INSERTED:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionStatusChanged:)])
                [self.delegate posClient:self transactionStatusChanged:[DKPOSClientTransactionInfo infoWithStatusCode:DKPOSClientTransactionStatusCodeCardInserted userInfo:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_APPLICATION_SELECTION:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionStatusChanged:[DKPOSClientTransactionInfo infoWithStatusCode:DKPOSClientTransactionStatusCodeApplicationSelection userInfo:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_APPLICATION_CONFIRMATION:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionStatusChanged:[DKPOSClientTransactionInfo infoWithStatusCode:DKPOSClientTransactionStatusCodeApplicationConfirmation userInfo:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_AMOUNT_VALIDATION:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionStatusChanged:[DKPOSClientTransactionInfo infoWithStatusCode:DKPOSClientTransactionStatusCodeAmountValidation userInfo:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_PIN_INPUT:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionStatusChanged:[DKPOSClientTransactionInfo infoWithStatusCode:DKPOSClientTransactionStatusCodePinInput userInfo:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_MANUAL_CARD_INPUT:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionStatusChanged:[DKPOSClientTransactionInfo infoWithStatusCode:DKPOSClientTransactionStatusCodeManualCardInput userInfo:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_WAITING_CARD_REMOVAL:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionStatusChanged:[DKPOSClientTransactionInfo infoWithStatusCode:DKPOSClientTransactionStatusCodeWaitingCardRemoval userInfo:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_TIP_INPUT:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionStatusChanged:[DKPOSClientTransactionInfo infoWithStatusCode:DKPOSClientTransactionStatusCodeTipInput userInfo:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_CONNECTING:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionStatusChanged:[DKPOSClientTransactionInfo infoWithStatusCode:DKPOSClientTransactionStatusCodeConnecting userInfo:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_SENDING:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionStatusChanged:[DKPOSClientTransactionInfo infoWithStatusCode:DKPOSClientTransactionStatusCodeSending userInfo:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_RECEIVEING:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionStatusChanged:[DKPOSClientTransactionInfo infoWithStatusCode:DKPOSClientTransactionStatusCodeReceiving userInfo:mappedInfo]];
            
            break;
        }
        case EFT_PP_STATUS_DISCONNECTING:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionStatusChanged:[DKPOSClientTransactionInfo infoWithStatusCode:DKPOSClientTransactionStatusCodeDisconnecting userInfo:mappedInfo]];
            
            break;
        }
        default:
            break;
            
    }
}

- (void)responseError:(id<ResponseInfo>)info
{    
    if([self.delegate respondsToSelector:@selector(posClient:deviceConnectionError:)])
        [self.delegate posClient:self deviceConnectionError:nil];
}

- (void)responseFinanceStatus:(id<FinanceResponseInfo>)info
{
    
    DLog(@"%@",info.xml);
    DLog(@"%@",info.status);
    DLog(@"%d",info.statusCode);
    
    DLog(@"%ld",(long)info.authorisedAmount);
    DLog(@"%@",info.transactionId);
    DLog(@"%@",info.customerReceipt);
    
    DLog(@"%@",info.customerReceipt);
    DLog(@"%@",info.merchantReceipt);
    
    //This is not really an XML document, it's a dictionary :o
    NSDictionary *mappedInfo = [self mappedInfoDictionary:info.xml];
    
    switch(info.statusCode)
    {
        case EFT_TRANS_APPROVED:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFinishedWithInfo:)])
                [self.delegate posClient:self transactionFinishedWithInfo:[DKPOSClientTransactionInfo infoWithStatusCode:DKPOSClientTransactionStatusCodeTransactionApproved userInfo:mappedInfo]];
            
            break;
        }
        case EFT_TRANS_CANCELLED:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorTransactionCancelled info:mappedInfo]];
            
            break;
        }
        case EFT_TRANS_DECLINED:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorTransactionDeclined info:mappedInfo]];
            
            break;
        }
        case EFT_TRANS_UNDEFINED:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorTransactionUndefined info:mappedInfo]];
            
            break;
        }
        case EFT_TRANS_PROCESSED:
        {

        }
        case EFT_TRANS_NOT_PROCESSED:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorTransactionNotProcessed info:mappedInfo]];
            
            break;
        }
        case EFT_TRANS_USER_CANCELLED:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorTransactionCancelled info:mappedInfo]];
            
            break;
        }
        case EFT_TRANS_INPUT_TIMEOUT:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorInputTimeout info:mappedInfo]];
            
            break;
        }
        case EFT_TRANS_DEVICE_RESET_MASK:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorTransactionDeviceReset info:mappedInfo]];
            
            break;
        }
        case EFT_TRANS_CARD_READING_FAILED:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSClientTransactionErrorCardReadingFailed info:mappedInfo]];
            
            break;
        }
        default:
        {
            if([self.delegate respondsToSelector:@selector(posClient:transactionFailedWithError:)])
                [self.delegate posClient:self transactionFailedWithError:[self errorWithStatusCode:DKPOSCLientTransactionErrorUnknownError info:mappedInfo]];
            
            break;
        }
    }
}

- (void)responseLogInfo:(id<LogInfo>)info
{
}

- (void)requestSignature:(NSString *)receipt
{
    if([self.delegate respondsToSelector:@selector(posClient:transactionSignatureRequested:)])
        [self.delegate posClient:self transactionSignatureRequested:[DKPOSClientTransactionInfo infoWithStatusCode:DKPOSClientTransactionStatusSignatureRequested userInfo:receipt]];
}

- (void)cancelSignature
{

}

#pragma mark - Helpers

- (DKCardIssuer)cardIssuerFromInfo:(id<NSObject>)info
{    
    if([info isKindOfClass:[NSDictionary class]])
    {
        NSString *schemeName = [[(NSDictionary*)info valueForKey:kDKHandpointTransactionCardIssuerNameKey] lowercaseString];
        
        if([schemeName rangeOfString:@"electron"].location != NSNotFound)
            return DKCardIssuerElectron;
        else if([schemeName rangeOfString:@"mastercard"].location != NSNotFound)
            return DKCardIssuerMasterCard;
        else if([schemeName rangeOfString:@"visa"].location != NSNotFound)
            return DKCardIssuerVisa;
        else if([schemeName rangeOfString:@"maestro"].location != NSNotFound)
            return DKCardIssuerMaestro;
        else if([schemeName rangeOfString:@"diners"].location != NSNotFound)
            return DKCardIssuerDinersClub;
        else if([schemeName rangeOfString:@"jcb"].location != NSNotFound)
            return DKCardIssuerJCB;
        else if([schemeName rangeOfString:@"amex"].location != NSNotFound)
            return DKCardIssuerAMEX;
        else if([schemeName rangeOfString:@"eurocard"].location != NSNotFound)
            return DKCardIssuerEurocard;
        else if([schemeName rangeOfString:@"dankort"].location != NSNotFound)
            return DKCardIssuerDankort;
        else if([schemeName rangeOfString:@"union"].location != NSNotFound)
            return DKCardIssuerUnionPay;
        else if([schemeName rangeOfString:@"discovery"].location != NSNotFound)
            return DKCardIssuerDiscovery;
    }
    
    return DKCardIssuerUndefined;
}

- (NSDictionary*)mappedInfoDictionary:(id<NSObject>)info
{
    if([info isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        
        if(info[kDKHandpointDeviceSerialKey])
            result[kDKPOSClientDeviceSerialKey] = info[kDKHandpointDeviceSerialKey];
        
        if(info[kDKHandpointTransactionAuthorisationCodeKey])
            result[kDKPOSClientTransactionAuthorisationCodeKey] = info[kDKHandpointTransactionAuthorisationCodeKey];
        
        if(info[kDKHandpointTransactionCardIssuerNameKey])
        {
            result[kDKPOSClientTransactionIssuerID] = @([self cardIssuerFromInfo:info]);
            result[kDKPOSClientTransactionCardIssuerNameKey] = info[kDKHandpointTransactionCardIssuerNameKey];
        }
        
        if(info[kDKHandppointTransactionIDKey])
            result[kDKPOSClientTransactionIDKey] = info[kDKHandppointTransactionIDKey];
        
        return result;
    }
    
    return nil;
}


@end

//
//  DKPOSClient.h
//  POSTest
//
//  Created by Hjalti Jakobsson on 3.9.2013.
//  Copyright (c) 2013 Hjalti Jakobsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKPOSClientTransactionInfo.h"
#import "DKPOSClientTypes.h"

@protocol DKPOSClient;

@protocol DKPOSClientDelegate <NSObject>

@optional

- (void)posClientDidConnectDevice;
- (void)posClientDidDisconnectDevice;

@required

- (void)posClient:(NSObject<DKPOSClient>*)client transactionFinishedWithInfo:(DKPOSClientTransactionInfo*)info;
- (void)posClient:(NSObject<DKPOSClient>*)client transactionFailedWithError:(NSError*)error;
- (void)posClient:(NSObject<DKPOSClient>*)client transactionStatusChanged:(DKPOSClientTransactionInfo*)info;
- (void)posClient:(NSObject<DKPOSClient>*)client transactionSignatureRequested:(DKPOSClientTransactionInfo*)info;
- (void)posClient:(NSObject<DKPOSClient>*)client deviceConnectionError:(NSError*)error;


@end

@protocol DKPOSClient <NSObject>

- (BOOL)isConnected;
- (BOOL)saleWithAmount:(NSUInteger)amount currency:(NSString*)currency cardPresent:(BOOL)cardPresent reference:(NSString*)reference error:(NSError**)error;
- (BOOL)refundAmount:(NSUInteger)amount currency:(NSString*)currency cardPresent:(BOOL)cardPresent reference:(NSString*)reference error:(NSError**)error;
- (void)initialize;
- (void)signatureAccepted;
- (void)setSharedSecret:(NSData*)secret;
- (void)cancelTransaction;
- (BOOL)isConfigured;

@optional

+ (BOOL)storeSharedSecretFromFile:(NSURL *)url;
- (BOOL)accessoryLinkActive;

@property (nonatomic, weak) NSObject<DKPOSClientDelegate>* delegate;

@end

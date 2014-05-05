//
//  DKPOSClientTransactionInfo.h
//  POSTest
//
//  Created by Hjalti Jakobsson on 3.9.2013.
//  Copyright (c) 2013 Hjalti Jakobsson. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kDKPOSClientTransactionIDKey;
extern NSString *const kDKPOSClientDeviceSerialKey;
extern NSString *const kDKPOSClientTransactionAuthorisationCodeKey;
extern NSString *const kDKPOSClientTransactionCardIssuerNameKey;
extern NSString *const kDKPOSClientTransactionIssuerID;

@interface DKPOSClientTransactionInfo : NSObject

@property (nonatomic, assign) NSUInteger statusCode;
@property (nonatomic, assign) id userInfo;

+ (instancetype)infoWithStatusCode:(NSUInteger)statusCode userInfo:(id)userInfo;
- (instancetype)initWithStatusCode:(NSUInteger)statusCode userInfo:(id)userInfo;
- (NSString*)localizedStatusDescription;

@end

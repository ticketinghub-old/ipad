//
//  DKPOSClientTransactionInfo.m
//  POSTest
//
//  Created by Hjalti Jakobsson on 3.9.2013.
//  Copyright (c) 2013 Hjalti Jakobsson. All rights reserved.
//

#import "DKPOSClientTransactionInfo.h"
#import "DKPOSClientTypes.h"

NSString *const kDKPOSClientTransactionIDKey = @"DKPOSClientTransactionIDKey";
NSString *const kDKPOSClientDeviceSerialKey = @"DKPOSClientDeviceSerialKey";
NSString *const kDKPOSClientTransactionAuthorisationCodeKey = @"DKPOSClientTransactionAuthorisationCodeKey";
NSString *const kDKPOSClientTransactionCardIssuerNameKey = @"DKPOSClientTransactionCardSchemeNameKey";
NSString *const kDKPOSClientTransactionIssuerID = @"kDKPOSClientTransactionIssuerID";

@implementation DKPOSClientTransactionInfo

+ (instancetype)infoWithStatusCode:(NSUInteger)statusCode userInfo:(id)userInfo
{
    return [[[self class] alloc] initWithStatusCode:statusCode userInfo:userInfo];
}

- (instancetype)initWithStatusCode:(NSUInteger)statusCode userInfo:(id)userInfo
{
    if(self = [super init])
    {
        self.statusCode = statusCode;
        self.userInfo = userInfo;
    }
    
    return self;
}

- (NSString*)localizedStatusDescription
{
    return [DKPOSClientTypes localizedDescriptionForTransactionStatusCode:self.statusCode];
}

- (id)valueForUndefinedKey:(NSString*)key
{
    return [self.userInfo valueForKey:key];
}

@end

//
//  LoginAuthorisation.h
//  TicketingHub
//
//  Created by Mark Brindle on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AUTH_MODE_VERIFY    @"verify"
#define AUTH_MODE_LOGIN     @"login"
#define AUTH_MODE_REFRESH   @"refresh"
#define AUTH_MODE_MIXPANEL  @"mixpanel"

@interface LoginAuthorisation : NSObject

@property (nonatomic, strong)   NSString  *ticketingHubAuthorisation;
@property (nonatomic, strong)   NSString  *ticketingHubRedirect;
@property (nonatomic, strong)   NSString  *ticketingHubManagement;
@property (nonatomic, strong)   NSString  *ticketingHubData;

@property (nonatomic, readonly) NSString  *accessToken;
@property (nonatomic, readonly) NSString  *refreshToken;
@property (nonatomic, readonly) NSUUID    *identityToken;

@property (nonatomic, readonly) NSString  *errorString;

- (void)validateUser:(NSString *)user withPassword:(NSString *)password;
- (void)verifyToken:(NSString *)token;

- (void)verifyMixPanel:(NSString *)token;

@end

//
//  LoginAuthorisation.h
//  TicketingHub
//
//  Created by Mark Brindle on 08/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginAuthorisation : NSObject

@property (nonatomic, strong)   NSString  *ticketingHubAuthorisation;
@property (nonatomic, strong)   NSString  *ticketingHubRedirect;

@property (nonatomic, strong)   NSString  *ticketingHubAPI;

@property (nonatomic, readonly) NSString  *accessToken;
@property (nonatomic, readonly) NSString  *refreshToken;

@property (nonatomic, readonly) NSString  *errorString;

+ (NSString *)apiEndPoint;

@end

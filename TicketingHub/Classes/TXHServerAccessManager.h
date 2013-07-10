//
//  TXHServerAccessManager.h
//  TicketingHub
//
//  Created by Mark on 09/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHServerAccessManager : NSObject

@property (strong, nonatomic) NSArray *venues;

+ (TXHServerAccessManager *)sharedInstance;

- (void)getVenuesForAccessToken;

- (void)generateAccessTokenFor:(NSString *)user password:(NSString *)password;

@end

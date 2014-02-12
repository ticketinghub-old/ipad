//
//  TXHTicketingHubManager.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 12/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iOS-api/TXHTicketingHubClient.h>

#define TXHTICKETINHGUBCLIENT [[TXHTicketingHubManager sharedManager] client]

@interface TXHTicketingHubManager : NSObject

@property (nonatomic, readonly) TXHTicketingHubClient *client;

+ (TXHTicketingHubManager *)sharedManager;
+ (void)clearLocalData;

@end

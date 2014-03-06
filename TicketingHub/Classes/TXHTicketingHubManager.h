//
//  TXHTicketingHubManager.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 12/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

/*
 
 Creates, configures and provides access to API Client
 Responsible for clearing out local data store
 
 */

#import <Foundation/Foundation.h>

#define TXHTICKETINHGUBCLIENT [[TXHTicketingHubManager sharedManager] client]

@interface TXHTicketingHubManager : NSObject

@property (nonatomic, readonly) TXHTicketingHubClient *client;

+ (TXHTicketingHubManager *)sharedManager;

+ (void)clearLocalData;

@end

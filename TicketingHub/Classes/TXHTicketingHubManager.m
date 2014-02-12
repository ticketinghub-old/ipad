//
//  TXHTicketingHubManager.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 12/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubManager.h"

@interface TXHTicketingHubManager ()

@property (nonatomic, strong) TXHTicketingHubClient *client;

@end


@implementation TXHTicketingHubManager

// TODO: could be done better

static TXHTicketingHubManager * _sharedManager;

+ (TXHTicketingHubManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[TXHTicketingHubManager alloc] init];
        [self setupDefaultClient];
    });
    
    return _sharedManager;
}

+ (void)clearLocalData
{
    [[self class] txh_resetDefaultStoreURL];

    if (_sharedManager)
    {
        // if there is a manager set up recreate client
        [self setupDefaultClient];
    }
}

+ (void)setupDefaultClient
{
    TXHTicketingHubClient *client = [[TXHTicketingHubClient alloc] initWithStoreURL:[[self class] txh_defaultStoreURL]];
    client.showNetworkActivityIndicatorAutomatically = YES;
    
    _sharedManager.client = client;
}



+ (void)txh_resetDefaultStoreURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *storeURL = [self txh_defaultStoreURL];
    if (![storeURL checkResourceIsReachableAndReturnError:nil]) {
        return;
    }
    
    NSError *error;
    ZAssert([fileManager removeItemAtURL:[self txh_defaultStoreURL] error:&error], @"Cannot remove store url because: %@", error);
}

+ (NSURL *)txh_defaultStoreURL
{
    static NSURL *storeURL = nil;
    if (!storeURL) {
        NSURL *documentDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        storeURL = [documentDirectoryURL URLByAppendingPathComponent:@"TicktingHub.sqlite"];
    }
    
    return storeURL;
}

@end

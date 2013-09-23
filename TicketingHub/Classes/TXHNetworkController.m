//
//  TXHNetworkController.m
//  TicketingHub
//
//  Created by Abizer Nasir on 23/09/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHNetworkController.h"

#import "TXHTicketingHubClient.h"

@interface TXHNetworkController ()

@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) TXHTicketingHubClient *ticketingHubClient;

@end

@implementation TXHNetworkController

#pragma mark - Set up and tear down.

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc {
    if (!(self = [super init])) {
        return nil; // Bail!
    }

    _moc = moc;

    _ticketingHubClient = [TXHTicketingHubClient sharedClient];
    _ticketingHubClient.showActivityIndicatorAutomatically = YES;

    return self;
}

- (id)init {
    NSAssert(NO, @"Use the initWithManagedObjectContext: initialiser");
    return nil;
}

@end

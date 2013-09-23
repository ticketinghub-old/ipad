//
//  TXHNetworkController.h
//  TicketingHub
//
//  Created by Abizer Nasir on 23/09/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import Foundation;

@class TXHUserMO;

extern NSString * const TXHNetworkControllerErrorDomain;

typedef NS_ENUM(NSInteger, TXHNetworkControllerError) {
    TXHNetworkControllerErrorNoVenues,
};

@interface TXHNetworkController : NSObject

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc __attribute__((nonnull));

- (TXHUserMO *)currentUserInManagedObjectContext:(NSManagedObjectContext *)moc __attribute__((nonnull));

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(NSError *))completionBlock __attribute__((nonnull));

- (void)fetchVenuesForCurrentUserWithCompletion:(void(^)(NSError *))completionBlock __attribute__((nonnull));

@end

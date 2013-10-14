//
//  DataController.h
//  TicketingHub
//
//  Created by Abizer Nasir on 23/09/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

@import Foundation;

@class TXHUserMO;

extern NSString * const DataControllerErrorDomain;

typedef NS_ENUM(NSInteger, DataControllerError) {
    DataControllerErrorNoVenues,
};

@interface DataController : NSObject

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc __attribute__((nonnull));

- (TXHUserMO *)currentUserInManagedObjectContext:(NSManagedObjectContext *)moc __attribute__((nonnull));

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(NSError *))completionBlock __attribute__((nonnull));

- (void)fetchVenuesForCurrentUserWithCompletion:(void(^)(NSError *))completionBlock __attribute__((nonnull));

@end

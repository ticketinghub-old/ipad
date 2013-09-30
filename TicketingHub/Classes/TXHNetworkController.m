//
//  TXHNetworkController.m
//  TicketingHub
//
//  Created by Abizer Nasir on 23/09/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

// These are application / client specific constants
static NSString * const kClientId = @"ca99032b750f829630d8c9272bb9d3d6696b10f5bddfc34e4b7610eb772d28e7";
static NSString * const kClientSecret = @"f9ce1f4e1c74cc38707e15c0a4286975898fbaaf81e6ec900c71b8f4af62d09d";

// Error Domain
NSString * const TXHNetworkControllerErrorDomain = @"com.ticketinghub.TXHNetworControllerErrorDomain";

#import "TXHNetworkController.h"

#import "DCTCoreDataStack.h"
#import "TXHTicketingHubClient.h"
#import "TXHUserMO.h"
#import "TXHVenueMO.h"

@interface TXHNetworkController ()

@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) TXHTicketingHubClient *ticketingHubClient;

@end

@implementation TXHNetworkController

#pragma mark - Set up and tear down.

// Designated initialiser
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)moc {
    ZAssert(moc, @"cannot pass a nil moc parameter");

    if (!(self = [super init])) {
        return nil; // Bail!
    }

    _moc = moc;

    _ticketingHubClient = [TXHTicketingHubClient sharedClient];
    _ticketingHubClient.showActivityIndicatorAutomatically = YES;

    return self;
}

- (id)init {
    // _moc is nil, but the compiler doesn't know this, gets around the compiler check for non-nil attributes
    return [self initWithManagedObjectContext:_moc];
}

#pragma mark - Public methods

- (TXHUserMO *)currentUserInManagedObjectContext:(NSManagedObjectContext *)moc {
    ZAssert(moc, @"A valid managed object context is required to fetch the object into");

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[TXHUserMO entityName]];
    NSError *error;
    NSArray *users = [moc executeFetchRequest:request error:&error];

    if (!users) {
        DLog(@"Unable to fetch current user because: %@", error);
        return nil; // Bail!
    }

    ZAssert([users count] < 2, @"There should only be one current user's data in the store");

    return [users lastObject];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSError *))completionBlock {
    ZAssert(!isEmpty(username), @"username parameter cannot be empty or nil");
    ZAssert(!isEmpty(password), @"password parameter cannot be empty or nil");
    ZAssert(completionBlock, @"A completion block is required for this method");

    NSManagedObjectContext *localMoc = self.moc;

    [self.ticketingHubClient configureWithUsername:username password:password clientId:kClientId clientSecret:kClientSecret completion:^(id JSON, NSError *error) {
        if (error) {
            completionBlock(error);
            return; // Bail!
        }

        [self.ticketingHubClient userInformationWithCompletion:^(TXHUser *user, NSError *userError) {
            if (userError) {
                completionBlock(userError);
                return; // Bail!
            }

            // Clear out the existing user object from the data store - only one at a time for this app.
            TXHUserMO *currentUser = [self currentUserInManagedObjectContext:localMoc];
            if (currentUser) {
                [[currentUser managedObjectContext] deleteObject:currentUser];
            }

            // Create the new user and save it to the store
            [TXHUserMO userWithObject:user inManagedObjectContext:localMoc];
            [self.moc dct_save];

            completionBlock(nil);
        }];
    }];
}

- (void)fetchVenuesForCurrentUserWithCompletion:(void (^)(NSError *))completionBlock {
    ZAssert(completionBlock, @"A completion block is required for this method");

    NSManagedObjectContext *localMoc = self.moc;

    TXHUserMO *currentUser = [self currentUserInManagedObjectContext:localMoc];

    [self.ticketingHubClient venuesWithCompletion:^(NSArray *venues, NSError *error) {
        if (error) {
            completionBlock(error);
            return;  // Bail!
        }

        if ([venues count] == 0) {
            // Create and return a custom error 
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"No Venues", @"No Venues"),
                                       NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"There are no venues to display for the current user.", @"There are no venues to display for the current user.")};
            NSError *venueError = [NSError errorWithDomain:TXHNetworkControllerErrorDomain code:TXHNetworkControllerErrorNoVenues userInfo:userInfo];
            completionBlock(venueError);
            return; // Bail!
        }

        for (TXHVenue *venue in venues) {
            TXHVenueMO *venueMO = [TXHVenueMO venueWithObjectCreateIfNeeded:venue inManagedObjectContext:localMoc];
            venueMO.user = currentUser;
        }

        [localMoc dct_save];

        completionBlock(nil);
    }];
}



@end

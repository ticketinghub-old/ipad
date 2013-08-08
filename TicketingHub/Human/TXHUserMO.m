#import "TXHUserMO.h"

#import "TXHUser.h"


@interface TXHUserMO ()

// Private interface goes here.

@end


@implementation TXHUserMO

#pragma mark - Convenience constructors

+(instancetype)userWithObject:(TXHUser *)aUser inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    // As there is only one user object find and delete all the current ones
    NSFetchRequest *userRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];

    NSError *error;
    NSArray *users = [managedObjectContext executeFetchRequest:userRequest error:&error];

    if (!users) {
        DLog(@"Unable to fetch users because: %@", error);
        return nil; // Bail!
    }

    for (TXHUserMO *user in users) {
        [managedObjectContext deleteObject:user];
    }

    TXHUserMO *newUser = [self insertInManagedObjectContext:managedObjectContext];
    newUser.firstName = aUser.firstName;
    newUser.lastName = aUser.lastName;
    newUser.email = aUser.email;

    return newUser;
}

@end

#import "TXHPermissionMO.h"


@interface TXHPermissionMO ()

// Private interface goes here.

@end


@implementation TXHPermissionMO

+ (instancetype)permissionWithNameCreateIfNeeded:(NSString *)aName inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", TXHPermissionMOAttributes.name, aName];
    [request setPredicate:predicate];

    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];

    if (!results) {
        DLog(@"Unable to fetch permission with name: %@, because: %@", aName, error);
        return nil;
    }

    TXHPermissionMO *permission = [results firstObject];

    if (!permission) {
        permission = [self insertInManagedObjectContext:managedObjectContext];
        permission.name = aName;
    }

    return permission;
}

@end

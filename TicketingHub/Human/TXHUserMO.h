#import "_TXHUserMO.h"

@class TXHUser;

@interface TXHUserMO : _TXHUserMO {}

/*! Creates a TXHUserMO object from a TXHUser object in a provided managed object context.
 *
 *  As there is only one user at a time on the app, there is no checking if this object already exists.
 *  This is reset at log on.
 *  \param aUser the user object returned from a call to the library
 *  \param managedObjectContext the NSManagedObjectContext instance in which to create the new object.
 *  \returns a TXHUserMO object.
 */
+ (instancetype)userWithObject:(TXHUser *)aUser inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (NSString *)fullName;

@end

#import "_TXHPermissionMO.h"

@interface TXHPermissionMO : _TXHPermissionMO {}

/*! Returns or creates the a TXHPermisionMO object with the given name
 *  \param aName the name of the permisson
 *  \param managedObjectContext the managed object context in which to create the permission
 *  \returns a TXHPermissionMO object
 */
+ (instancetype)permissionWithNameCreateIfNeeded:(NSString *)aName inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

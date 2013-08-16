#import "_TXHVenueMO.h"

@class TXHVenue;

@interface TXHVenueMO : _TXHVenueMO {}

@property (strong, readonly, nonatomic) NSTimeZone *timeZone;

/*! Create or update an existing TXHVenueMO object with a TXHVenue object in a provided managed object context.
 *
 *  \param aVenue the user object returned from a call to the library
 *  \param managedObjectContext the NSManagedObjectContext instance in which to create the new object.
 *  \returns a TXHUserMO object.
 */
+ (instancetype)venueWithObjectCreateIfNeeded:(TXHVenue *)aVenue inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

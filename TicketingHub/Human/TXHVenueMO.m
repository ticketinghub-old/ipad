#import "TXHVenueMO.h"

#import "TXHVenue.h"
#import "TXHPermissionMO.h"


@interface TXHVenueMO ()

// Redeclare public readonly property as readwrite
@property (strong, nonatomic) NSTimeZone *timeZone;

@end


@implementation TXHVenueMO

@synthesize timeZone = _timeZone;

#pragma mark - Convenience constructor

+ (instancetype)venueWithObjectCreateIfNeeded:(TXHVenue *)aVenue inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSUInteger venueId = aVenue.venueId;

    NSFetchRequest *venueRequest = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    NSPredicate *venuePredicate = [NSPredicate predicateWithFormat:@"%K == %d", TXHVenueMOAttributes.venueId ,venueId];

    [venueRequest setPredicate:venuePredicate];

    NSError *error;
    NSArray *venues = [managedObjectContext executeFetchRequest:venueRequest error:&error];

    if (!venues) {
        DLog(@"Unable to fetch venues because: %@", error);
        return nil;
    }

    TXHVenueMO *venue = [venues firstObject];
    if (!venue) {
        // No existing object
        venue = [self insertInManagedObjectContext:managedObjectContext];
        venue.venueIdValue = venueId;
    }

    venue.venueName = aVenue.venueName;
    venue.street1 = aVenue.street1;
    venue.street2 = aVenue.street2;
    venue.city = aVenue.city;
    venue.region = aVenue.region;
    venue.postcode = aVenue.postcode;
    venue.country = aVenue.country;
    venue.latitudeValue = [aVenue locationCoordinates].latitude;
    venue.longitudeValue = [aVenue locationCoordinates].longitude;
    venue.currency = aVenue.currency;
    venue.website = aVenue.website;
    venue.email = aVenue.email;
    venue.telephone = aVenue.telephone;
    venue.establishmentType = aVenue.establishmentType;
    venue.stripePublishableKey  = aVenue.stripePublishableKey;

    venue.timeZoneName = aVenue.timeZoneName;
    if (!isEmpty(venue.timeZoneName)) {
        // Will set this to nil if the time zone cannot be created.
        venue.timeZone = [NSTimeZone timeZoneWithName:venue.timeZoneName];
    }

    for (NSString *permissionName in aVenue.permissions) {
        TXHPermissionMO *permission = [TXHPermissionMO permissionWithNameCreateIfNeeded:permissionName inManagedObjectContext:managedObjectContext];
        [permission addVenuesObject:venue];
    }

    return venue;
}

@end

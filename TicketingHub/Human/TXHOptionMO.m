#import "TXHOptionMO.h"

#import "TXHVenueMO.h"
#import "TXHOption.h"


@interface TXHOptionMO ()

// Private interface goes here.

@end


@implementation TXHOptionMO

#pragma mark - Convenience constructor

+ (instancetype)createWithOption:(TXHOption *)option forVenue:(TXHVenueMO *)venue {
    NSManagedObjectContext *moc = venue.managedObjectContext;

    TXHOptionMO *optionMO = [TXHOptionMO insertInManagedObjectContext:moc];

    optionMO.timeString = option.timeString;
    optionMO.durationValue = option.duration;
    optionMO.weekdayIndexValue = option.weekday;

    // Sets one side of the relationship
    optionMO.venue = venue;

    return optionMO;
}


@end

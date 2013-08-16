#import "TXHSeasonMO.h"

#import "TXHOption.h"
#import "TXHSeason.h"
#import "TXHVenueMO.h"
#import "TXHOptionMO.h"

@interface TXHSeasonMO ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end


@implementation TXHSeasonMO

@synthesize dateFormatter = _dateFormatter;

#pragma mark - Convenience constructor

+ (instancetype)createWithSeason:(TXHSeason *)season forVenue:(TXHVenueMO *)venue {
    NSManagedObjectContext *moc = venue.managedObjectContext;

    NSTimeZone *timeZone = venue.timeZone;
    if (!timeZone) {
        timeZone = [NSTimeZone systemTimeZone];
    }

    TXHSeasonMO *seasonMO = [TXHSeasonMO insertInManagedObjectContext:moc];
    seasonMO.dateFormatter.timeZone = timeZone;

    seasonMO.startDate = [seasonMO.dateFormatter dateFromString:season.startsOnDateString];
    seasonMO.endDate = [seasonMO.dateFormatter dateFromString:season.endsOnDateString];

    NSArray *options = season.seasonalOptions;

    for (TXHOption *option in options) {
        // This method already sets one side of the relationship, so it doesn't need to be set again.
        [TXHOptionMO createWithOption:option forVenue:venue];
    }

    return seasonMO;
}

#pragma mark - Custom accessors

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }

    return _dateFormatter;
}

@end
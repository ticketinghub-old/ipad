#import "_TXHSeasonMO.h"

@class TXHSeason;
@class TXHVenueMO;


@interface TXHSeasonMO : _TXHSeasonMO {}

+ (instancetype)createWithSeason:(TXHSeason *)season forVenue:(TXHVenueMO *)venue;

@end

#import "_TXHOptionMO.h"

@class TXHOption;

@interface TXHOptionMO : _TXHOptionMO {}

+ (instancetype)createWithOption:(TXHOption *)option forVenue:(TXHVenueMO *)venue;

@end

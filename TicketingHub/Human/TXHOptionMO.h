#import "_TXHOptionMO.h"

@class TXHOption;

@interface TXHOptionMO : _TXHOptionMO {}

/*! Creates the a TXHOptionMO object with the given option
 *
 *  This method adds the venue to the venue relationship, so it doesn't need to be set from the other side.
 *  It is created within the same managed object context as the venue
 *  \param option a TXHOption object used to create the managed object version.
 *  \param venue the venue that this option is related to.
 *  \returns a TXHOptionMO object
 */
+ (instancetype)createWithOption:(TXHOption *)option forVenue:(TXHVenueMO *)venue;

@end

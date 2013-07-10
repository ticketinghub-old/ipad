//
//  TXHVenue.m
//  TicketingHub
//
//  Created by Mark on 09/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHVenue.h"

@interface TXHVenue ()

// Redefine as editable
@property (strong, nonatomic) NSNumber *venueID;

@end

@implementation TXHVenue

- (id)initWithData:(NSDictionary *)data {
  self = [super init];
  if (self) {
    [self setupWithData:data];
  }
  return self;
}

- (void)setupWithData:(NSDictionary *)data {
  self.venueID              = data[VENUE_ID];
  self.businessName         = data[VENUE_BUSINESS_NAME];
  self.address              = @{
                                ADDRESS_STREET_1     : data[ADDRESS_STREET_1],
                                ADDRESS_STREET_2     : data[ADDRESS_STREET_2],
                                ADDRESS_CITY         : data[ADDRESS_CITY],
                                ADDRESS_REGION       : data[ADDRESS_REGION],
                                ADDRESS_POSTAL_CODE  : data[ADDRESS_POSTAL_CODE],
                                ADDRESS_COUNTRY      : data[ADDRESS_COUNTRY]
                                };
  self.latitude             = data[VENUE_LATITUDE];
  self.longitude            = data[VENUE_LONGITUDE];
  self.currency             = data[VENUE_CURRENCY];
  self.timeZone             = [NSTimeZone timeZoneWithName:data[VENUE_TIME_ZONE]];
  self.website              = [NSURL URLWithString:data[VENUE_WEBSITE]];
  self.email                = data[VENUE_EMAIL];
  self.telephone            = data[VENUE_TELEPHONE];
  self.stripePublishableKey = data[VENUE_STRIPE_PUBLISHABLE_KEY];
}

@end

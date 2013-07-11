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
  id temp = data[VENUE_ID];
  if (temp != nil) {
    self.venueID = temp;
  }

  temp = data[VENUE_BUSINESS_NAME];
  if (temp != nil) {
    self.businessName = temp;
  }
  NSMutableDictionary *address = [NSMutableDictionary dictionary];
  temp = data[ADDRESS_STREET_1];
  if (temp != nil) {
    address[ADDRESS_STREET_1] = temp;
  }
  temp = data[ADDRESS_STREET_2];
  if (temp != nil) {
    address[ADDRESS_STREET_2] = temp;
  }
  temp = data[ADDRESS_CITY];
  if (temp != nil) {
    address[ADDRESS_CITY] = temp;
  }
  temp = data[ADDRESS_REGION];
  if (temp != nil) {
    address[ADDRESS_REGION] = temp;
  }
  temp = data[ADDRESS_POSTAL_CODE];
  if (temp != nil) {
    address[ADDRESS_POSTAL_CODE] = temp;
  }
  temp = data[ADDRESS_COUNTRY];
  if (temp != nil) {
    address[ADDRESS_COUNTRY] = temp;
  }
  self.address = address;
  
  temp = data[VENUE_LATITUDE];
  if (temp != nil) {
    self.latitude = temp;
  }
  
  temp = data[VENUE_LONGITUDE];
  if (temp != nil) {
    self.longitude = temp;
  }
  
  temp = data[VENUE_CURRENCY];
  if (temp != nil) {
    self.currency = temp;
  }
  
  temp = data[VENUE_TIME_ZONE];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    NSTimeZone *zone =[NSTimeZone timeZoneWithName:temp];
    if (zone != nil) {
      self.timeZone = zone;
    }
  }
  
  temp = data[VENUE_WEBSITE];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    NSURL *webURL = [NSURL URLWithString:data[VENUE_WEBSITE]];
    if (webURL != nil) {
      self.website = webURL;
    }
  }
  
  temp = data[VENUE_EMAIL];
  if (temp != nil) {
    self.email = data[VENUE_EMAIL];
  }
  
  temp = data[VENUE_TELEPHONE];
  if (temp != nil) {
    self.telephone = temp;
  }
  
  temp = data[VENUE_ESTABLISHMENT_TYPE];
  if (temp != nil) {
    self.establishment_type = temp;
  }
  
  temp = data[VENUE_STRIPE_PUBLISHABLE_KEY];
  if (temp != nil) {
    self.stripePublishableKey = temp;
  }
}

@end

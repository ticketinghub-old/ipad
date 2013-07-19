//
//  TXHVenue.m
//  TicketingHub
//
//  Created by Mark on 09/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHVenue.h"
#import "TXHAppDelegate.h"
#import "TXHServerAccessManager.h"
#import "MOVenue.h"
#import "TXHSeason.h"
#import "TXHVariation.h"

static NSString* const  VENUE_ID =                      @"id";
static NSString* const  VENUE_BUSINESS_NAME =           @"name";
static NSString* const  ADDRESS_STREET_1 =              @"street_1";
static NSString* const  ADDRESS_STREET_2 =              @"street_2";
static NSString* const  ADDRESS_CITY =                  @"city";
static NSString* const  ADDRESS_REGION =                @"region";
static NSString* const  ADDRESS_POSTAL_CODE =           @"postcode";
static NSString* const  ADDRESS_COUNTRY =               @"country";
static NSString* const  VENUE_LATITUDE =                @"latitude";
static NSString* const  VENUE_LONGITUDE =               @"longitude";
static NSString* const  VENUE_CURRENCY =                @"currency";
static NSString* const  VENUE_TIME_ZONE =               @"time_zone";
static NSString* const  VENUE_WEBSITE =                 @"website";
static NSString* const  VENUE_EMAIL =                   @"email";
static NSString* const  VENUE_TELEPHONE =               @"telephone";
static NSString* const  VENUE_ESTABLISHMENT_TYPE =      @"establishment_type";
static NSString* const  VENUE_STRIPE_PUBLISHABLE_KEY =  @"stripe_publishable_key";

@interface TXHVenue ()

// Redefine as editable
@property (strong, nonatomic) NSNumber        *venueID;

// Redefine as mutable
@property (strong, nonatomic) NSMutableArray  *seasons;
@property (strong, nonatomic) NSMutableArray  *variations;

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
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    self.venueID = temp;
  }

  temp = data[VENUE_BUSINESS_NAME];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    self.businessName = temp;
  }
  NSMutableDictionary *address = [NSMutableDictionary dictionary];
  temp = data[ADDRESS_STREET_1];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    address[ADDRESS_STREET_1] = temp;
  }
  temp = data[ADDRESS_STREET_2];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    address[ADDRESS_STREET_2] = temp;
  }
  temp = data[ADDRESS_CITY];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    address[ADDRESS_CITY] = temp;
  }
  temp = data[ADDRESS_REGION];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    address[ADDRESS_REGION] = temp;
  }
  temp = data[ADDRESS_POSTAL_CODE];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    address[ADDRESS_POSTAL_CODE] = temp;
  }
  temp = data[ADDRESS_COUNTRY];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    address[ADDRESS_COUNTRY] = temp;
  }
  self.address = address;
  
  temp = data[VENUE_LATITUDE];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    self.latitude = temp;
  }
  
  temp = data[VENUE_LONGITUDE];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    self.longitude = temp;
  }
  
  temp = data[VENUE_CURRENCY];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
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
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    self.email = data[VENUE_EMAIL];
  }
  
  temp = data[VENUE_TELEPHONE];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    self.telephone = temp;
  }
  
  temp = data[VENUE_ESTABLISHMENT_TYPE];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    self.establishmentType = temp;
  }
  
  temp = data[VENUE_STRIPE_PUBLISHABLE_KEY];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    self.stripePublishableKey = temp;
  }
}

- (TXHSeason *)currentSeason {
  if (self.seasons.count == 0) {
    return nil;
  }
  
  NSUInteger calendarUnits = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
  NSDateComponents *components = [[NSCalendar currentCalendar] components:calendarUnits fromDate:[NSDate date]];
  components.hour = 0.0f;
  components.minute = 0.0f;
  components.second = 0.0f;
  
  // Build a comparison date beginning at the start of the supplied day
  NSDate *referenceDate = [[NSCalendar currentCalendar] dateFromComponents:components];

  for (TXHSeason *season in self.seasons) {
    // Is the reference after the start of this season
    NSComparisonResult result = [referenceDate compare:season.startsOn];
    if (result != NSOrderedAscending) {
      // Is the reference date before the end of this season
      result = [referenceDate compare:season.endsOn];
      if (result != NSOrderedDescending) {
        // Reference date is in this season
        return season;
      }
    }
  }
  return nil;
}

- (TXHVariation *)currentVariation {
  if (self.variations.count == 0) {
    return nil;
  }
  
  NSUInteger calendarUnits = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
  NSDateComponents *components = [[NSCalendar currentCalendar] components:calendarUnits fromDate:[NSDate date]];
  components.hour = 0.0f;
  components.minute = 0.0f;
  components.second = 0.0f;
  
  // Build a comparison date beginning at the start of the supplied day
  NSDate *referenceDate = [[NSCalendar currentCalendar] dateFromComponents:components];

  for (TXHVariation *variation in self.variations) {
    // Is the reference date for this variation
    NSComparisonResult result = [referenceDate compare:variation.date];
    if (result == NSOrderedSame) {
      return variation;
    }
  }
  return nil;
}

- (void)addSeasonData:(NSArray *)seasonData {
  if (self.seasons == nil) {
    self.seasons = [NSMutableArray array];
  }
  [self.seasons removeAllObjects];
  for (NSDictionary *oneSeason in seasonData) {
    TXHSeason *season = [[TXHSeason alloc] initWithData:oneSeason forTimeZone:self.timeZone];
    if (season != nil) {
      [self.seasons addObject:season];
    }
  }
}

- (void)addVariationData:(NSArray *)variationData {
  if (self.variations == nil) {
    self.variations = [NSMutableArray array];
  }
  for (NSDictionary *oneVariation in variationData) {
    TXHVariation *variation = [[TXHVariation alloc] initWithData:oneVariation];
    if (variation != nil) {
      [self.variations addObject:variation];
    }
  }
}

@end

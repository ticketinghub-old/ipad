//
//  TXHVenue.m
//  TicketingHub
//
//  Created by Mark on 09/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHVenue.h"

#import "TXHAppDelegate.h"
#import "TXHSeason.h"
#import "TXHServerAccessManager.h"
#import "TXHTicketDetail.h"
#import "TXHVariation.h"

static NSString* const  venueID =                   @"id";
static NSString* const  venueBusinessName =         @"name";
static NSString* const  addressStreet1 =            @"street_1";
static NSString* const  addressStreet2 =            @"street_2";
static NSString* const  addressCity =               @"city";
static NSString* const  addressRegion =             @"region";
static NSString* const  addressPostCode =           @"postcode";
static NSString* const  venueCountry =              @"country";
static NSString* const  venueLatitude =             @"latitude";
static NSString* const  venueLongitude =            @"longitude";
static NSString* const  venueCurrency =             @"currency";
static NSString* const  venueTimeZone =             @"time_zone";
static NSString* const  venueWebsite =              @"website";
static NSString* const  venueEmail =                @"email";
static NSString* const  venueTelephone =            @"telephone";
static NSString* const  venueEstablishmentType =    @"establishment_type";
static NSString* const  venueStripePublishableKey = @"stripe_publishable_key";

@interface TXHVenue ()

// Redefine as editable
@property (strong, nonatomic) NSNumber          *venueID;

// Redefine as mutable
@property (strong, nonatomic) NSMutableArray    *seasons;
@property (strong, nonatomic) NSMutableArray    *variations;

@property (strong, nonatomic) TXHTicketDetail   *ticketDetail;

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
    id temp = data[venueID];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.venueID = temp;
    }
    
    temp = data[venueBusinessName];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.businessName = temp;
    }
    NSMutableDictionary *address = [NSMutableDictionary dictionary];
    temp = data[addressStreet1];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        address[addressStreet1] = temp;
    }
    temp = data[addressStreet2];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        address[addressStreet2] = temp;
    }
    temp = data[addressCity];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        address[addressCity] = temp;
    }
    temp = data[addressRegion];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        address[addressRegion] = temp;
    }
    temp = data[addressPostCode];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        address[addressPostCode] = temp;
    }
    self.address = address;
    
    temp = data[venueLatitude];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.latitude = temp;
    }
    
    temp = data[venueLongitude];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.longitude = temp;
    }
    
    temp = data[venueCountry];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.country = temp;
    }
    
    temp = data[venueCurrency];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.currency = temp;
    }
    
    temp = data[venueTimeZone];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        NSTimeZone *zone =[NSTimeZone timeZoneWithName:temp];
        if (zone != nil) {
            self.timeZone = zone;
        }
    }
    
    temp = data[venueWebsite];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        NSURL *webURL = [NSURL URLWithString:data[venueWebsite]];
        if (webURL != nil) {
            self.website = webURL;
        }
    }
    
    temp = data[venueEmail];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.email = data[venueEmail];
    }
    
    temp = data[venueTelephone];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.telephone = temp;
    }
    
    temp = data[venueEstablishmentType];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.establishmentType = temp;
    }
    
    temp = data[venueStripePublishableKey];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.stripePublishableKey = temp;
    }
}

- (NSArray *)allSeasons {
    return self.seasons;
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
    
    return [self seasonFor:referenceDate];
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

- (TXHSeason *)seasonFor:(NSDate *)date {
    for (TXHSeason *season in self.seasons) {
        // Is the date after the start of this season
        NSComparisonResult result = [date compare:season.startsOn];
        if (result != NSOrderedAscending) {
            // Is the date before the end of this season
            result = [date compare:season.endsOn];
            if (result != NSOrderedDescending) {
                // Reference date is in this season
                return season;
            }
        }
    }
    return nil;
}

- (void)addTicket:(TXHTicketDetail *)ticket {
    _ticketDetail = ticket;
}

@end

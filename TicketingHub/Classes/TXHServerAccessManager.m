//
//  TXHServerAccessManager.m
//  TicketingHub
//
//  Created by Mark on 09/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHServerAccessManager.h"
#import "TXHCommonNames.h"
#import "TXHTimeFormatter.h"
#import "TXHDataDownloader.h"
#import "TXHVenue.h"
#import "TXHSeason.h"
#import "TXHVariation.h"
#import "TXHTimeSlot.h"
#import "TXHTicketDetail.h"

#define TICKETINGHUB_AUTH @"https://api.ticketinghub.com/oauth"
#define TICKETINGHUB_API  @"https://api.ticketingHub.com"

@interface TXHServerAccessManager ()

@property (strong, nonatomic) NSString        *accessToken;
@property (strong, nonatomic) NSString        *refreshToken;

@property (weak, nonatomic)   TXHVenue        *currentVenue;

// Dictionary of timeslots available on specific dates.  Once calculated, timeslots are cached for later use.
@property (strong, nonatomic) NSMutableDictionary  *timeSlots;

@end

@implementation TXHServerAccessManager

#pragma mark - Singleton implementation

+ (TXHServerAccessManager *)sharedInstance {
    static TXHServerAccessManager *instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,
                  ^{
                      instance = [[super allocWithZone:nil] init];
                  });
    
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone {
#pragma unused(zone)
    return [self sharedInstance];
}

- (id)copyWithZone: (NSZone *)zone {
#pragma unused(zone)
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        //    self.accessToken = @"Gop3U0x4lkqDdiPaiVqWVw";
        [self registerForNotifications];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(venueSelected:) name:NOTIFICATION_VENUE_SELECTED object:nil];
    
    // Register for standard notifications when application enters foreground / background; or is terminated
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willTerminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
}

- (NSMutableDictionary *)timeSlots {
    if (_timeSlots == nil) {
        _timeSlots = [NSMutableDictionary dictionary];
    }
    return _timeSlots;
}

- (void)generateAccessTokenFor:(NSString *)user password:(NSString *)password completion:(void (^)())completion error:(void (^)(id))error {
    TXHDataDownloader *downloader = [[TXHDataDownloader alloc] initWithOwner:self];
    downloader.methodType = @"POST";
    downloader.urlString = [NSString stringWithFormat:@"%@/token", TICKETINGHUB_AUTH];
    downloader.httpPOSTBody = @{
                                @"grant_type"     : @"password",
                                @"username"       : user,
                                @"password"       : password,
                                @"client_id"      : @"ca99032b750f829630d8c9272bb9d3d6696b10f5bddfc34e4b7610eb772d28e7",
                                @"client_secret"  : @"f9ce1f4e1c74cc38707e15c0a4286975898fbaaf81e6ec900c71b8f4af62d09d",
                                };
    downloader.completionHandler = ^(id data){
        NSDictionary *dict = data;
        NSLog(@"getTokens:%@", dict.description);
        NSDictionary *payload = dict[@"payload"];
        NSDictionary *tokens = payload[@"data"];
        /*
         On success (i.e. status=200, we should get back payload data containing parameters as follows
         {
         "access_token" = "flydy1m16chf2Zj47Emdtw";
         "expires_in" = 3600;
         "refresh_token" = "aBaoEyxiYhFccmPQgQpB_qbFUfdG_P3gfwscTV71jLs";
         "token_type" = "bearer";
         }
         */
        self.accessToken = tokens[@"access_token"];
        self.refreshToken = tokens[@"refresh_token"];
        completion();
    };
    downloader.errorHandler = error;
    downloader.token = self.accessToken;
    [downloader execute];
}

- (void)getVenuesWithCompletionHandler:(void (^)(NSArray *))completion errorHandler:(void (^)(id))error {
    TXHDataDownloader *downloader = [[TXHDataDownloader alloc] initWithOwner:self];
    downloader.headerFields = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", self.accessToken]};
    downloader.urlString = [NSString stringWithFormat:@"%@/venues", TICKETINGHUB_API];
    downloader.completionHandler = ^(id data){
        NSDictionary *dict = data;
        NSDictionary *payload = dict[@"payload"];
        // Check the payload status for success
        NSNumber *statusNum = payload[@"status"];
        NSUInteger status = statusNum.unsignedIntegerValue;
        if (status == 200) {
            // Success
            NSArray *venues = payload[@"data"];
            [self buildVenues:venues];
            completion(self.venues);
        }
        else if (status == 401) {
            // Check for token expiry
        } else {
            // An error occurred
        }
        /*
         On success (i.e. status=200, we should get back payload data containing an array of venues, such as
         [
         {
         "id": 1000,
         "business_name": "London Eye",
         "street_1": "Millennium Pier",
         "street_2": null,
         "city": "London",
         "region": "London Borough of Lambeth",
         "postal_code": "SE1 7PB",
         "country": "GB",
         "latitude": 51.50361,
         "longitude": -0.11943,
         "currency": "GBP",
         "time_zone": "Europe/London",
         "website": "http://www.londoneye.com",
         "email": "support@londoneye.com",
         "telephone": "+448717813000",
         "stripe_publishable_key": "pk_live_g4RfHyJIdBz7Bs2efWP9dHlW"
         }
         ]
         
         otherwise we will get back a status of 401 with the following
         
         payload =     {
         data =         {
         error = "token_expired";
         "error_message" = "access_token has expired.";
         };
         status = 401;
         };
         
         OR we have a genuine error
         
         */
    };
    downloader.errorHandler = error;
    downloader.token = self.accessToken;
    [downloader execute];
}

- (void)buildVenues:(NSArray *)venues {
    NSMutableArray *venuesArray = [NSMutableArray array];
    for (NSDictionary *venueData in venues) {
        TXHVenue *venue = [[TXHVenue alloc] initWithData:venueData];
        if (venue != nil) {
            [venuesArray addObject:venue];
        }
    }
    self.venues = venuesArray;
}

- (void)getAvailabilityForVenue:(TXHVenue *)venue{
    TXHDataDownloader *downloader = [[TXHDataDownloader alloc] initWithOwner:self];
    downloader.headerFields = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", self.accessToken]};
    downloader.urlString = [NSString stringWithFormat:@"%@/venues/%d/seasons", TICKETINGHUB_API, venue.venueID.integerValue];
    downloader.completionHandler = ^(id data){
        NSDictionary *dict = data;
        NSDictionary *payload = dict[@"payload"];
        // Check the payload status for success
        NSNumber *statusNum = payload[@"status"];
        NSUInteger status = statusNum.unsignedIntegerValue;
        if (status == 200) {
            // Success
            NSArray *seasonData = payload[@"data"];
            [self.currentVenue addSeasonData:seasonData];
            [self getVariationsForVenue:venue];
        } else if (status == 401) {
            // Check for token expiry
        } else {
            // An error occurred
        }
    };
    downloader.errorHandler = ^(id reason){
        NSLog(@"Error retrieving variations:%@", ((NSError *)reason).description);
    };
    downloader.token = self.accessToken;
    [downloader execute];
}

- (void)getVariationsForVenue:(TXHVenue *)venue {
    TXHDataDownloader *downloader = [[TXHDataDownloader alloc] initWithOwner:self];
    downloader.headerFields = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", self.accessToken]};
    downloader.urlString = [NSString stringWithFormat:@"%@/venues/%d/variations", TICKETINGHUB_API, venue.venueID.integerValue];
    downloader.completionHandler = ^(id data){
        NSDictionary *dict = data;
        NSDictionary *payload = dict[@"payload"];
        // Check the payload status for success
        NSNumber *statusNum = payload[@"status"];
        NSUInteger status = statusNum.unsignedIntegerValue;
        if (status == 200) {
            // Success
            NSArray *variationData = payload[@"data"];
            [self.currentVenue addVariationData:variationData];
        }
        else if (status == 401) {
            // Check for token expiry
        } else {
            // An error occurred
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VENUE_UPDATED object:self.currentVenue];
    };
    downloader.errorHandler = ^(id reason){
        NSLog(@"Error retrieving variations:%@", ((NSError *)reason).description);
    };
    downloader.token = self.accessToken;
    [downloader execute];
}

- (NSArray *)timeSlotsFor:(NSDate *)date {
    // Make sure the date has no time element
    NSUInteger calendarUnits = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:calendarUnits fromDate:date];
    components.hour = 0.0f;
    components.minute = 0.0f;
    components.second = 0.0f;
    
    // See if there are any timeslots already for this date
    NSArray *existingTimeSlots = self.timeSlots[components];
    if (existingTimeSlots != nil) {
        return existingTimeSlots;
    }
    
    // We haven't calculated times as yet for this date, so build them now and add to the list
    NSMutableArray *newTimeSlots = [NSMutableArray array];
    
    // Build a comparison date beginning at the start of the supplied day
    NSDate *referenceDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSInteger weekDay = [components weekday];
    
    // Go for a variation first
    TXHVariation *variation = self.currentVenue.currentVariation;
    if (variation != nil) {
        for (TXHVariationOption *option in variation.options) {
            // We have timeslots for this date
            TXHTimeSlot *oneTimeSlot = [[TXHTimeSlot alloc] init];
            oneTimeSlot.date = referenceDate;
            oneTimeSlot.timeSlotStart = option.time;
            oneTimeSlot.duration = option.duration;
            oneTimeSlot.timeSlotEnd = option.time + option.duration;
            oneTimeSlot.title = option.title;
            [newTimeSlots addObject:oneTimeSlot];
        }
    }
    
    // Go through the current season options if there are no variations
    if (newTimeSlots.count == 0) {
        TXHSeason *season  = [self.currentVenue seasonFor:referenceDate];
        if (season != nil) {
            for (TXHSeasonOption *option in season.options) {
                // Is the reference date on the right day of the week
                if (weekDay == option.weekDay) {
                    // We have timeslots for this date
                    TXHTimeSlot *oneTimeSlot = [[TXHTimeSlot alloc] init];
                    oneTimeSlot.date = referenceDate;
                    oneTimeSlot.timeSlotStart = option.time;
                    oneTimeSlot.title = option.title;
                    [newTimeSlots addObject:oneTimeSlot];
                }
            }
        }
    }
    
    self.timeSlots[components] = newTimeSlots;
    return newTimeSlots;
}

- (void)cleanupMenu {
    //
    // When a new venue is selected associated data needs to be reset.
    //
    [self.timeSlots removeAllObjects];
}

- (void)getTicketOptionsForTimeSlot:(TXHTimeSlot *)timeslot completionHandler:(void (^)(TXHTicketDetail *))completion errorHandler:(void (^)(id))error {
    TXHDataDownloader *downloader = [[TXHDataDownloader alloc] initWithOwner:self];
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    downloader.headerFields = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", self.accessToken]};
    downloader.urlString = [NSString stringWithFormat:@"%@/venues/%d/option?date=%@&time=%@", TICKETINGHUB_API, self.currentVenue.venueID.integerValue, [dateFormatter stringFromDate:timeslot.date], [TXHTimeFormatter stringFromTimeInterval:timeslot.timeSlotStart]];
    downloader.completionHandler = ^(id data){
        NSDictionary *dict = data;
        NSDictionary *payload = dict[@"payload"];
        // Check the payload status for success
        NSNumber *statusNum = payload[@"status"];
        NSUInteger status = statusNum.unsignedIntegerValue;
        if (status == 200) {
            // Success
            NSDictionary *ticket = payload[@"data"];
            [self buildTicket:ticket forVenue:self.currentVenue];
            completion(self.currentVenue.ticketDetail);
        }
        else if (status == 401) {
            // Check for token expiry
        } else {
            // An error occurred
        }
        /*
         On success (i.e. status=200, we should get back payload data containing an array of venues, such as
         [
         {
         "id": 1000,
         "business_name": "London Eye",
         "street_1": "Millennium Pier",
         "street_2": null,
         "city": "London",
         "region": "London Borough of Lambeth",
         "postal_code": "SE1 7PB",
         "country": "GB",
         "latitude": 51.50361,
         "longitude": -0.11943,
         "currency": "GBP",
         "time_zone": "Europe/London",
         "website": "http://www.londoneye.com",
         "email": "support@londoneye.com",
         "telephone": "+448717813000",
         "stripe_publishable_key": "pk_live_g4RfHyJIdBz7Bs2efWP9dHlW"
         }
         ]
         
         otherwise we will get back a status of 401 with the following
         
         payload =     {
         data =         {
         error = "token_expired";
         "error_message" = "access_token has expired.";
         };
         status = 401;
         };
         
         OR we have a genuine error
         
         */
    };
    downloader.errorHandler = error;
    downloader.token = self.accessToken;
    [downloader execute];
}

- (void)buildTicket:(NSDictionary *)ticketData forVenue:(TXHVenue *)venue {
    NSMutableDictionary *mutableTicket = [ticketData mutableCopy];
    static NSNumberFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        formatter.currencyCode = venue.currency;
    }
    mutableTicket[@"dp"] = [NSNumber numberWithUnsignedInteger:formatter.maximumFractionDigits];
    mutableTicket[@"timezone"] = venue.timeZone;
    TXHTicketDetail *ticket = [[TXHTicketDetail alloc] initWithData:mutableTicket];
    if (ticket != nil) {
        [venue addTicket:ticket];
    }
}

- (NSString *)formatCurrencyValue:(NSNumber *)value {
    // get the current language for the user - will need to adopt kiosk language in due course
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLocale *locale;
    NSString *localeIdentifier = [NSString stringWithFormat:@"%@_%@", language, [self.currentVenue.country uppercaseString]];
    NSUInteger index = [[NSLocale availableLocaleIdentifiers] indexOfObject:localeIdentifier];
    if (index == NSNotFound) {
        locale = [NSLocale currentLocale];
    } else {
        locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.currencyCode = self.currentVenue.currency;
    if (locale) {
        formatter.locale = locale;
    }
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    return [formatter stringFromNumber:value];
}

#pragma mark - Notifications

//
// This notification is posted when a venue is selected from the menu
//
- (void)venueSelected:(NSNotification *)notification {
    // Venue is passed to us in the notification object
    TXHVenue *venue = [notification object];
    self.currentVenue = venue;
    // Clear down any details relating to a previously selected venue
    [self cleanupMenu];
    
    // Get the current availability for this venue
    [self getAvailabilityForVenue:venue];
}

- (void)willEnterForeground:(NSNotification *)notification {
#pragma unused (notification)
}

- (void)willResignActive:(NSNotification *)notification {
#pragma unused (notification)
}

- (void)willTerminate:(NSNotification *)notification {
#pragma unused (notification)
}


@end

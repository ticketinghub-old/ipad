//
//  TXHVenue.h
//  TicketingHub
//
//  Created by Mark on 09/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VENUE_ID                      @"id"
#define VENUE_BUSINESS_NAME           @"business_name"
#define ADDRESS_STREET_1              @"street_1"
#define ADDRESS_STREET_2              @"street_2"
#define ADDRESS_CITY                  @"city"
#define ADDRESS_REGION                @"region"
#define ADDRESS_POSTAL_CODE           @"postal_code"
#define ADDRESS_COUNTRY               @"country"
#define VENUE_LATITUDE                @"latitude"
#define VENUE_LONGITUDE               @"longitude"
#define VENUE_CURRENCY                @"currency"
#define VENUE_TIME_ZONE               @"time_zone"
#define VENUE_WEBSITE                 @"website"
#define VENUE_EMAIL                   @"email"
#define VENUE_TELEPHONE               @"telephone"
#define VENUE_STRIPE_PUBLISHABLE_KEY  @"stripe_publishable_key"


@interface TXHVenue : NSObject

@property (readonly, nonatomic) NSNumber      *venueID;

@property (strong, nonatomic)   NSString      *businessName;

@property (strong, nonatomic)   NSDictionary  *address;
/*
"street_1",
"street_2",
"city",
"region",
"postal_code",
"country",
*/

@property (strong, nonatomic)   NSNumber      *latitude;
@property (strong, nonatomic)   NSNumber      *longitude;

@property (strong, nonatomic)   NSString      *currency;
@property (strong, nonatomic)   NSTimeZone    *timeZone;

@property (strong, nonatomic)   NSURL         *website;
@property (strong, nonatomic)   NSString      *email;
@property (strong, nonatomic)   NSString      *telephone;

@property (strong, nonatomic)   NSString      *stripePublishableKey;

- (id)initWithData:(NSDictionary *)data;

@end

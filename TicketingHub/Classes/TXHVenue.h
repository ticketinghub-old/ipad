//
//  TXHVenue.h
//  TicketingHub
//
//  Created by Mark on 09/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TXHSeason;
@class TXHVariation;
@class TXHTicketDetail;

@interface TXHVenue : NSObject

@property (readonly, nonatomic) NSNumber            *venueID;

@property (strong, nonatomic)   NSString            *businessName;

// A contract can be suspended (or inactive) in which case selecting the venue results in an error
@property (strong, nonatomic)   NSDictionary        *contract;

@property (strong, nonatomic)   NSDictionary        *address;

@property (strong, nonatomic)   NSNumber            *latitude;
@property (strong, nonatomic)   NSNumber            *longitude;

@property (strong, nonatomic)   NSString            *currency;
@property (strong, nonatomic)   NSTimeZone          *timeZone;

@property (strong, nonatomic)   NSURL               *website;
@property (strong, nonatomic)   NSString            *email;
@property (strong, nonatomic)   NSString            *telephone;

@property (strong, nonatomic)   NSString            *establishmentType;

@property (strong, nonatomic)   NSString            *stripePublishableKey;

@property (readonly, nonatomic) NSArray             *allSeasons;

@property (readonly, nonatomic) TXHSeason           *currentSeason;
@property (readonly, nonatomic) TXHVariation        *currentVariation;

// Details of ticket type options available for this venue
@property (readonly, nonatomic) TXHTicketDetail     *ticketDetail;

- (id)initWithData:(NSDictionary *)data;

- (void)addSeasonData:(NSArray *)seasonData;
- (void)addVariationData:(NSArray *)variationData;

- (void)addTicket:(TXHTicketDetail *)ticket;

- (TXHSeason *)seasonFor:(NSDate *)date;

@end

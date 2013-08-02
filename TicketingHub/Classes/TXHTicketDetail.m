//
//  TXHTicketDetails.m
//  TicketingHub
//
//  Created by Mark on 17/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketDetail.h"
#import "TXHTicketTier.h"

static NSString* const TICKETTYPE_DATE =        @"date";
static NSString* const TICKETTYPE_TIME =        @"time";
static NSString* const TICKETTYPE_DURATION =    @"duration";
static NSString* const TICKETTYPE_LIMIT =       @"limit";
static NSString* const TICKETTYPE_TIERS =       @"tiers";

@implementation TXHTicketDetail

/*
 {
 "date": "2013-05-27",
 "time": "09:00",
 "duration": 3600,
 "limit": 30,
 "tiers": [
 {
 "id": 2000,
 "name": "Child",
 "description": "Under 18 years old",
 "commission": 50,
 "price": 800,
 "limit": 10,
 "size": 1
 },
 {
 "id": 2001,
 "name": "Adult",
 "description": "18 years old or more",
 "commission": 100,
 "price": 1200,
 "limit": 10,
 "size": 1
 }
 ]
 }
 */

- (id)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        [self setup:data];
    }
    return self;
}

- (void)setup:(NSDictionary *)data {
    NSTimeZone *timeZone = nil;
    id temp = data[@"timezone"];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        timeZone = temp;
    }
    
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        if (timeZone == nil) {
            timeZone = [[NSTimeZone alloc] initWithName:@"Europe/London"];
        }
        formatter.timeZone = timeZone;
        formatter.dateFormat = @"yyyy-MM-dd";
    }
    
    NSUInteger decimalPlaces = 0;
    temp = data[@"dp"];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        decimalPlaces = [temp unsignedIntegerValue];
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components;
    
    temp = data[TICKETTYPE_DATE];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        // Strip off any time component as we want a date relative to the venue
        NSDate *dateWithTime = [formatter dateFromString:temp];
        components = [calendar components:unit fromDate:dateWithTime];
        components.hour = 0;
        components.minute = 0;
        components.second = 0;
        self.date = [calendar dateFromComponents:components];
    }
    
    temp = data[TICKETTYPE_TIME];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        NSString *timeReceived = temp;
        NSArray *timeComponents = [timeReceived componentsSeparatedByString:@":"];
        components.hour = [[timeComponents firstObject] integerValue];
        components.minute = [[timeComponents lastObject] integerValue];
        NSDate *startTime = [calendar dateFromComponents:components];
        self.time = [startTime timeIntervalSinceDate:self.date];
    }
    
    temp = data[TICKETTYPE_DURATION];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.duration = [temp floatValue];
    }
    
    temp = data[TICKETTYPE_LIMIT];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.limit = temp;
    }
    
    temp = data[TICKETTYPE_TIERS];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        NSMutableArray *newTiers = [NSMutableArray array];
        NSArray *tiersArray = temp;
        for (NSDictionary *oneOption in tiersArray) {
            TXHTicketTier *tier = [[TXHTicketTier alloc] initWithData:oneOption numberOfDecimalPlaces:decimalPlaces];
            [newTiers addObject:tier];
        }
        self.tiers = [newTiers copy];
    }
}

@end

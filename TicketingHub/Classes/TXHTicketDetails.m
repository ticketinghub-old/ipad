//
//  TXHTicketDetails.m
//  TicketingHub
//
//  Created by Mark on 17/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketDetails.h"

#define TICKETTYPE_DATE         @"date"
#define TICKETTYPE_TIME         @"time"
#define TICKETTYPE_DURATION     @"duration"
#define TICKETTYPE_LIMIT        @"limit"
#define TICKETTYPE_TIERS        @"tiers"
#define TICKETTYPE_ID           @"id"
#define TICKETTYPE_NAME         @"name"
#define TICKETTYPE_DESCRIPTION  @"description"
#define TICKETTYPE_COMMMISSION  @"commission"
#define TICKETTYPE_PRICE        @"price"
#define TICKETTYPE_SIZE         @"size"

@implementation TXHTicketDetails

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
  id temp = data[TICKETTYPE_DATE];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    self.date = temp;
  }
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSUInteger unit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
  NSDateComponents *components = [calendar components:unit fromDate:self.date];
  NSDate *startOfDay = [calendar dateFromComponents:components];
  temp = data[TICKETTYPE_TIME];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    NSString *timeReceived = temp;
    NSArray *timeComponents = [timeReceived componentsSeparatedByString:@":"];
    components.hour = [[timeComponents firstObject] integerValue];
    components.minute = [[timeComponents lastObject] integerValue];
    NSDate *startTime = [calendar dateFromComponents:components];
    self.time = [startTime timeIntervalSinceDate:startOfDay];
  }

  temp = data[TICKETTYPE_DURATION];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    self.duration = [temp floatValue];
  }

  temp = data[TICKETTYPE_LIMIT];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    self.limit = temp;
  }
  
//  temp = data[TICKETTYPE_TIERS];
//  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
//    NSArray *tiersArray = temp;
//    NSMutableArray *newTiers = [NSMutableArray array];
//    for (NSDictionary *oneOption in tiersArray) {
//      TXHVariationOption *variationOption = [[TXHVariationOption alloc] init];
//      temp = oneOption[VARIATION_TIME];
//      if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
//      }
//      temp = oneOption[VARIATION_DURATION];
//      if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
//        variationOption.duration = [temp doubleValue];
//      }
//      temp = oneOption[VARIATION_TITLE];
//      if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
//        variationOption.title = temp;
//      }
//      [newOptions addObject:variationOption];
//    }
//    self.options = newOptions;
//  }
}

@end

//
//  TXHVariation.m
//  TicketingHub
//
//  Created by Mark on 15/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHVariation_old.h"


static NSString* const VARIATION_DATE =       @"date";
static NSString* const VARIATION_REFERENCE =  @"reference";
static NSString* const VARIATION_OPTIONS =    @"options";
static NSString* const VARIATION_TIME =       @"time";
static NSString* const VARIATION_DURATION =   @"duration";
static NSString* const VARIATION_TITLE =      @"title";

@implementation TXHVariationOption

@end

@implementation TXHVariation_old

- (id)initWithData:(NSDictionary *)data {
  self = [super init];
  if (self) {
    [self setup:data];
  }
  return self;
}

- (void)setup:(NSDictionary *)data {
  /*
   {
   "date": "2013-05-27",
   "reference": "Bank Holiday",
   "options": [
   {
   "time": "07:00",
   "duration": 7200,
   "title": "09:00"
   }
   ]
   },
   {
   "date": "2013-12-25",
   "reference": "Christmas",
   "options": []
   }
   */
  
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger calendarUnits = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components;
    
    id temp = data[VARIATION_DATE];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        NSDate *givenDate = [formatter dateFromString:temp];
        components = [calendar components:calendarUnits fromDate:givenDate];
        // Ensure there is no time component to this date
        components.hour = 0;
        components.minute = 0;
        components.second = 0.0;
        
        self.date = [calendar dateFromComponents:components];
    }
  
  temp = data[VARIATION_REFERENCE];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
      self.reference = temp;
  }
  
  temp = data[VARIATION_OPTIONS];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    NSArray *optionsArray = temp;
    NSMutableArray *newOptions = [NSMutableArray array];
    components = [calendar components:calendarUnits fromDate:[NSDate date]];
    NSDate *startOfDay = [calendar dateFromComponents:components];
    for (NSDictionary *oneOption in optionsArray) {
      TXHVariationOption *variationOption = [[TXHVariationOption alloc] init];
      temp = oneOption[VARIATION_TIME];
      if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        NSString *timeReceived = temp;
        NSArray *timeComponents = [timeReceived componentsSeparatedByString:@":"];
        components.hour = [[timeComponents firstObject] integerValue];
        components.minute = [[timeComponents lastObject] integerValue];
        NSDate *startTime = [calendar dateFromComponents:components];
        variationOption.time = [startTime timeIntervalSinceDate:startOfDay];
      }
      temp = oneOption[VARIATION_DURATION];
      if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        variationOption.duration = [temp doubleValue];
      }
      temp = oneOption[VARIATION_TITLE];
      if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        variationOption.title = temp;
      }
      [newOptions addObject:variationOption];
    }
    self.options = newOptions;
  }
}

@end

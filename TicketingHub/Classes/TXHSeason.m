//
//  TXHSeason.m
//  TicketingHub
//
//  Created by Mark on 15/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSeason.h"
#import "TXHTimeFormatter.h"

static NSString* const SEASON_START =     @"starts_on";
static NSString* const SEASON_END =       @"ends_on";
static NSString* const SEASON_OPTIONS =   @"options";
static NSString* const SEASON_WEEK_DAY =  @"wday";
static NSString* const SEASON_TIME =      @"time";

@implementation TXHSeasonOption

@end

@implementation TXHSeason

- (id)initWithData:(NSDictionary *)data forTimeZone:(NSTimeZone *)timeZone {
  self = [super init];
  if (self) {
    [self setup:data forTimeZone:timeZone];
  }
  return self;
}

- (void)setup:(NSDictionary *)data forTimeZone:(NSTimeZone *)timeZone {
  /*
   {
   "starts_on": "2013-05-01",
   "ends_on": "2013-09-30",
   "options": [
   {
   "wday": 1,
   "time": "08:00",
   "duration": 3600,
   "title": "08:00 to 09:00"
   },
   {
   "wday": 5,
   "time": "09:00",
   "duration": null,
   "title": "09:00"
   }
   ]
   }
   */
  
  static NSDateFormatter *formatter = nil;
  if (formatter == nil) {
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
  }
  
  id temp = data[SEASON_START];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    self.startsOn = [formatter dateFromString:temp];
  }
  
  temp = data[SEASON_END];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    self.endsOn = [formatter dateFromString:temp];
  }

  temp = data[SEASON_OPTIONS];
  if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
    NSArray *optionsArray = temp;
    NSMutableArray *newOptions = [NSMutableArray array];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:unit fromDate:[NSDate date]];
    NSDate *startOfDay = [calendar dateFromComponents:components];
    for (NSDictionary *oneOption in optionsArray) {
      TXHSeasonOption *seasonOption = [[TXHSeasonOption alloc] init];
      temp = oneOption[SEASON_WEEK_DAY];
      if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        seasonOption.weekDay = [temp integerValue] + 1; // Convert the server weekday to iOS calendar weekday
      }
      temp = oneOption[SEASON_TIME];
      if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        NSString *timeReceived = temp;
        NSArray *timeComponents = [timeReceived componentsSeparatedByString:@":"];
        components.hour = [[timeComponents firstObject] integerValue];
        components.minute = [[timeComponents lastObject] integerValue];
        NSDate *startTime = [calendar dateFromComponents:components];
        seasonOption.time = [startTime timeIntervalSinceDate:startOfDay];
      }
      seasonOption.title = [TXHTimeFormatter stringFromTimeInterval:seasonOption.time];
      [newOptions addObject:seasonOption];
    }
    self.options = newOptions;
  }
}

@end

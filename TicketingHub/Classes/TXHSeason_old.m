//
//  TXHSeason_old.m
//  TicketingHub
//
//  Created by Mark on 15/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHSeason_old.h"
#import "TXHTimeFormatter.h"

static NSString* const SEASON_START =     @"starts_on";
static NSString* const SEASON_END =       @"ends_on";
static NSString* const SEASON_OPTIONS =   @"options";
static NSString* const SEASON_WEEK_DAY =  @"wday";
static NSString* const SEASON_TIME =      @"time";

@implementation TXHSeason_oldOption

@end

@implementation TXHSeason_old

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
        formatter.timeZone = timeZone;
        formatter.dateFormat = @"yyyy-MM-dd";
    }
    
    NSUInteger calendarUnits = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components;
    
    id temp = data[SEASON_START];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        NSDate *givenDate = [formatter dateFromString:temp];
        components = [[NSCalendar currentCalendar] components:calendarUnits fromDate:givenDate];
        // Ensure there is no time component to this date
        components.hour = 0;
        components.minute = 0;
        components.second = 0.0;
        self.startsOn = [[NSCalendar currentCalendar] dateFromComponents:components];
    }
    
    temp = data[SEASON_END];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        NSDate *givenDate = [formatter dateFromString:temp];
        components = [[NSCalendar currentCalendar] components:calendarUnits fromDate:givenDate];
        // Set time to the end of this day
        components.hour = 23;
        components.minute = 59;
        components.second = 59;
        self.endsOn = [[NSCalendar currentCalendar] dateFromComponents:components];
    }
    
    temp = data[SEASON_OPTIONS];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        NSArray *optionsArray = temp;
        NSMutableArray *newOptions = [NSMutableArray array];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        components = [calendar components:unit fromDate:[NSDate date]];
        components.hour = 0;
        components.minute = 0;
        components.second = 0.0;
        NSDate *startOfDay = [calendar dateFromComponents:components];
        for (NSDictionary *oneOption in optionsArray) {
            TXHSeason_oldOption *seasonOption = [[TXHSeason_oldOption alloc] init];
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

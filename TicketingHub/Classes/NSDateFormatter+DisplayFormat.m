//
//  NSDateFormatter+DisplayFormat.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 21/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "NSDateFormatter+DisplayFormat.h"

@implementation NSDateFormatter (DisplayFormat)

+ (instancetype)txh_fullDateFormatter
{
    static NSDateFormatter *_dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterLongStyle;
        _dateFormatter.timeStyle = kCFDateFormatterShortStyle;
        _dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    });
    return _dateFormatter;
}

+ (instancetype)txh_dateFormatter
{
    static NSDateFormatter *_dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterLongStyle;
        _dateFormatter.timeStyle = kCFDateFormatterNoStyle;
        _dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    });
    return _dateFormatter;
}

+ (instancetype)txh_timeFormatter
{
    static NSDateFormatter *_dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterNoStyle;
        _dateFormatter.timeStyle = kCFDateFormatterShortStyle;
        _dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    });
    return _dateFormatter;
}

+ (NSString *)txh_fullDateStringFromDate:(NSDate *)date
{
    return [[self txh_fullDateFormatter] stringFromDate:date];
}

+ (NSString *)txh_dateStringFromDate:(NSDate *)date
{
    return [[self txh_dateFormatter] stringFromDate:date];
}

+ (NSString *)txh_timeStringFromDate:(NSDate *)date
{
    return [[self txh_timeFormatter] stringFromDate:date];
}

@end


//
//  TXHTimeFormatter.m
//  TicketingHub
//
//  Created by Mark on 17/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTimeFormatter.h"

@implementation TXHTimeFormatter

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval {
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];
    
    // Get conversion to years, months, weeks, days, hours, minutes, seconds
    unsigned int unitFlags = (NSSecondCalendarUnit  |
                              NSMinuteCalendarUnit  |
                              NSHourCalendarUnit    |
                              NSDayCalendarUnit);
    
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags
                                                      fromDate:date1
                                                        toDate:date2
                                                       options:NSCalendarWrapComponents];
    
    NSString *result;
    
    if ([conversionInfo day] > 0) {
        result =  [NSString stringWithFormat:@"%dd %02d:%02d:%02d",
                   [conversionInfo day],
                   [conversionInfo hour],
                   [conversionInfo minute],
                   [conversionInfo second]];
    } else {
        if ([conversionInfo hour] > 0) {
            result = [NSString stringWithFormat:@"%02d:%02d:%02d",
                      [conversionInfo hour],
                      [conversionInfo minute],
                      [conversionInfo second]];
        } else {
            result =  [NSString stringWithFormat:@"%02d:%02d",
                       [conversionInfo minute],
                       [conversionInfo second]];
        }
    }
    
    if ([result length] == 0) {
        if ([conversionInfo second] > 0) {
            result =  [NSString stringWithFormat:@"00:%02d",
                       [conversionInfo second]];
        }
    }
    return result;
}

@end

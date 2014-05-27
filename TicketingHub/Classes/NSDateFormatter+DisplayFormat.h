//
//  NSDateFormatter+DisplayFormat.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 21/03/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (DisplayFormat)

+ (instancetype)txh_fullDateFormatter;

+ (NSString *)txh_fullDateStringFromDate:(NSDate *)date;
+ (NSString *)txh_dateStringFromDate:(NSDate *)date;
+ (NSString *)txh_timeStringFromDate:(NSDate *)date;

@end

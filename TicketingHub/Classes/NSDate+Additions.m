//
//  NSDate+Additions.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 20/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

- (NSDate*)dateByAddingMonths:(NSInteger)months
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:months];
    
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:self options:0];
    
    return newDate;
}

+ (NSDateFormatter *)isoDateFormatter {
    
    static NSDateFormatter *_isoDateFormatter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _isoDateFormatter = [NSDateFormatter new];
        [_isoDateFormatter setDateFormat:@"yyyy-MM-dd"];
    });
    
    return _isoDateFormatter;
}

- (NSString *)isoDateString
{
    return [[[self class] isoDateFormatter] stringFromDate:self];
}

- (NSString *)daySuffix
{
    NSInteger day = [[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] components:NSDayCalendarUnit fromDate:self] day];
    if (day >= 11 && day <= 13) {
        return @"th";
    } else if (day % 10 == 1) {
        return @"st";
    } else if (day % 10 == 2) {
        return @"nd";
    } else if (day % 10 == 3) {
        return @"rd";
    } else {
        return @"th";
    }
}

@end

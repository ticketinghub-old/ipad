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

- (BOOL)isInThePast
{
    return ([self timeIntervalSinceNow] < 0);
}

- (NSInteger)daysFromNow
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:self];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:[NSDate date]];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

- (NSInteger)hoursFromNow
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSHourCalendarUnit startDate:&fromDate
                 interval:NULL forDate:self];
    [calendar rangeOfUnit:NSHourCalendarUnit startDate:&toDate
                 interval:NULL forDate:[NSDate date]];
    
    NSDateComponents *difference = [calendar components:NSHourCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference hour];
}

- (NSInteger)minutesFromNow
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSMinuteCalendarUnit startDate:&fromDate
                 interval:NULL forDate:self];
    [calendar rangeOfUnit:NSMinuteCalendarUnit startDate:&toDate
                 interval:NULL forDate:[NSDate date]];
    
    NSDateComponents *difference = [calendar components:NSMinuteCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference minute];
}


// code from GVCFoundation
+ (NSTimeInterval)gvc_iso8601DurationInterval:(NSString *)duration
{
	// implementation
	NSTimeInterval interval = 0;
	if ([duration characterAtIndex:0] == 'P')
	{
		BOOL isTimePortion = NO;
        
		duration = [duration substringFromIndex:1];
		if ([duration characterAtIndex:0] == 'T')
		{
			duration = [duration substringFromIndex:1];
			isTimePortion = YES;
		}
		
		NSScanner *iso8601duration = [NSScanner scannerWithString:duration];
		
		while ( [iso8601duration isAtEnd] == NO)
		{
			double value;
			NSString *units;
			char cUnit;
			
			if ([iso8601duration scanDouble:&value])
			{
				if ([iso8601duration scanCharactersFromSet:[NSCharacterSet uppercaseLetterCharacterSet] intoString:&units])
				{
					for (NSUInteger i = 0; i < [units length]; ++i)
					{
						cUnit = [units characterAtIndex:i];
						
						switch (cUnit)
						{
							case 'Y':
								interval += 31557600 * value;
								break;
							case 'M':
								interval += isTimePortion ? 60 * value : 2629800 * value;
								break;
							case 'W':
								interval += 604800 * value;
								break;
							case 'D':
								interval += 86400 * value;
								break;
							case 'H':
								interval += 3600 * value;
								break;
							case 'S':
								interval += value;
								break;
							case 'T':
								isTimePortion=YES;
								break;
						}
					}
				}
			}
			else
			{
				break;
			}
		}
        
	}
    
	return interval;
}


+ (NSString *)stringFromDuration:(NSTimeInterval)duration
{
    NSInteger hours = floor(duration/(60*60));
    NSInteger minutes = floor((duration/60) - hours * 60);
    
    NSMutableString *string = [NSMutableString string];
    
    if (hours > 0)
        [string appendFormat:@"%ld h ",(long)hours];
    
    if (minutes > 0)
        [string appendFormat:@"%ld min",(long)minutes];
    
    return [NSString stringWithString:string];
}

@end

//
//  NSDate+Additions.h
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 20/02/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

- (NSDate*)dateByAddingMonths:(NSInteger)months;

- (NSString *)isoDateString;

- (NSString *)daySuffix;

@end


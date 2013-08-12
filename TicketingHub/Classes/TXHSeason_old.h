//
//  TXHSeason_old.h
//  TicketingHub
//
//  Created by Mark on 15/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHSeason_oldOption : NSObject

@property (assign, nonatomic) NSInteger       weekDay;  // Sunday = 1, Monday = 2 .. Saturday = 7
@property (assign, nonatomic) NSTimeInterval  time;
@property (strong, nonatomic) NSString        *title;

@end

@interface TXHSeason_old : NSObject

@property (strong, nonatomic) NSDate  *startsOn;
@property (strong, nonatomic) NSDate  *endsOn;
@property (strong, nonatomic) NSArray *options;

- (id)initWithData:(NSDictionary *)data forTimeZone:(NSTimeZone *)timeZone;

@end

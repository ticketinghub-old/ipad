//
//  TXHTicketDetails.h
//  TicketingHub
//
//  Created by Mark on 17/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXHTicketDetail : NSObject

@property (strong, nonatomic) NSDate          *date;
@property (assign, nonatomic) NSTimeInterval  time;
@property (assign, nonatomic) NSTimeInterval  duration;
@property (strong, nonatomic) NSNumber        *limit;
@property (strong, nonatomic) NSArray         *tiers;

- (id)initWithData:(NSDictionary *)data;

@end

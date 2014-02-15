//
//  TXHTicketingHubClient+AppExtension.m
//  TicketingHub
//
//  Created by Abizer Nasir on 29/11/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketingHubClient+AppExtension.h"

@implementation TXHTicketingHubClient (AppExtension)

- (NSArray *)timeSlotsFor:(NSDate *)date {
    return @[];
}

- (void)getTicketOptionsForTimeSlot:(TXHTimeSlot_old *)timeslot completionHandler:(void (^)(id))completion errorHandler:(void (^)(id))error {
    completion(nil);
}


@end

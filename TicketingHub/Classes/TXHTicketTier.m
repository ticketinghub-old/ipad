//
//  TXHTicketTier.m
//  TicketingHub
//
//  Created by Mark on 30/07/2013.
//  Copyright (c) 2013 TicketingHub. All rights reserved.
//

#import "TXHTicketTier.h"
#import <math.h>

static NSString* const TICKETTYPE_ID =          @"id";
static NSString* const TICKETTYPE_NAME =        @"name";
static NSString* const TICKETTYPE_DESCRIPTION = @"description";
static NSString* const TICKETTYPE_COMMMISSION = @"commission";
static NSString* const TICKETTYPE_PRICE =       @"price";
static NSString* const TICKETTYPE_LIMIT =       @"limit";
static NSString* const TICKETTYPE_SIZE =        @"size";

@implementation TXHTicketTier

- (id)initWithData:(NSDictionary *)data numberOfDecimalPlaces:(NSUInteger)decimalPlaces {
    self = [super init];
    if (self) {
        [self setup:data numberOfDecimalPlaces:decimalPlaces];
    }
    return self;
}

- (void)setup:(NSDictionary *)data numberOfDecimalPlaces:(NSUInteger)numberOfDecimalPlaces {
    NSUInteger numDP = MAX(numberOfDecimalPlaces, 1);
    CGFloat currenccyFactor = pow(10, numDP);
    id temp = data[TICKETTYPE_ID];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.tierID = temp;
    }
    temp = data[TICKETTYPE_NAME];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.tierName = temp;
    }
    temp = data[TICKETTYPE_DESCRIPTION];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.tierDescription = temp;
    }
    temp = data[TICKETTYPE_COMMMISSION];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        // Commission is in subunits of the venue so divide by the number of decimal places
        self.commission = [NSNumber numberWithDouble:([temp doubleValue] / currenccyFactor)];
    }
    temp = data[TICKETTYPE_PRICE];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        // Price is in subunits of the venue so divide by the number of decimal places
        self.price = [NSNumber numberWithDouble:([temp doubleValue] / currenccyFactor)];
    }
    temp = data[TICKETTYPE_LIMIT];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.limit = temp;
    }
    temp = data[TICKETTYPE_SIZE];
    if ((temp != nil) && ([temp isKindOfClass:[NSNull class]] == NO)) {
        self.size = temp;
    }
}

@end

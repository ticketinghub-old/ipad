//
//  TXHCoupon+Helpers.m
//  TicketingHub
//
//  Created by Bartek Hugo Trzcinski on 08/09/14.
//  Copyright (c) 2014 TicketingHub. All rights reserved.
//

#import "TXHCoupon+Helpers.h"

@implementation TXHCoupon (Helpers)

- (BOOL)disabled
{
    return (self.maxRedemptions &&
            [self.redemptions integerValue] >= [self.maxRedemptions integerValue]);
}

@end
